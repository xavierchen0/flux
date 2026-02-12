//
//  BoatType.swift
//  flux
//
//  Created by Xavier Chen on 1/2/26.
//

import RealityKit
import SwiftUI

enum BoatType: String, CaseIterable, Identifiable, Codable {
    case regularBoat = "Rowboat"
    case rubberDuck = "Rubber Duck"
    case whale = "Whale"
    case pirateShip = "Pirate Ship"
    case buoy = "Buoy"

    var id: String { self.rawValue }

    var icon: String {
        switch self {
        case .regularBoat: return "🛶"
        case .rubberDuck: return "🦆"
        case .whale: return "🐳"
        case .pirateShip: return "🏴‍☠️"
        case .buoy: return "🛟"
        }
    }

    @MainActor
    func createEntity() -> Entity {
        let container = Entity()
        container.name = "BoatContainer"

        let p: Float = 0.05

        switch self {
        case .regularBoat:
            let wood = UIColor.brown
            let seatColor = UIColor.orange

            // Floor
            addBlock(
                to: container,
                size: [12 * p, 1 * p, 18 * p],
                color: wood,
                pos: [0, 0, 0]
            )

            // Walls (Left/Right)
            addBlock(
                to: container,
                size: [1 * p, 4 * p, 18 * p],
                color: wood,
                pos: [-6 * p, 2.5 * p, 0]
            )
            addBlock(
                to: container,
                size: [1 * p, 4 * p, 18 * p],
                color: wood,
                pos: [6 * p, 2.5 * p, 0]
            )

            // Walls (Front/Back)
            addBlock(
                to: container,
                size: [11 * p, 4 * p, 1 * p],
                color: wood,
                pos: [0, 2.5 * p, 9 * p]
            )
            addBlock(
                to: container,
                size: [11 * p, 4 * p, 1 * p],
                color: wood,
                pos: [0, 2.5 * p, -9 * p]
            )

            // Seats
            addBlock(
                to: container,
                size: [11 * p, 1 * p, 3 * p],
                color: seatColor,
                pos: [0, 2 * p, 4 * p]
            )
            addBlock(
                to: container,
                size: [11 * p, 1 * p, 3 * p],
                color: seatColor,
                pos: [0, 2 * p, -4 * p]
            )

            // Oars
            let oarColor = UIColor.lightGray
            addBlock(
                to: container,
                size: [16 * p, 1 * p, 1 * p],
                color: oarColor,
                pos: [-8 * p, 3 * p, 0]
            )
            addBlock(
                to: container,
                size: [16 * p, 1 * p, 1 * p],
                color: oarColor,
                pos: [8 * p, 3 * p, 0]
            )

            container.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])

        case .rubberDuck:
            let yellow = UIColor.systemYellow
            let orange = UIColor.systemOrange

            // Body
            addBlock(
                to: container,
                size: [10 * p, 6 * p, 14 * p],
                color: yellow,
                pos: [0, 3 * p, 0]
            )
            // Wings
            addBlock(
                to: container,
                size: [1 * p, 4 * p, 8 * p],
                color: yellow,
                pos: [5.5 * p, 3 * p, 0]
            )
            addBlock(
                to: container,
                size: [1 * p, 4 * p, 8 * p],
                color: yellow,
                pos: [-5.5 * p, 3 * p, 0]
            )
            // Head
            addBlock(
                to: container,
                size: [8 * p, 8 * p, 8 * p],
                color: yellow,
                pos: [0, 9 * p, 4 * p]
            )
            // Beak
            addBlock(
                to: container,
                size: [4 * p, 2 * p, 3 * p],
                color: orange,
                pos: [0, 8 * p, 9.5 * p]
            )
            // Eyes
            addBlock(
                to: container,
                size: [1 * p, 1 * p, 1 * p],
                color: .black,
                pos: [2 * p, 10 * p, 8.1 * p]
            )
            addBlock(
                to: container,
                size: [1 * p, 1 * p, 1 * p],
                color: .black,
                pos: [-2 * p, 10 * p, 8.1 * p]
            )

            // Headphones
            let headphoneColor = UIColor.red

            // Headphones handle
            addBlock(
                to: container,
                size: [10 * p, 1.5 * p, 3 * p],
                color: headphoneColor,
                pos: [0, 13.75 * p, 4 * p]
            )

            // Headphones Earcups Left to Right
            for side in [-1, 1] {
                let xPos = Float(side) * 5 * p

                // Earcups
                addBlock(
                    to: container,
                    size: [2 * p, 5 * p, 5 * p],
                    color: headphoneColor,
                    pos: [xPos, 9 * p, 4 * p]
                )

                // Earcups connector
                addBlock(
                    to: container,
                    size: [1.5 * p, 2 * p, 2 * p],
                    color: headphoneColor,
                    pos: [xPos, 12.25 * p, 4 * p]
                )
            }

