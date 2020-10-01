//
//  ContentView.swift
//  EyeTrackKit SwiftUI
//
//  Created by Yuki Yamato on 2020/10/01.
//

import SwiftUI
import Resolver
import EyeTrackKit

struct ContentView: View {
    @ObservedObject var eyeTrackController: EyeTrackController = Resolver.resolve()
    var body: some View {
        ZStack {
            eyeTrackController.view
            Circle()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 25, height: 25)
                .position(x: eyeTrackController.eyeTrack.lookAtPoint.x, y: eyeTrackController.eyeTrack.lookAtPoint.y)
        }
        Text("x: \(eyeTrackController.eyeTrack.lookAtPoint.x) y: \(eyeTrackController.eyeTrack.lookAtPoint.y)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
