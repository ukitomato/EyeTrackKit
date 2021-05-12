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
    @ObservedObject var dataController: DataController = Resolver.resolve()

    init() {
        let data: DataController = Resolver.resolve()
        self.eyeTrackController.onUpdate = { info in
            data.add(info: info!)
        }

        self.eyeTrackController.onUpdateFrame = { buffer in
            if buffer != nil {
                DispatchQueue.global(qos: .userInitiated).async {
                    let image = DataController.convertToUIImage(buffer!)
                    _ = DataController.saveImage(image: image!, path: DataController.createFilePath(filename: "\(DataController.dateToString(date: Date.init())).jpg"))
                }
            }
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            self.eyeTrackController.view
                .onAppear {
                self.eyeTrackController.start()
            }
                .onDisappear {
                self.eyeTrackController.pause()
            }
            Circle()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 25, height: 25)
                .position(x: eyeTrackController.eyeTrack.lookAtPoint.x, y: eyeTrackController.eyeTrack.lookAtPoint.y)
        }
            .edgesIgnoringSafeArea(.all)
        HStack {
            Button(action: {
                self.eyeTrackController.startRecord()
                self.dataController.start()
            }) {
                Text("Start")
            }
            Button(action: {
                self.dataController.stop()
                //                eyeTrackController.stop(finished: {_ in}, isExport: true) // export video to Photo Library
                self.eyeTrackController.stopRecord(finished: { path in print("Video File Path: \(path)") }, isExport: false) // export video to Documents folder
                self.dataController.export(name: "test.csv")
                self.dataController.reset()
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
