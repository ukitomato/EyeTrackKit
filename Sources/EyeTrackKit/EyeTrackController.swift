//
//  EyeTrackController.swift
//
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import SwiftUI
import Combine



@available(iOS 13.0, *)
public class EyeTrackController: ObservableObject {
    @Published public var eyeTrack: EyeTrack
    private var _view: EyeTrackView?
    private var isHidden: Bool
    var anyCancellable: AnyCancellable? = nil

    public var onUpdate: (EyeTrackInfo?) -> Void {
        get {
            return self.eyeTrack.onUpdate
        }
        set {
            self.eyeTrack.onUpdate = newValue
        }
    }

    public init(type: DeviceType, smoothingRange: Int, blinkThreshold: Float, isHidden: Bool = true) {
        self.eyeTrack = EyeTrack(type: .iPhone, smoothingRange: smoothingRange, blinkThreshold: blinkThreshold)
        self.isHidden = isHidden
        anyCancellable = eyeTrack.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
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
        self.view.startRecord()
    }

    public func stopRecord(finished: @escaping (URL) -> Void = { _ in }, isExport: Bool = false) -> Void {
        self.view.stopRecord(finished: finished, isExport: isExport)
    }


    public var currentInfo: EyeTrackInfo? {
        return self.eyeTrack.info
    }

}
