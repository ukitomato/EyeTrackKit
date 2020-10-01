//
//  Eye.swift
//  
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import UIKit
import SceneKit
import ARKit

// 目情報保持クラス
public class Eye {
    public var lookAtPosition: CGPoint = CGPoint(x: 0, y: 0)
    public var blink: Float = 1.0
    public var node: SCNNode
    public var target: SCNNode


    init() {
        // Node生成
        self.node = {
            let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.1)
            geometry.radialSegmentCount = 3
            geometry.firstMaterial?.diffuse.contents = UIColor.red

            let eyeNode = SCNNode()
            eyeNode.geometry = geometry
            eyeNode.eulerAngles.x = -.pi / 2
            eyeNode.position.z = 0.1

            let parentNode = SCNNode()
            parentNode.addChildNode(eyeNode)
            return parentNode
        }()
        self.target = SCNNode()
        self.node.addChildNode(self.target)
        self.target.position.z = 2
    }

    // Deviceとの距離を取得
    public func getDistanceToDevice() -> Float {
        (self.node.worldPosition - SCNVector3Zero).length()
    }

    // [目と視点を結ぶ直線]と[デバイスのスクリーン平面]の交点を取得
    public func hittingAt(device: Device) -> CGPoint {
        let heightCompensation: CGFloat = 312

        let deviceScreenEyeHitTestResults = device.node.hitTestWithSegment(from: self.target.worldPosition, to: self.node.worldPosition, options: nil)
        for result in deviceScreenEyeHitTestResults {
            self.lookAtPosition.x = CGFloat(result.localCoordinates.x) / (device.screenSize.width / 2) * device.screenPointSize.width
            self.lookAtPosition.y = CGFloat(result.localCoordinates.y) / (device.screenSize.height / 2) * device.screenPointSize.height + heightCompensation
        }

        return self.lookAtPosition
    }
}
