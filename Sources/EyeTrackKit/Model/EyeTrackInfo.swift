//
//  EyeTrackInfo.swift
//  
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import ARKit

public class EyeTrackInfo{
    public static let CSV_COLUMNS = ["timestamp", "frame",
                                 "faceRotaion-x", "faceRotaion-y", "faceRotaion-z", "faceRotaion-w",
                                 "facePosition-x", "facePosition-y", "facePosition-z",
                                 "devicePosition-x", "devicePosition-y", "devicePosition-z",
                                 "rightEyePotision-x", "rightEyePotision-y", "rightEyePotision-z",
                                 "leftEyePotision-x", "leftEyePotision-y", "leftEyePotision-z",
                                 "rightEyeLookAtPosition-x", "rightEyeLookAtPosition-y", "rightEyeLookAtPosition-z",
                                 "leftEyeLookAtPosition-x", "leftEyeLookAtPosition-y", "leftEyeLookAtPosition-z",
                                 "rightEyeLookAtPoint-x", "rightEyeLookAtPoint-y",
                                 "leftEyeLookAtPoint-x", "leftEyeLookAtPoint-y",
                                 "centerEyeLookAtPoint-x", "centerEyeLookAtPoint-y",
                                 "rightEyeBlink", "leftEyeBlink",
                                 "rightEyeDistance", "leftEyeDistance"]
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
    
    public func toCSV() -> String {
        let detail = [dateToString(date: info.timestamp), String(info.frame)]
        let worldPosition = [
            String(info.faceRotaion.x), String(info.faceRotaion.y), String(info.faceRotaion.z), String(info.faceRotaion.w),
            String(info.facePosition.x), String(info.facePosition.y), String(info.facePosition.z),
            String(info.devicePosition.x), String(info.devicePosition.y), String(info.devicePosition.z),
            String(info.rightEyePotision.x), String(info.rightEyePotision.y), String(info.rightEyePotision.z),
            String(info.leftEyePotision.x), String(info.leftEyePotision.y), String(info.leftEyePotision.z)]
        let lookAtPosition = [
           String(info.rightEyeLookAtPosition.x), String(info.rightEyeLookAtPosition.y), String(info.rightEyeLookAtPosition.z),
           String(info.leftEyeLookAtPosition.x), String(info.leftEyeLookAtPosition.y), String(info.leftEyeLookAtPosition.z)]
        let lookAtPoint = [
            String(format: "%.4F", Float(info.rightEyeLookAtPoint.x)), String(format: "%.4F", Float(info.rightEyeLookAtPoint.y)),
            String(format: "%.4F", Float(info.leftEyeLookAtPoint.x)), String(format: "%.4F", Float(info.leftEyeLookAtPoint.y)),
            String(format: "%.4F", Float(info.centerEyeLookAtPoint.x)), String(format: "%.4F", Float(info.centerEyeLookAtPoint.y))]
        let eyeInfo = [
            String(info.rightEyeBlink), String(info.leftEyeBlink),
            String(info.rightEyeDistance), String(info.leftEyeDistance)]
        var row = detail + worldPosition
        row = row + lookAtPosition
        row = row + lookAtPoint
        row = row + eyeInfo
        return row
    }
}