            container.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])

        case .whale:
            let blue = UIColor.systemBlue
            let white = UIColor.white

            // Body
            addBlock(
                to: container,
                size: [10 * p, 8 * p, 16 * p],
                color: blue,
                pos: [0, 4 * p, 0]
            )

            // Tail
            addBlock(
                to: container,
                size: [6 * p, 4 * p, 6 * p],
                color: blue,
                pos: [0, 3 * p, -11 * p]
            )

            // Tail Fin
            addBlock(
                to: container,
                size: [12 * p, 1 * p, 4 * p],
                color: blue,
                pos: [0, 4 * p, -15 * p]
            )

            // Water Spout
            addBlock(
                to: container,
                size: [2 * p, 2 * p, 2 * p],
                color: white,
                pos: [0, 9 * p, 4 * p]
            )
            addBlock(
                to: container,
                size: [4 * p, 2 * p, 4 * p],
                color: white,
                pos: [0, 11 * p, 4 * p]
            )

            // Eyes (Right/Left)
            addBlock(
                to: container,
                size: [1 * p, 1 * p, 1 * p],
                color: .black,
                pos: [5.5 * p, 5 * p, 6 * p]
            )
            addBlock(
                to: container,
                size: [1 * p, 1 * p, 1 * p],
                color: .black,
                pos: [-5.5 * p, 5 * p, 6 * p]
            )

            container.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])

        case .pirateShip:
            let hullColor = UIColor(white: 0.2, alpha: 1.0)  // Dark Grey
            let cannonColor = UIColor.black

            // Hull
            addBlock(
                to: container,
                size: [10 * p, 6 * p, 18 * p],
                color: hullColor,
                pos: [0, 3 * p, 0]
            )

            //  Cannons (Right/Left)
            for i in -1...1 {
                let zPos = Float(i) * 5 * p

                addBlock(
                    to: container,
                    size: [2 * p, 1.5 * p, 1.5 * p],
                    color: cannonColor,
                    pos: [5.5 * p, 4 * p, zPos]
                )
                addBlock(
                    to: container,
                    size: [2 * p, 1.5 * p, 1.5 * p],
                    color: cannonColor,
                    pos: [-5.5 * p, 4 * p, zPos]
                )
            }

            // Raised Deck
            addBlock(
                to: container,
                size: [10 * p, 4 * p, 6 * p],
                color: hullColor,
                pos: [0, 8 * p, -6 * p]
            )

            // Mast
            addBlock(
                to: container,
                size: [2 * p, 22 * p, 2 * p],
                color: .brown,
                pos: [0, 14 * p, 2 * p]
            )

            // Sail
            addBlock(
                to: container,
                size: [14 * p, 10 * p, 1 * p],
                color: .white,
                pos: [0, 16 * p, 2 * p]
            )

            // "Jolly Roger" Flag
            // Black base
            addBlock(
                to: container,
                size: [10 * p, 6 * p, 1 * p],
                color: .black,
                pos: [0, 26 * p, 3 * p]
            )

            // Skull: Forehead
            addBlock(
                to: container,
                size: [4 * p, 2 * p, 1.2 * p],
                color: .white,
                pos: [0, 27 * p, 3 * p]
            )

            // Skull: Jaw
            addBlock(
                to: container,
                size: [2 * p, 1 * p, 1.2 * p],
                color: .white,
                pos: [0, 25.5 * p, 3 * p]
            )

            container.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])

        case .buoy:
            let red = UIColor.red
            let white = UIColor.white

            // Base
            addBlock(
                to: container,
                size: [10 * p, 6 * p, 10 * p],
                color: red,
                pos: [0, 0, 0]
            )

            // Tower
            addBlock(
                to: container,
                size: [4 * p, 12 * p, 4 * p],
                color: white,
                pos: [0, 9 * p, 0]
            )

            // Light
            addBlock(
                to: container,
                size: [2 * p, 2 * p, 2 * p],
                color: .yellow,
                pos: [0, 16 * p, 0]
            )
        }

        // Global transformations
        container.scale = [2.0, 2.0, 2.0]
        container.position = SIMD3<Float>(0, 0, 0)

        return container
    }

    // Helper to easily add blocks
    private func addBlock(
        to parent: Entity,
        size: SIMD3<Float>,
        color: UIColor,
        pos: SIMD3<Float>
    ) {
        let mesh = MeshResource.generateBox(size: size)
        let material = SimpleMaterial(
            color: color,
            roughness: 0.5,
            isMetallic: false
        )
        let block = ModelEntity(mesh: mesh, materials: [material])
        block.position = pos
        parent.addChild(block)
    }
}
