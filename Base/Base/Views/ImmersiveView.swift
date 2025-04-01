//
//  ImmersiveView.swift
//  Base
//
//  Created by Sandra Feng on 2025-02-10.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    @Environment(Tracking.self) var tracking
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                
                
                let sphere = ModelEntity()
                sphere.components.set([
                    ModelComponent(
                        mesh: .generateSphere(radius: 0.01),
                        materials: [SimpleMaterial(color: .red, isMetallic: false)]),
                   
                    CollisionComponent(shapes: [
                        ShapeResource.generateSphere(radius: 0.02)
                    ], mode: .trigger)
                ])
//                immersiveContentEntity.addChild(sphere)
                content.add(immersiveContentEntity)
                content.add(sphere)
                
                immersiveContentEntity.components.set(ClosureComponent(closure: { deltaTime in
                    //add logic for tracking
                    //sample code for tracking index tip position with an entity
                    if let latestRightHand = tracking.latestRightHand {

                        sphere.transform.translation = ConvertTrackingTransform.GetJointPosition(.indexFingerTip, of: latestRightHand)
                    }
                    
                    
                }))
                
            }
        }
        .task {
            // Start hand tracking once the view starts.
            await tracking.startTracking()
        }
    }
}


