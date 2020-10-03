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
    var dataController: DataController = Resolver.resolve()

    var body: some View {
        ZStack {
            eyeTrackController.view
            Circle()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 25, height: 25)
                .position(x: eyeTrackController.eyeTrack.lookAtPoint.x, y: eyeTrackController.eyeTrack.lookAtPoint.y)
        }
        HStack {
            Button(action: {
                eyeTrackController.start()
            }) {
                Text("Start")
            }
            Button(action: {
                //                eyeTrackController.stop(finished: {_ in}, isExport: true) // export video to Photo Library
                eyeTrackController.stop(finished: { path in print("Video File Path: \(path)") }, isExport: false) // export video to Documents folder
                dataController.export(name: "test01.csv", data: eyeTrackController.data)
            }) {
                Text("Stop")
            }
        }
        Text("x: \(eyeTrackController.eyeTrack.lookAtPoint.x) y: \(eyeTrackController.eyeTrack.lookAtPoint.y)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
