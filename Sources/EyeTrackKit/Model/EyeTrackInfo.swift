//
//  EyeTrackself.swift
//
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import ARKit

public class EyeTrackInfo {
    private var formatter = DateFormatter()

    public static let CSV_COLUMNS = ["timestamp", "isTracked",
                                     "faceRotaion-x", "faceRotaion-y", "faceRotaion-z", "faceRotaion-w",
                                     "facePosition-x", "facePosition-y", "facePosition-z",
                                     "deviceRotation-x", "deviceRotation-y", "deviceRotation-z", "deviceRotation-w",
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
    public var isTracked: Bool

    public var faceRotaion: SCNVector4
    public var facePosition: SCNVector3
    
    public var devicePosition: SCNVector3
    public var deviceRotation: SCNVector4
    
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


    public init(face: Face, device: Device, lookAtPoint: CGPoint, isTracked: Bool) {
        self.timestamp = Date.init()
        self.isTracked = isTracked

        self.faceRotaion = face.node.worldOrientation
        self.facePosition = face.node.worldPosition
        self.deviceRotation = device.node.worldOrientation
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

        formatter.dateFormat = "yyyyMMddHHmmssSSSSS"
    }

    public var toCSV: [String] {
        let detail = [dateToString(date: self.timestamp), String(self.isTracked)]
        let worldPosition = [
            String(self.faceRotaion.x), String(self.faceRotaion.y), String(self.faceRotaion.z), String(self.faceRotaion.w),
            String(self.facePosition.x), String(self.facePosition.y), String(self.facePosition.z),
            String(self.deviceRotation.x), String(self.deviceRotation.y), String(self.deviceRotation.z), String(self.deviceRotation.w),
            String(self.devicePosition.x), String(self.devicePosition.y), String(self.devicePosition.z),
            String(self.rightEyePotision.x), String(self.rightEyePotision.y), String(self.rightEyePotision.z),
            String(self.leftEyePotision.x), String(self.leftEyePotision.y), String(self.leftEyePotision.z)]
        let lookAtPosition = [
            String(self.rightEyeLookAtPosition.x), String(self.rightEyeLookAtPosition.y), String(self.rightEyeLookAtPosition.z),
            String(self.leftEyeLookAtPosition.x), String(self.leftEyeLookAtPosition.y), String(self.leftEyeLookAtPosition.z)]
        let lookAtPoint = [
            String(format: "%.8F", Float(self.rightEyeLookAtPoint.x)), String(format: "%.8F", Float(self.rightEyeLookAtPoint.y)),
            String(format: "%.8F", Float(self.leftEyeLookAtPoint.x)), String(format: "%.8F", Float(self.leftEyeLookAtPoint.y)),
            String(format: "%.8F", Float(self.centerEyeLookAtPoint.x)), String(format: "%.8F", Float(self.centerEyeLookAtPoint.y))]
        let eyeself = [
            String(self.rightEyeBlink), String(self.leftEyeBlink),
            String(self.rightEyeDistance), String(self.leftEyeDistance)]
        var row = detail + worldPosition
        row = row + lookAtPosition
        row = row + lookAtPoint
        row = row + eyeself
        return row
    }

    public func dateToString(date: Date) -> String {
        return formatter.string(from: date)
    }
}
