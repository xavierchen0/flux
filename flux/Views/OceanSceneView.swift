//
//  OceanSceneView.swift
//  flux
//
//  Created by Xavier Chen on 27/1/26.
//

import RealityKit
import SwiftUI

struct OceanSceneView: View {
    var amplitude: Float
    var boatType: BoatType

    var body: some View {
        RealityView { content in
            let rootAnchor = AnchorEntity(world: .zero)
            rootAnchor.name = "RootAnchor"

            createSkybox(rootAnchor: rootAnchor)
            setupEnvironment(rootAnchor: rootAnchor)
            createOcean(rootAnchor: rootAnchor)
            createBoat(rootAnchor: rootAnchor, boatType: boatType)

            content.add(rootAnchor)
            WaveSystem.registerSystem()

        } update: { content in
            // Constantly update the amplitude
            WaveSystem.amplitude = amplitude

            // Check if we need to swap the boat
            guard
                let rootAnchor = content.entities.first(where: {
                    $0.name == "RootAnchor"
                })
            else { return }

            if let existingBoat = rootAnchor.findEntity(named: "BoatContainer")
            {
                if let tracker = existingBoat.components[
                    BoatTrackerComponent.self
                ] {
                    if tracker.boatID != boatType.id {
                        existingBoat.removeFromParent()
                        createBoat(
                            rootAnchor: rootAnchor as! AnchorEntity,
                            boatType: boatType
                        )
                    }
                }
            } else {
                // Always create a boat (just in case)
                createBoat(
                    rootAnchor: rootAnchor as! AnchorEntity,
                    boatType: boatType
                )
            }
        }
        .ignoresSafeArea()
    }

    private func createSkybox(rootAnchor: AnchorEntity) {
        let mesh = MeshResource.generateSphere(radius: 100)
        let material = UnlitMaterial(color: .black)

        let skybox = ModelEntity(mesh: mesh, materials: [material])

        skybox.scale *= .init(x: -1, y: 1, z: 1)

        rootAnchor.addChild(skybox)
    }

    private func createOcean(rootAnchor: AnchorEntity) {
        let gridSize = 30
        let spacing: Float = 0.6

        let mesh = MeshResource.generateBox(size: spacing * 0.9)

        let material = SimpleMaterial(
            color: .cyan,
            roughness: 0.2,
            isMetallic: false
        )

        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let entity = ModelEntity(mesh: mesh, materials: [material])

                let x = (Float(row) - Float(gridSize) / 2) * spacing
                let z = (Float(col) - Float(gridSize) / 2) * spacing

                let position = SIMD3<Float>(x, 0, z)
                entity.position = position

                entity.components.set(WaveComponent(initialPosition: position))

                entity.components.set(
                    GroundingShadowComponent(castsShadow: true)
                )

                rootAnchor.addChild(entity)
            }
        }
    }

    private func createBoat(
        rootAnchor: AnchorEntity,
        boatType: BoatType
    ) {
        let boatEntity = boatType.createEntity()

        boatEntity.components.set(
            BoatComponent(
                initialPosition: boatEntity.position,
                initialOrientation: boatEntity.orientation
            )
        )

        boatEntity.components.set(
            GroundingShadowComponent(castsShadow: true)
        )

        boatEntity.components.set(BoatTrackerComponent(boatID: boatType.id))

        rootAnchor.addChild(boatEntity)
    }

    private func setupEnvironment(rootAnchor: AnchorEntity) {
        // Adjust camera such that ocean covers half the screen
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 48
        camera.look(at: [0, 4.6, 0], from: [10, 10, 10], relativeTo: nil)
        rootAnchor.addChild(camera)

        // Lighting to make the ocean look realistic, rather than flat, with a sunset vibe
        let sun = DirectionalLight()

        sun.light.color = .init(red: 1.0, green: 0.85, blue: 0.6, alpha: 1.0)

        sun.light.intensity = 20000

        // Create longer shadows
        sun.look(at: [0, 0, 0], from: [15, 4, -5], relativeTo: nil)

        sun.shadow = DirectionalLightComponent.Shadow(
            maximumDistance: 40,
            depthBias: 1
        )
        rootAnchor.addChild(sun)

        //    Provide reflection and brighten the scene
        let skyFill = DirectionalLight()

        skyFill.light.color = .init(red: 0.9, green: 0.7, blue: 0.8, alpha: 1.0)

        skyFill.light.intensity = 5000

        skyFill.look(at: [0, 0, 0], from: [-10, 8, -10], relativeTo: nil)
        rootAnchor.addChild(skyFill)
    }
}

#Preview {
    @Previewable @State var debugAmplitude: Float = 0.5

    ZStack {
        Color.black.ignoresSafeArea()

        OceanSceneView(amplitude: debugAmplitude, boatType: .buoy)
            .ignoresSafeArea()

        VStack {
            DecibelTextView(amplitude: debugAmplitude)
                .padding(.top, 20)
            Spacer()
        }

        VStack(alignment: .leading) {
            Spacer()
            Text("Simulate Volume: \(debugAmplitude, specifier: "%.2f")")
                .foregroundStyle(.white)
            Slider(value: $debugAmplitude, in: 0...1)
                .tint(.green)
        }
        .padding()
    }
}
