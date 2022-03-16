//
//  ARContainerView.swift
//  arsimplesea
//
//  Created by Yasuhito NAGATOMO on 2022/03/16.
//

import SwiftUI
import ARKit

struct ARContainerView: UIViewRepresentable {
    let modelName = "sea.usdz"

    func makeUIView(context: Context) -> some UIView {
        var arView: ARSeaView!

        #if targetEnvironment(simulator)
        arView = ARSeaView(frame: .zero)
        #else
        if ProcessInfo.processInfo.isiOSAppOnMac {
            arView = ARSeaView(frame: .zero, cameraMode: .nonAR,
                               automaticallyConfigureSession: true)
        } else {
            arView = ARSeaView(frame: .zero, cameraMode: .ar,
                               automaticallyConfigureSession: false)
        }
        #endif

        arView.setupScene(name: modelName)

        #if !targetEnvironment(simulator)
        if !ProcessInfo.processInfo.isiOSAppOnMac {
            let config = ARWorldTrackingConfiguration()
            arView.session.run(config)
        }
        #endif

        arView.startPlaying()
        return arView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}


struct ARContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ARContainerView()
    }
}
