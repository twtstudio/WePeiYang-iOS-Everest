//
//  ARKeyWindow.swift
//  WePeiYang
//
//  Created by Halcao on 2018/12/22.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

import ARKit
import SceneKit

@available(iOS 11.0, *)
class ARKeyWindow: UIWindow {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.rootViewController = ARViewController()
        self.windowLevel = (UIApplication.shared.keyWindow?.windowLevel ?? 0 ) + 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@available(iOS 11.0, *)
class ARViewController: UIViewController, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    var setup = false // whether scene was set up

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if #available(iOS 11.3, *) {
            configuration.planeDetection = .vertical
        } else {
            configuration.planeDetection = .horizontal
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView(frame: self.view.bounds)
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true

        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene
        self.view.addSubview(sceneView)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, !setup else { return }

        setup = true

        // Create a SceneKit plane to visualize the plane anchor using its position and extent.
        DispatchQueue.main.async {
            let plane = SCNPlane(width: self.sceneView.bounds.width/3000, height: self.sceneView.bounds.height/3000)
            let planeNode = SCNNode(geometry: plane)
            planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)

            /*
             `SCNPlane` is vertically oriented in its local coordinate space, so
             rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
             */
            planeNode.eulerAngles.x = -.pi / 1.9

            // Make the plane visualization semitransparent to clearly show real-world placement.
            //            //        planeNode.opacity = 0.1

            plane.firstMaterial?.blendMode = .max
//            plane.firstMaterial?.diffuse.contents = UIApplication.shared.keyWindow
            plane.firstMaterial?.diffuse.contents = (UIApplication.shared.delegate as? AppDelegate)?.window
//            plane.firstMaterial?.transparencyMode = .rgbZero
            print("setting transparency mode")
            plane.firstMaterial?.transparencyMode = SCNTransparencyMode.rgbZero

            node.addChildNode(planeNode)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }

}
