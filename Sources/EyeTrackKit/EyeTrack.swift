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
import os

@available(iOS 13.0, *)
public class EyeTrack: ObservableObject {
    private var bufferLookAtPosition: [CGPoint] = []
    @Published public var lookAtPosition: CGPoint = CGPoint(x: 0, y: 0)
    @Published public var lookAtPoint: CGPoint = CGPoint(x: 0, y: 0)
    @Published public var device: Device
    @Published public var face: Face
    @Published public var info: EyeTrackInfo? = nil
    @Published public var isShowRayHint: Bool

    private var sceneView: ARSCNView?

    var blinkThreshold: Float
    var smoothingRange: Int
    var updateCallback: (EyeTrackInfo?) -> Void = { _ in }
    var _updateFrame: (CVPixelBuffer?) -> Void = { _ in }

    var logger: Logger = Logger(subsystem: "dev.ukitomato.EyeTrackKit", category: "EyeTrack")

    var onUpdate: (EyeTrackInfo?) -> Void {
        get {
            return self.updateCallback
        }
        set {
            self.updateCallback = newValue
        }
    }

    var onUpdateFrame: (CVPixelBuffer?) -> Void {
        get {
            return self._updateFrame
        }
        set {
            self._updateFrame = newValue
        }
    }

    public init(device: Device, smoothingRange: Int = 1, blinkThreshold: Float = 1.0, isShowRayHint: Bool = false) {
        self.device = device
        self.face = Face(isShowRayHint: isShowRayHint)
        self.smoothingRange = smoothingRange
        self.blinkThreshold = blinkThreshold
        self.isShowRayHint = isShowRayHint
    }

    // SceneViewと紐つける
    public func registerSceneView(sceneView: ARSCNView) {
        self.sceneView = sceneView
        sceneView.scene.rootNode.addChildNode(self.face.node)
        sceneView.scene.rootNode.addChildNode(self.device.node)
    }

    public func showRayHint() {
        logger.debug("show raycast hint")
        self.isShowRayHint = true
        let old_face = self.face.node
        self.face = Face(isShowRayHint: true)
        self.sceneView?.scene.rootNode.replaceChildNode(old_face, with: self.face.node)
    }

    public func hideRayHint() {
        logger.debug("hide raycast hint")
        self.isShowRayHint = false
        let old_face = self.face.node
        self.face = Face(isShowRayHint: false)
        self.sceneView?.scene.rootNode.replaceChildNode(old_face, with: self.face.node)
    }


    // ARFaceAnchorを基に情報を更新
    public func update(anchor: ARFaceAnchor) {
        // 顔座標更新(眼球座標更新)
        self.face.update(anchor: anchor)
        // 瞬き判定
        if self.face.leftEye.blink > blinkThreshold {
            logger.debug("Close")
        } else {
            updateLookAtPosition()
        }
        self.info = EyeTrackInfo(face: face, device: device, lookAtPoint: lookAtPoint, isTracked: anchor.isTracked)
        updateCallback(info)
    }

    public func updateFrame(pixelBuffer: CVPixelBuffer) {
        self._updateFrame(pixelBuffer)
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
