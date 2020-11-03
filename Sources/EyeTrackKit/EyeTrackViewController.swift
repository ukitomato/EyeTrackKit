//
//  EyeTrackViewContrller.swift
//  
//
//  Created by Yuki Yamato on 2020/11/03.
//

import UIKit
import SceneKit
import ARKit
import WebKit
import ARVideoKit

open class EyeTrackViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    public var sceneView: ARSCNView!
    public var eyeTrack: EyeTrack!
    public var recorder: RecordAR?
    public var isHidden: Bool?
    
    public func initialize(isHidden: Bool = true, eyeTrack: EyeTrack) {
        self.isHidden = isHidden
        self.eyeTrack = eyeTrack
        let frame = super.view.frame

        // Initialize ARSCNView
        self.sceneView = ARSCNView(frame: frame)
        self.view.addSubview(sceneView!)

        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.isHidden = isHidden
        sceneView.automaticallyUpdatesLighting = true

        // Register EyeTrack module
        self.eyeTrack.registerSceneView(sceneView: sceneView)
        // Setting recorder
        self.recorder = RecordAR(ARSceneKit: sceneView)
    }
    
    public func hide() -> Void {
        self.sceneView.isHidden = true
    }

    public func show() -> Void {
        self.sceneView.isHidden = false
    }

    // Start to record SceneView content
    public func startRecord() {
        recorder?.record()
    }

    // Stop to record and Save the recorded video
    public func stopRecord() {
        recorder?.stopAndExport()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        // Setting recorder
        self.recorder?.prepare(configuration)

        // Run the view's session
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause recording
        recorder?.rest()
        // Pause the view's session
        sceneView.session.pause()

    }

    // MARK: - ARSCNViewDelegate


    open func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    open func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    open func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }

    // Update Some View when updating Face Anchor
    open func updateViewWithUpdateAnchor() {
    }
}


extension EyeTrackViewController {

    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        self.eyeTrack.face.node.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        updateAnchor(withFaceAnchor: faceAnchor)
    }

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let sceneTransformInfo = sceneView.pointOfView?.transform else {
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


