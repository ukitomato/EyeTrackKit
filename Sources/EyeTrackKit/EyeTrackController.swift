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
    @Published var eyeTrack: EyeTrack = EyeTrack(type: .iPhone, smoothingRange: 10, blinkThreshold: 0.4)
    private var _view: EyeTrackView?
    
    var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = eyeTrack.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    var view: EyeTrackView {
        get {
            if self._view == nil {
                self._view = EyeTrackView(isHidden: false, eyeTrack: eyeTrack)
            }
            return self._view!
        }
    }
    
    /// start to record data
    public func start() -> Void {
        view.startRecord()
    }
    
    public func stop() -> Void {
        view.stopRecord()
    }

}
