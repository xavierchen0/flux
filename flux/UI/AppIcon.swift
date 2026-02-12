//
//  AppIcon.swift
//  flux
//
//  Created by Xavier Chen on 3/2/26.
//
//  Only created to create a view for the app icon
//  Not used as a view or component

import SwiftUI
import RealityKit

struct AppIcon: View {
    let duck: BoatType = .rubberDuck

    var body: some View {
        RealityView { content in
            let root = AnchorEntity(world: .zero)

            // Lighting
            let sun = DirectionalLight()
            sun.light.color = .white
            sun.light.intensity = 15000
            sun.look(at: [0, 0, 0], from: [5, 10, 5], relativeTo: nil)
            sun.shadow = DirectionalLightComponent.Shadow(maximumDistance: 20, depthBias: 1)
            root.addChild(sun)

            let fill = DirectionalLight()
            fill.light.color = .init(white: 0.8, alpha: 1)
            fill.light.intensity = 6000
            fill.look(at: [0, 0, 0], from: [-5, 2, -2], relativeTo: nil)
            root.addChild(fill)

            // Ocean
            let p: Float = 0.05
            let gridSize = 40
            
            let waveMesh = MeshResource.generateBox(size: p * 0.95)
            let waveMat = SimpleMaterial(color: UIColor(red: 0.0, green: 0.5, blue: 0.9, alpha: 1), roughness: 0.3, isMetallic: false)

            for row in -gridSize/2..<gridSize/2 {
                for col in -gridSize/2..<gridSize/2 {
                    let entity = ModelEntity(mesh: waveMesh, materials: [waveMat])
                    let x = Float(row) * p
                    let z = Float(col) * p
                    
                    let dist = sqrt(x*x + z*z)
                    let y = (cos(dist * 15) * p * 1.2) - (dist * 0.15)
                    
                    entity.position = [x, y - 0.2, z]
                    root.addChild(entity)
                }
            }

            // Duck
            let boat = duck.createEntity()
            boat.position = [0, 0, 0]
            boat.scale = [2.0, 2.0, 2.0]
            boat.orientation = simd_quatf(angle: .pi / 6, axis: [0, 1, 0])
            root.addChild(boat)

            // Camera
            let camera = PerspectiveCamera()
            camera.camera.fieldOfViewInDegrees = 35
            camera.look(at: [0, 0.25, 0], from: [0.0, 2.2, 3.8], relativeTo: nil)
            
            root.addChild(camera)
            
            content.add(root)
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(red: 0.0, green: 0.2, blue: 0.5))
    }
}

#Preview {
    AppIcon()
        .frame(width: 500, height: 500)
}
