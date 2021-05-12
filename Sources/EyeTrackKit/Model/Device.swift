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
    case iPad = "iPad"
    case iPadLandscape = "iPad Landscape"
    case iPhone11 = "iPhone11"
    case iPhone11Pro = "iPhone11Pro"
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
        case DeviceType.iPhone11:
            self.screenSize = CGSize(width: 0.0757, height: 0.1509)
            self.screenPointSize = CGSize(width: 414, height: 896)
            self.compensation = CGPoint(x: 0, y: 414)
        case DeviceType.iPhone11Pro:
            self.screenSize = CGSize(width: 0.0714, height: 0.1440)
            self.screenPointSize = CGSize(width: 375, height: 812)
            self.compensation = CGPoint(x: 0, y: 375)
        case DeviceType.iPad:
            self.screenSize = CGSize(width: 0.1785, height: 0.2476)
            self.screenPointSize = CGSize(width: 834, height: 1194)
            self.compensation = CGPoint(x: 0, y: 417)
        case DeviceType.iPadLandscape:
            self.screenSize = CGSize(width: 0.2476, height: 0.1785)
            self.screenPointSize = CGSize(width: 1194, height: 834)
            self.compensation = CGPoint(x: 417, y: 0)
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
