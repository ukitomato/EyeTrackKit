//
//  ViewController.swift
//  Sample
//
//  Created by Yuki Yamato on 2020/11/03.
//

import UIKit
import SceneKit
import ARKit
import EyeTrackKit
import SwiftUI

class ViewController: EyeTrackViewController {
    var eyeTrackController: EyeTrackController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eyeTrackController = EyeTrackController(device: Device(type: .iPhone), smoothingRange: 10, blinkThreshold: .infinity, isHidden: true)
        self.eyeTrackController.onUpdate = { info in
            print(info?.centerEyeLookAtPoint.x, info?.centerEyeLookAtPoint.y)
        }
        self.initialize(eyeTrack: eyeTrackController.eyeTrack)
        self.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
