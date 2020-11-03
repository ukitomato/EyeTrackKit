//
//  EyeTrackController.swift
//
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import SwiftUI
import Combine
import ARKit
import SceneKit

@available(iOS 13.0, *)
public class EyeTrackController: ObservableObject {
    @Published public var eyeTrack: EyeTrack
    private var _view: EyeTrackView?
    @Published public var isHidden: Bool
    private var sceneView: ARSCNView? = nil
    var anyCancellable: AnyCancellable? = nil

    public var onUpdate: (EyeTrackInfo?) -> Void {
        get {
            return self.eyeTrack.onUpdate
        }
        set {
            self.eyeTrack.onUpdate = newValue
        }
    }

    public init( device: Device, smoothingRange: Int, blinkThreshold: Float, isHidden: Bool = true) {
        self.eyeTrack = EyeTrack(device:device, smoothingRange: smoothingRange, blinkThreshold: blinkThreshold)
        self.isHidden = isHidden
        anyCancellable = eyeTrack.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        print("[EyeTrackController] EyeTrackKit was initialized for \(device.type.rawValue): smoothing range=\(smoothingRange)")
        print("[EyeTrackController] EyeTrackKit was set: smoothing range=\(smoothingRange)/blink threshold=\(blinkThreshold)/is hidden=\(isHidden)")
    }

    public var view: EyeTrackView {
        get {
            if self._view == nil {
                self._view = EyeTrackView(isHidden: isHidden, eyeTrack: eyeTrack)
            }
            return self._view!
        }
    }

    public func hide() -> Void {
        print("[EyeTrackController] show view")
        self._view?.hide()
    }

    public func show() -> Void {
        print("[EyeTrackController] hide view")
        self._view?.show()
    }

    public func showRayHint() -> Void {
        print("[EyeTrackController] show raycast hint")
        self.eyeTrack.showRayHint()
    }

    public func hideRayHint() -> Void {
        print("[EyeTrackController] hide raycast hint")
        self.eyeTrack.hideRayHint()
    }

    /// start to record data
    public func startRecord() -> Void {
        print("[EyeTrackController] start to record scene video")
        self.view.startRecord()
    }

    public func stopRecord(finished: @escaping (URL) -> Void = { _ in }, isExport: Bool = false) -> Void {
        self.view.stopRecord(finished: finished, isExport: isExport)
        print("[EyeTrackController] stop to record scene video")
    }


    public var currentInfo: EyeTrackInfo? {
        return self.eyeTrack.info
    }

    public func reinit(device: Device, smoothingRange: Int, blinkThreshold: Float, isHidden: Bool) {
        self.eyeTrack = EyeTrack(device: device, smoothingRange: smoothingRange, blinkThreshold: blinkThreshold)
        self.isHidden = isHidden
        anyCancellable = eyeTrack.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        self._view = nil
        print("[EyeTrackController] EyeTrackKit was initialized for \(device.type.rawValue): smoothing range=\(smoothingRange)")
        print("[EyeTrackController] EyeTrackKit was set: smoothing range=\(smoothingRange)/blink threshold=\(blinkThreshold)/is hidden=\(isHidden)")
    }
}
