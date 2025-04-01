//
//  HandTracking.swift
//  Base
//
//  Created by Sandra Feng on 2025-02-10.
//

import RealityKit
import ARKit
import SwiftUI
@Observable
@MainActor class Tracking{
    /// The `ARKitSession` for hand tracking.
    let arSession = ARKitSession()
    
    /// The `HandTrackingProvider` for hand tracking.
    let handTracking = HandTrackingProvider()
    let worldTracking = WorldTrackingProvider()
    /// The current left hand anchor the app detects.
    var latestLeftHand: HandAnchor?
    
    /// The current right hand anchor the app detects.
    var latestRightHand: HandAnchor?
    var headAnchor: DeviceAnchor?
    /// Check whether the device supports hand tracking, and start the ARKit session.
    func startTracking() async {
        // Check if the device supports hand tracking.
        guard HandTrackingProvider.isSupported else {
            print("HandTrackingProvider is not supported on this device.")
            return
        }

        do {
            // Start the ARKit session with the `HandTrackingProvider`.
            try await arSession.run([handTracking, worldTracking])
        } catch let error as ARKitSession.Error {
            // Handle any ARKit errors.
            print("Encountered an error while running providers: \(error.localizedDescription)")
        } catch let error {
            // Handle any other unexpected errors.
            print("Encountered an unexpected error: \(error.localizedDescription)")
        }
        
        headAnchor = worldTracking.queryDeviceAnchor(atTimestamp: CACurrentMediaTime())
        // Assign the anchors based on the anchor updates.
        for await anchorUpdate in handTracking.anchorUpdates {
            switch anchorUpdate.anchor.chirality {
            case .left:
                self.latestLeftHand = anchorUpdate.anchor
            case .right:
                self.latestRightHand = anchorUpdate.anchor
            }
        }
    }
}
