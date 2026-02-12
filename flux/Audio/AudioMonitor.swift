//
//  AudioMonitor.swift
//  flux
//
//  Created by Xavier Chen on 24/1/26.
//

import AVFoundation

@MainActor
@Observable
class AudioMonitor {
    var amplitude: Float = 0.0
    var currentError: AudioError?
    var showError: Bool = false

    private let engine = AVAudioEngine()

    func start() async {
        // Check microphone permission
        let isPermissionGranted = await checkPermission()
        guard isPermissionGranted else {
            triggerError(.permissionDenied)
            return
        }

        // Activate audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(
                .playAndRecord,
                mode: .measurement,
                options: [
                    .mixWithOthers, .defaultToSpeaker,
                    .overrideMutedMicrophoneInterruption,
                ]
            )
            try session.setActive(true)
        } catch {
            triggerError(.sessionActivationFailed)
            return
        }

        // Setup audio engine
        let inputNode = engine.inputNode
        let outputFormat = inputNode.outputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: outputFormat) {
            [weak self] buffer, _ in
            guard let self else { return }

            let level = self.calculateAmplitude(buffer: buffer)

            Task { @MainActor in
                self.amplitude = level
            }
        }

        engine.prepare()
        do {
            try engine.start()
        } catch {
            triggerError(.engineError)
        }

    }

    func stop() {
        if engine.isRunning {
            engine.stop()
        }

        engine.inputNode.removeTap(onBus: 0)

        do {
            try AVAudioSession.sharedInstance().setActive(
                false,
                options: .notifyOthersOnDeactivation
            )
        } catch {
            triggerError(.sessionDeActivationFailed)
        }
    }

    private func checkPermission() async -> Bool {
        let status = AVAudioApplication.shared.recordPermission
        switch status {
        case .undetermined:
            return await AVAudioApplication.requestRecordPermission()
        case .denied:
            return false
        case .granted:
            return true
        @unknown default:
            return false
        }
    }

    private func triggerError(_ error: AudioError) {
        self.currentError = error
        self.showError = true
    }

    nonisolated private func calculateAmplitude(buffer: AVAudioPCMBuffer)
        -> Float
    {
        guard let channelData = buffer.floatChannelData?[0] else { return 0.0 }
        let frameLength = Int(buffer.frameLength)
        var sum: Float = 0.0
        let step = 4  // Check every 4th num instead of every one to reduce CPU workload

        // Squaring it gives a better description of the magnitude
        for i in stride(from: 0, to: Int(frameLength), by: step) {
            let sample = channelData[i]
            sum += sample * sample
        }

        let sampleCount = Float(frameLength / step)  // Because we have a step size of 4
        let mean = sum / sampleCount

        let rms = sqrt(mean)  // Reverse the effect of previous squaring

        let db = 20 * log10(rms > 0 ? rms : 0.0001)  // Reference value 1.0 (digital ceiling)

        let minDb: Float = -60.0  // Arbitrary define -60 as the lowest possible db

        let clampedDb = max(minDb, db)

        let normalisedlevel = (clampedDb - minDb) / abs(minDb)  // Convert to percentage with baseline == minDb

        return normalisedlevel

    }

}
