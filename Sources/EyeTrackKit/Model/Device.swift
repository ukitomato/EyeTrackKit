//
//  Device.swift
//  
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import UIKit
import SceneKit
import ARKit

public enum DeviceType {
    case iPhone
    case iPad
}

// デバイス情報保持クラス
public class Device {
    public let type: DeviceType
    public let screenSize: CGSize
    public let screenPointSize: CGSize

    public var node: SCNNode
    public var screenNode: SCNNode

    init(type: DeviceType) {
        self.type = type
        switch type {
        case DeviceType.iPhone:
            self.screenSize = CGSize(width: 0.0714, height: 0.1440)
            self.screenPointSize = CGSize(width: 1125 / 3, height: 2436 / 3)
        case DeviceType.iPad:
            self.screenSize = CGSize(width: 0.1785, height: 0.2476)
            self.screenPointSize = CGSize(width: 1668 / 3, height: 2388 / 3)
        }

        // Node生成
        self.node = SCNNode()
        self.screenNode = {
            let screenGeometry = SCNPlane(width: 1, height: 1)
            screenGeometry.firstMaterial?.isDoubleSided = true
            screenGeometry.firstMaterial?.diffuse.contents = UIColor.green
            let vsNode = SCNNode()
            vsNode.geometry = screenGeometry
            return vsNode
        }()
        self.node.addChildNode(self.screenNode)

    }
}
