//
//  EyeTrackInfo.swift
//  
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import ARKit

public class EyeTrackInfo{
    public var timestamp: Date
    public var frame: Int
    
    public var faceRotaion: SCNVector4
    
    public var facePosition: SCNVector3
    public var devicePosition: SCNVector3
    public var rightEyePotision: SCNVector3
    public var leftEyePotision: SCNVector3
    
    public var rightEyeLookAtPosition: SCNVector3
    public var leftEyeLookAtPosition: SCNVector3
    
    public var rightEyeLookAtPoint: CGPoint
    public var leftEyeLookAtPoint: CGPoint
    public var centerEyeLookAtPoint: CGPoint
    
    public var rightEyeBlink: Float
    public var leftEyeBlink: Float
    
    public var rightEyeDistance: Float
    public var leftEyeDistance: Float
    
    public var faceTracking: Bool
    
    public init(frame:Int, face: Face, device: Device, lookAtPoint: CGPoint) {
        self.frame = frame
        self.timestamp = Date.init()
        
        self.faceRotaion = face.node.worldOrientation
        
        self.facePosition = face.node.worldPosition
        self.devicePosition = device.node.worldPosition
        self.rightEyePotision = face.rightEye.node.worldPosition
        self.leftEyePotision = face.leftEye.node.worldPosition
        
        self.rightEyeLookAtPosition = face.rightEye.target.worldPosition
        self.leftEyeLookAtPosition = face.leftEye.target.worldPosition
        
        self.rightEyeLookAtPoint = face.rightEye.lookAtPoint
        self.leftEyeLookAtPoint = face.leftEye.lookAtPoint
        self.centerEyeLookAtPoint = lookAtPoint
        
        self.rightEyeBlink = face.rightEye.blink
        self.leftEyeBlink = face.leftEye.blink
        
        self.rightEyeDistance = face.rightEye.getDistanceToDevice()
        self.leftEyeDistance = face.leftEye.getDistanceToDevice()
    }
}
