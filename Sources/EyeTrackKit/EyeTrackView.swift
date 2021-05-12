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
import os

public struct EyeTrackView: UIViewRepresentable {
    @State public var sceneView: ARSCNView = ARSCNView(frame: .infinite)
    public var eyeTrack: EyeTrack
    public var recorder: RecordAR?
    public var isHidden: Bool

    // Create a session configuration
    private var configuration = ARFaceTrackingConfiguration()
    private var logger: Logger = Logger(subsystem: "dev.ukitomato.EyeTrackKit", category: "EyeTrackView")

    public init(isHidden: Bool = true, eyeTrack: EyeTrack) {
        self.isHidden = isHidden
        self.eyeTrack = eyeTrack
        self.recorder = RecordAR(ARSceneKit: sceneView)
        self.configuration.isLightEstimationEnabled = true
    }

    public init(isHidden: Bool = true, eyeTrack: EyeTrack, sceneView: ARSCNView) {
        self.isHidden = isHidden
        self.eyeTrack = eyeTrack
        self.sceneView = sceneView
        self.recorder = RecordAR(ARSceneKit: sceneView)
    }


    public func makeUIView(context: Context) -> ARSCNView {
        self.sceneView.delegate = context.coordinator
        self.sceneView.session.delegate = context.coordinator
        self.sceneView.isHidden = self.isHidden
        self.sceneView.automaticallyUpdatesLighting = true

        // Setting recorder
        self.recorder?.renderAR = context.coordinator
        self.recorder?.onlyRenderWhileRecording = false
        return sceneView
    }

    public func updateUIView(_ uiView: ARSCNView, context: Context) { }

    public func hide() -> Void {
        self.logger.debug("hide")
        self.sceneView.isHidden = true
    }

    public func show() -> Void {
        self.logger.debug("show")
        self.sceneView.isHidden = false
    }

    public func start() {
        // Run the view's session
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        self.recorder?.prepare(configuration)
    }

    public func pause() {
        // Pause the view's session
        self.sceneView.session.pause()
        self.recorder?.rest()
    }

    /// Start to record SceneView content
    public func startRecord() {
        self.recorder?.record()
    }

    /// Stop to record and Save the recorded video to Photo Library
    public func stopRecord(finished: @escaping (URL) -> Void = { _ in }, isExport: Bool = false) {
        if isExport {
            self.recorder?.stopAndExport()
        } else {
            self.recorder?.stop() { path in
                //use the file path to export or preview inside your application
                finished(path)
            }
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(view: $sceneView, eyeTrack: self.eyeTrack, recorder: self.recorder)
    }

    public class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate, RenderARDelegate {
        @Binding public var view: ARSCNView
        public var eyeTrack: EyeTrack
        public var recorder: RecordAR?

        public init (view: Binding<ARSCNView>, eyeTrack: EyeTrack, recorder: RecordAR?) {
            self._view = view
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
            self.view.session.pause()
        }

        public func frame(didRender buffer: CVPixelBuffer, with time: CMTime, using rawBuffer: CVPixelBuffer) {
            DispatchQueue.main.async {
                self.eyeTrack.updateFrame(pixelBuffer: rawBuffer)
            }
        }

        public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            self.eyeTrack.face.node.transform = node.transform
            guard let faceAnchor = anchor as? ARFaceAnchor else {
                return
            }
            updateAnchor(withFaceAnchor: faceAnchor)
        }

        public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            guard let sceneTransformInfo = view.pointOfView?.transform else {
                return
            }
            // Update Virtual Device position
            self.eyeTrack.device.node.transform = sceneTransformInfo
        }

        public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            self.eyeTrack.face.node.transform = node.transform
            guard let faceAnchor = anchor as? ARFaceAnchor else {
                return
            }
            updateAnchor(withFaceAnchor: faceAnchor)
        }

        public func updateAnchor(withFaceAnchor anchor: ARFaceAnchor) {
            DispatchQueue.main.async {
                self.eyeTrack.update(anchor: anchor)
            }
        }
    }
}
