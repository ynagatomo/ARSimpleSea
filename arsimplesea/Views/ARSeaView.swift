//
//  ARSeaView.swift
//  arsimplesea
//
//  Created by Yasuhito NAGATOMO on 2022/03/16.
//

import UIKit
import Combine
import RealityKit

class ARSeaView: ARView {
    enum State { case daytime, night }

    private var seaEntity: Entity?
    private var accumulativeTime: Double = 0.0
    private var renderLoopSubscription: Cancellable?
    private var sceneState: State = .daytime

    // configuration constants placed here for clarity
    // move and/or modify as you like
    private let worldOriginDevice: SIMD3<Float> = [0.0, 0.0, -0.3]
    private let worldOriginMac: SIMD3<Float> = [0.0, -0.1, 1.5]
    private let seaEntityRotationCycle = Float(60.0) // [sec]
    private let surfaceEntityName = "Surface"
    private let baseEntityName = "Base"
    private let geometryModifierName = "waveGeometryModifier"
    private let nightImageTextureName = "nightTexture2"
    private let daytimeDuration: Double = 30.0 // [sec]

    /// Setup the AnchorEntity and Entity.
    /// - Parameter name: USDZ model file name
    func setupScene(name: String) {
        var anchorEntity: AnchorEntity!
        #if targetEnvironment(simulator)
            anchorEntity = AnchorEntity(world: worldOriginMac)
        #else
        if ProcessInfo.processInfo.isiOSAppOnMac {
            anchorEntity = AnchorEntity(world: worldOriginMac)
        } else {
            anchorEntity = AnchorEntity(world: worldOriginDevice)
        }
        #endif
        scene.addAnchor(anchorEntity)

        seaEntity = try? Entity.load(named: name)
        if let entity = seaEntity {
            prepareMaterial()
            anchorEntity.addChild(entity)
        }
    }

    /// Start the time-based animation.
    func startPlaying() {
        guard seaEntity != nil else { return }

        renderLoopSubscription = scene.subscribe(to: SceneEvents.Update.self) { event in
            DispatchQueue.main.async {
                self.update(deltaTime: event.deltaTime)
            }
        }
    }

    /// Stop the time-based animation.
    func stopPlaying() {
        renderLoopSubscription?.cancel()
    }

    /// Update the time-based animation according to the delta-time.
    /// - Parameter deltaTime: delta-time [sec]
    private func update(deltaTime: Double) {
        guard let seaEntity = seaEntity else { return }

        accumulativeTime += deltaTime

        let angle = Float.pi * 2.0 * Float(accumulativeTime) / seaEntityRotationCycle
        let orientation = simd_quatf(angle: angle, axis: [0.0, 1.0, 0.0])
        seaEntity.orientation = orientation

        if sceneState == .daytime && accumulativeTime > daytimeDuration {
            sceneState = .night
            loadNightImageTexture()
            prepareMaterial()
        }
    }

    /// Setup the custom shader and attach it to the surface model-entity.
    private func prepareMaterial() {
        if let theEntity = seaEntity?.findEntity(named: surfaceEntityName),
           let modelEntity = theEntity as? ModelEntity {

            guard let device = MTLCreateSystemDefaultDevice() else {
                fatalError("Error: could not create the default metal device.")
            }
            let library = device.makeDefaultLibrary()!
            let geometryModifier = CustomMaterial.GeometryModifier(named: geometryModifierName,
                                                                   in: library)
            guard let customMaterials =
                    try? modelEntity.model?.materials.map({ material -> CustomMaterial in
                try CustomMaterial(from: material, geometryModifier: geometryModifier)
            }) else {
                return
            }
            modelEntity.model?.materials = customMaterials
        }
    }

    /// Load the night image texture and attach it to the surface and base entity.
    private func loadNightImageTexture() {
        guard let entity = seaEntity  else { return }

        var material = UnlitMaterial()
        if let textureResource = try? TextureResource.load(named: nightImageTextureName) {
            material.color.texture = PhysicallyBasedMaterial.Texture(textureResource)

            if let surfaceEntity = entity.findEntity(named: surfaceEntityName),
               let surfaceModelEntity = surfaceEntity as? ModelEntity {
                    surfaceModelEntity.model?.materials = [ material ]
            }

            if let baseEntity = entity.findEntity(named: baseEntityName),
               let baseModelEntity = baseEntity as? ModelEntity {
                    baseModelEntity.model?.materials = [ material ]
            }
        }
    }
}
