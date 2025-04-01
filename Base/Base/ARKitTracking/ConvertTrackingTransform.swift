//
//  ConvertTrackingTransform.swift
//  Base
//
//  Created by Sandra Feng on 2025-02-10.
//

import RealityKit
import ARKit
import simd

struct ConvertTrackingTransform {
    
    static func GetJointPosition(_ jointName: HandSkeleton.JointName,of handAnchor: HandAnchor?) -> SIMD3<Float>{
        guard let skeleton = handAnchor?.handSkeleton else {
            return .zero
        }
        return ((handAnchor?.originFromAnchorTransform ??  matrix_identity_float4x4) * skeleton.joint(jointName).anchorFromJointTransform).translation()
    }
    static func GetHeadPosition(_ headAnchor: DeviceAnchor?) -> SIMD3<Float>{
        return ((headAnchor?.originFromAnchorTransform ??  matrix_identity_float4x4)).translation()
    }
        
}
