//
//  EyeTrackView.swift
//  
//
//  Created by Yuki Yamato on 2020/10/01.
//

import SwiftUI
import ARKit
import SceneKit
import ARVideoKit

struct EyeTrackView: UIViewRepresentable {
    @State var sceneView: ARSCNView = ARSCNView(frame: .zero)
    var eyeTrack: EyeTrack
    var recorder: RecordAR?
    private var isHidden: Bool
    
    init(isHidden: Bool = true, eyeTrack: EyeTrack) {
        self.isHidden = isHidden
        self.eyeTrack = eyeTrack
        self.recorder = RecordAR(ARSceneKit: sceneView)
    }

    
    func makeUIView(context: Context) -> ARSCNView {
        // Set the view's delegate
        self.sceneView.delegate = context.coordinator
        self.sceneView.session.delegate = context.coordinator
        self.sceneView.isHidden = self.isHidden
        self.sceneView.automaticallyUpdatesLighting = true
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Setting recorder
        self.recorder?.prepare(configuration)
        
        // Run the view's session
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
    }
    
    /// Start to record SceneView content
    func startRecord() {
        recorder?.record()
    }

    /// Stop to record and Save the recorded video
    func stopRecord() {
        recorder?.stopAndExport()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(view: $sceneView, eyeTrack: self.eyeTrack, recorder: self.recorder)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        @Binding var view: ARSCNView
        var eyeTrack: EyeTrack
        var recorder: RecordAR?
        
        init (view: Binding<ARSCNView>, eyeTrack: EyeTrack, recorder: RecordAR?) {
            _view = view
            self.eyeTrack = eyeTrack
            self.recorder = recorder
            super.init()
            // Register EyeTrack module
            self.eyeTrack.registerSceneView(sceneView: self.view)
        }
        
        deinit {
            // Pause recording
            self.recorder?.rest()
            // Pause the view's session
            view.session.pause()
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            eyeTrack.face.node.transform = node.transform
            guard let faceAnchor = anchor as? ARFaceAnchor else {
                return
            }
            updateAnchor(withFaceAnchor: faceAnchor)
        }

        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            guard let sceneTransformInfo = view.pointOfView?.transform else {
                return
            }
            // Update Virtual Device position
            eyeTrack.device.node.transform = sceneTransformInfo
        }

        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            eyeTrack.face.node.transform = node.transform
            guard let faceAnchor = anchor as? ARFaceAnchor else {
                return
            }
            updateAnchor(withFaceAnchor: faceAnchor)
        }

        func updateAnchor(withFaceAnchor anchor: ARFaceAnchor) {
            DispatchQueue.main.async {
                self.eyeTrack.update(anchor: anchor)
            }
        }
    }
}
