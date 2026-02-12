//
//  WaveSystem.swift
//  flux
//
//  Created by Xavier Chen on 28/1/26.
//

import RealityKit
import SwiftUI

class WaveSystem: System {
    private static let waveQuery = EntityQuery(where: .has(WaveComponent.self))
    private static let boatQuery = EntityQuery(where: .has(BoatComponent.self))

    private static var wavePhase: Float = 0.0  // Track wave phase for smooth animations; in radians
    private static var minSpeed: Float = 2.0
    private static var ampSpeedMultiplier: Float = 2.0
    private static var minHeight: Float = 0.2
    private static var ampHeightMultiplier: Float = 1.5
    private static var swayDamping: Float = 0.8
    private static var maxSway: Float = 0.17
    private static var minSwayMultiplier: Float = 0.5

    static var amplitude: Float = 0.0  // From Audio recording

    private static var calmColor = UIColor(
        red: 0.0,
        green: 0.4,
        blue: 0.8,
        alpha: 1.0
    )
    private static var midColor = UIColor(
        red: 0.0,
        green: 0.8,
        blue: 0.3,
        alpha: 1.0
    )
    private static var loudColor = UIColor(
        red: 0.9,
        green: 0.1,
        blue: 0.1,
        alpha: 1.0
    )

    required init(scene: RealityKit.Scene) {}

    func update(context: SceneUpdateContext) {
        let dt = Float(context.deltaTime)
        let amp = Self.amplitude
        let speed = Self.minSpeed + (amp * Self.ampSpeedMultiplier)
        let heightMultiplier = Self.minHeight + (amp * Self.ampHeightMultiplier)

        // We want the wave to move with time, hence there is dt
        // but at the same time, since we want wave speed to vary with the amplitude,
        // we need to modify speed * dt.
        // Larger speed ==> larger change added to wavePhase ==> faster movement
        // vice versa
        Self.wavePhase += speed * dt

        // We cannot allow the wavePhase to increment indefinitely
        // Apply a reset according to the fact that 1 full rotation = 2 pi
        if Self.wavePhase > Float.pi * 2 {
            Self.wavePhase -= Float.pi * 2
        }

        // Animate waves
        for entity in context.scene.performQuery(Self.waveQuery) {
            guard let waveComponent = entity.components[WaveComponent.self]
            else { continue }

            let wavePos = waveComponent.initialPosition
            let wavePhase = Self.wavePhase

            let waveHeight =
                sin(wavePos.x + wavePhase) * cos(wavePos.z + wavePhase)

            entity.position.y = wavePos.y + (waveHeight * heightMultiplier)

            // Change wave color according to the amplitude
            if var modelComp = entity.components[ModelComponent.self] {
                let blended = getColors(amplitude: amp)
                let mat = SimpleMaterial(
                    color: blended,
                    roughness: 0.2,
                    isMetallic: false
                )
                modelComp.materials = [mat]
                entity.components[ModelComponent.self] = modelComp
            }
        }

        // Animate Boat
        for entity in context.scene.performQuery(Self.boatQuery) {
            guard let boatComponent = entity.components[BoatComponent.self]
            else { continue }

            // Modify height of waves
            let boatPos = boatComponent.initialPosition
            let wavePhase = Self.wavePhase

            let waveHeight =
                sin(boatPos.x + wavePhase) * cos(boatPos.z + wavePhase)
            // 1.05 is to ensure the boat sits on top of the wave
            let boatHeight = boatPos.y + (waveHeight * heightMultiplier) + 1.05

            entity.position.y = boatHeight

            // Modify swaying of waves
            let swayDamping = Self.swayDamping
            let maxSway = Self.maxSway
            let minSwayMultiplier = Self.minSwayMultiplier

            // Let the sway angle be influenced by the amplitude
            let swayAngle =
                sin(wavePhase * swayDamping)
                * (maxSway * (minSwayMultiplier + amp))

            let baseFacing = boatComponent.initialOrientation

            // Sway from side to side
            let swayRotation = simd_quatf(angle: swayAngle, axis: [0, 0, 1])

            let finalRotation = baseFacing * swayRotation

            entity.orientation = simd_slerp(
                entity.orientation,
                finalRotation,
                0.05
            )
        }
    }

    private func getColors(amplitude: Float) -> UIColor {
        let p = CGFloat(max(0, min(amplitude, 1.0)))

        if p < 0.5 {
            // First half: Blue to Green
            return blendColors(
                from: Self.calmColor,
                to: Self.midColor,
                percentage: p * 2
            )
        } else {
            // Second half: Green to Red
            return blendColors(
                from: Self.midColor,
                to: Self.loudColor,
                percentage: (p - 0.5) * 2
            )
        }
    }
}

func blendColors(from start: UIColor, to end: UIColor, percentage: CGFloat)
    -> UIColor
{
    var fRed: CGFloat = 0
    var fGreen: CGFloat = 0
    var fBlue: CGFloat = 0
    var fAlpha: CGFloat = 0
    var tRed: CGFloat = 0
    var tGreen: CGFloat = 0
    var tBlue: CGFloat = 0
    var tAlpha: CGFloat = 0

    start.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
    end.getRed(&tRed, green: &tGreen, blue: &tBlue, alpha: &tAlpha)

    // Ensure range of 0.0 - 1.0
    let p = max(0, min(percentage, 1.0))

    return UIColor(
        red: fRed + (tRed - fRed) * p,
        green: fGreen + (tGreen - fGreen) * p,
        blue: fBlue + (tBlue - fBlue) * p,
        alpha: 1.0
    )
}
