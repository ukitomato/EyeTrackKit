//
//  EyeTrack.swift
//  
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import SwiftUI
import UIKit
import SceneKit
import ARKit

public enum Status {
    case UNINITIALIZED
    case UNREGISTERED
    case ERROR
    case STANDBY
    case RECORDING
    case RECORDED
}

@available(iOS 13.0, *)
public class EyeTrack: ObservableObject {
    private var bufferLookAtPosition: [CGPoint] = []
    @Published public var data: [EyeTrackInfo] = []
    @Published public var lookAtPosition: CGPoint = CGPoint(x: 0, y: 0)
    @Published public var lookAtPoint: CGPoint = CGPoint(x: 0, y: 0)
    @Published public var device: Device
    @Published public var face: Face
    @Published public var frame: Int = 0
    
    private var status: Status
    
    var blinkThreshold: Float
    var smoothingRange: Int
    
    var onUpdate: () -> Void
    
    public init(type: DeviceType, smoothingRange: Int = 1, blinkThreshold: Float = 1.0, onUpdate: @escaping () -> Void = {}) {
        self.device = Device(type: type)
        self.face = Face()
        self.smoothingRange = smoothingRange
        self.blinkThreshold = blinkThreshold
        self.onUpdate = onUpdate
        self.status = Status.UNREGISTERED
    }

    // SceneViewと紐つける
    public func registerSceneView(sceneView: ARSCNView) {
        sceneView.scene.rootNode.addChildNode(self.face.node)
        sceneView.scene.rootNode.addChildNode(self.device.node)
        self.status = Status.STANDBY
    }

    // ARFaceAnchorを基に情報を更新
    public func update(anchor: ARFaceAnchor) {
        // 顔座標更新(眼球座標更新)
        self.face.update(anchor: anchor)
        // 瞬き判定
        if self.face.leftEye.blink > blinkThreshold {
            print("Close")
        } else {
            updateLookAtPosition()
        }
        
        // Save data
        switch status {
        case .UNINITIALIZED: break
        case .UNREGISTERED: break
        case .ERROR: break
        case .STANDBY: break
        case .RECORDING:
            data.append(EyeTrackInfo(frame: frame, face: face, device: device, lookAtPoint: lookAtPoint))
            frame = frame + 1
            break
        case .RECORDED:
            break
        }
        
        onUpdate()
    }
    
    public func setStatus(status: Status) {
        self.status = status
    }

    // 視点位置更新
    public func updateLookAtPosition() {
        let rightEyeHittingAt = self.face.rightEye.hittingAt(device: device)
        let leftEyeHittingAt = self.face.leftEye.hittingAt(device: device)
        let lookAt = CGPoint(x: (rightEyeHittingAt.x + leftEyeHittingAt.x) / 2, y: -(rightEyeHittingAt.y + leftEyeHittingAt.y) / 2)
        self.bufferLookAtPosition.append(lookAt)
        self.lookAtPosition = Array(self.bufferLookAtPosition.suffix(smoothingRange)).average!
        self.lookAtPoint = CGPoint(x: self.lookAtPosition.x + self.device.screenPointSize.width / 2, y: self.lookAtPosition.y + self.device.screenPointSize.height / 2)
    }
}
