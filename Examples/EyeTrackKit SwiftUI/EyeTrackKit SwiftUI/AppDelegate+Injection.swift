//
//  AppDelegate+Injection.swift
//  EyeTrackKit SwiftUI
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import Resolver
import EyeTrackKit

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { EyeTrackController(device: Device(type: .iPhone), smoothingRange: 10, blinkThreshold: .infinity, isHidden: false) }.scope(application)
        register { DataController() }.scope(application)
    }
}
