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
            // create parent root entity
            let root = Entity()
            // load scene(.USDZ) from Reality composer in RealityKit content bundle
            if let immersiveContentEntity = try? await Entity(named: "DefaultScene", in: realityKitContentBundle) {
                root.addChild(immersiveContentEntity)
                
                
            }
            // create a model from scratch and assign it's position to right index tip
            let indexSphere = ModelEntity()
            indexSphere.components.set([
                ModelComponent(
                    mesh: .generateSphere(radius: 0.01),
                    materials: [SimpleMaterial(color: .red, isMetallic: false)]),
                
                CollisionComponent(shapes: [
                    ShapeResource.generateSphere(radius: 0.02)
                ], mode: .trigger)
            ])
            let headShpere = indexSphere.clone(recursive: true)
            root.addChild(indexSphere)
            root.addChild(headShpere)
            content.add(root)
            //set system component to root entity
            root.components.set(ClosureComponent(closure: { deltaTime in
                //updates every frame
                //add logic for tracking
                //sample code for tracking index tip position with an entity
                if tracking.worldTracking.state == .running {
                    let headAnchor = tracking.worldTracking.queryDeviceAnchor(atTimestamp: CACurrentMediaTime())
                    headShpere.transform.translation = ConvertTrackingTransform.GetHeadTranslation(headAnchor) - ConvertTrackingTransform.GetHeadForward(headAnchor) * 0.8
                }
                if let latestRightHand = tracking.latestRightHand {
                    indexSphere.transform.translation = ConvertTrackingTransform.GetJointTranslation(.indexFingerTip, of: latestRightHand)
                }
            }))
        }
        .task {
            // Start hand tracking once the view starts.
            await tracking.startTracking()
        }
    }
}


