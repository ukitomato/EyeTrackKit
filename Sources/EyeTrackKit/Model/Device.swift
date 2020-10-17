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

public enum DeviceType: String, CaseIterable {
    case iPhone = "iPhone"
    case iPad = "iPad"
    case iPadLandscape = "iPad Landscape"
}

// デバイス情報保持クラス
public class Device {
    public var type: DeviceType
    public var screenSize: CGSize
    public var screenPointSize: CGSize

    public var node: SCNNode
    public var screenNode: SCNNode
    public var compensation: CGPoint

    public init(screenSize: CGSize, screenPointSize: CGSize, compensation: CGPoint) {
        self.type = .iPad
        self.screenSize = screenSize
        self.screenPointSize = screenPointSize
        self.compensation = compensation
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

    public init(type: DeviceType) {
        self.type = type
        switch type {
        case DeviceType.iPhone:
            self.screenSize = CGSize(width: 0.0714, height: 0.1440)
            self.screenPointSize = CGSize(width: 1125 / 3, height: 2436 / 3)
            self.compensation = CGPoint(x: 0, y: 375)
        case DeviceType.iPad:
            self.screenSize = CGSize(width: 0.1785, height: 0.2476)
            self.screenPointSize = CGSize(width: 1668 / 2, height: 2388 / 2)
            self.compensation = CGPoint(x: 834, y: 0)
        case DeviceType.iPadLandscape:
            self.screenSize = CGSize(width: 0.2476, height: 0.1785)
            self.screenPointSize = CGSize(width: 2388 / 2, height: 1668 / 2)
            self.compensation = CGPoint(x: 0, y: 834)
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
