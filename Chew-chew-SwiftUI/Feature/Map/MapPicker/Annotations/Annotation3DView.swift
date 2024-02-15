//
//  BusStopAnnotationView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.02.24.
//

import Foundation
import MapKit
import SwiftUI
import SceneKit

func create3DBusView() -> SCNView {
	let scene = SCNScene()

	let sceneView = SCNView()
	let image = UIImage(imageLiteralResourceName: "bus")
	let path = UIBezierPath(roundedRect: CGRect(x: -1, y: -1, width: 30, height: 30), cornerRadius: 0.25)
	let extrusion = SCNShape(path: path, extrusionDepth: 1.0)
	
	
	let material = SCNMaterial()
	material.diffuse.contents = image
	
	let mat2 = SCNMaterial()
	material.ambient.contents = UIColor.white
	extrusion.materials = [material, mat2]
	
	let extrusionNode = SCNNode(geometry: extrusion)
	scene.rootNode.addChildNode(extrusionNode)
	
	// create and add a camera to the scene
	let cameraNode = SCNNode()
	cameraNode.camera = SCNCamera()
	scene.rootNode.addChildNode(cameraNode)
	
	// place the camera
	cameraNode.position = SCNVector3(x: 3, y: 0, z: 35)
	
	// create and add a light to the scene
	let lightNode = SCNNode()
	lightNode.light = SCNLight()
	lightNode.light!.type = .ambient
	lightNode.position = SCNVector3(x: 10, y: 0, z: 20)
	scene.rootNode.addChildNode(lightNode)
	
	// set the scene to the view
	sceneView.scene = scene
	
	// allows the user to manipulate the camera
	sceneView.allowsCameraControl = true
	sceneView.debugOptions = SCNDebugOptions(rawValue: 1024)
	
	// configure the view
	sceneView.backgroundColor = UIColor.yellow
	return sceneView
}

struct SceneKitView: UIViewRepresentable {
	
	func makeUIView(context: Context) -> SCNView {
		create3DBusView()
	}
	
	func updateUIView(_ uiView: SCNView, context: Context) {
		// Update your 3D scene if needed
	}
}

struct Annotation3DView_Previews: PreviewProvider {
	static var previews: some View {
		SceneKitView()
	}
}
