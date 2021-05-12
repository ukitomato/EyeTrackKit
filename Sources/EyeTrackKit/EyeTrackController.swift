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
import os

@available(iOS 13.0, *)
public class EyeTrackController: ObservableObject {
    public struct Params {
        var device: Device
        var smoothingRange: Int
        var blinkThreshold: Float
        var isHidden: Bool = true

        var description: [String: String] { ["device": "\(device.type.rawValue)", "smoothing_range": "\(smoothingRange)", "blink_threshold": "\(blinkThreshold)", "is_hidden": "\(isHidden)"] }
    }

    @Published public var eyeTrack: EyeTrack
    private var _view: EyeTrackView?
    @Published public var isHidden: Bool?
    private var sceneView: ARSCNView? = nil
    var anyCancellable: AnyCancellable? = nil
    private var logger: Logger = Logger(subsystem: "dev.ukitomato.EyeTrackKit", category: "EyeTrackController")
    private var params: Params

    public var onUpdate: (EyeTrackInfo?) -> Void {
        get {
            return self.eyeTrack.onUpdate
        }
        set {
            self.eyeTrack.onUpdate = newValue
        }
    }
    
    public var onUpdateFrame: (CVPixelBuffer?) -> Void {
        get {
            return self.eyeTrack.onUpdateFrame
        }
        set {
            self.eyeTrack.onUpdateFrame = newValue
        }
    }

    public var view: EyeTrackView {
        get {
            if self._view == nil {
                self._view = EyeTrackView(isHidden: isHidden!, eyeTrack: eyeTrack)
            }
            return self._view!
        }
    }

    public init(device: Device, smoothingRange: Int, blinkThreshold: Float, isHidden: Bool?) {
        self.params = Params(device: device, smoothingRange: smoothingRange, blinkThreshold: blinkThreshold, isHidden: isHidden ?? true)
        self.eyeTrack = EyeTrack(device: params.device, smoothingRange: params.smoothingRange, blinkThreshold: params.blinkThreshold)
        self.isHidden = params.isHidden
        anyCancellable = eyeTrack.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        logger.debug("EyeTrackKit was initialized | \(self.params.description)")
    }

    public func start() -> Void {
        logger.debug("start eye tracking")
        self._view?.start()
    }

    public func pause() -> Void {
        logger.debug("stop eye tracking")
        self._view?.pause()
    }

    public func hide() -> Void {
        self._view?.hide()
    }

    public func show() -> Void {
        self._view?.show()
    }

    public func showRayHint() -> Void {
        self.eyeTrack.showRayHint()
    }

    public func hideRayHint() -> Void {
        self.eyeTrack.hideRayHint()
    }

    /// start to record data
    public func startRecord() -> Void {
        logger.debug("start to record scene video")
        self.view.startRecord()
    }

    public func stopRecord(finished: @escaping (URL) -> Void = { _ in }, isExport: Bool = false) -> Void {
        self.view.stopRecord(finished: finished, isExport: isExport)
        logger.debug("stop to record scene video")
    }


    public var currentInfo: EyeTrackInfo? {
        return self.eyeTrack.info
    }

    public func reinit(device: Device?, smoothingRange: Int?, blinkThreshold: Float?, isHidden: Bool?) {
        self.params.device = device ?? self.params.device
        self.params.smoothingRange = smoothingRange ?? self.params.smoothingRange
        self.params.blinkThreshold = blinkThreshold ?? self.params.blinkThreshold
        self.params.isHidden = isHidden ?? self.params.isHidden
        self.isHidden = self.params.isHidden
        self.reset(params: self.params)
    }

    public func reset(params: Params) {
        self.eyeTrack = EyeTrack(device: params.device, smoothingRange: params.smoothingRange, blinkThreshold: params.blinkThreshold)
        self.isHidden = params.isHidden
        anyCancellable = eyeTrack.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        self._view = nil
        logger.debug("EyeTrackKit was initialized | \(params.description)")
    }
}
