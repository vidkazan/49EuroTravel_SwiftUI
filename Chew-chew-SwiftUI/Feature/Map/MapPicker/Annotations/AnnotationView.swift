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


class StopAnnotationView : MKAnnotationView {
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
	   super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
	   frame = CGRect(x: 0, y: 0, width: 25, height: 25)
	   centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
		self.canShowCallout = true
		self.calloutOffset = CGPoint(x: -5, y: 5)
		
		self.rightCalloutAccessoryView = UIImageView(image: UIImage(named: "ice.big"))
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setupUI(_ iconAssetName : String) {
		let image = UIImageView(image: UIImage(imageLiteralResourceName: iconAssetName))
		image.contentMode = .scaleAspectFit
		addSubview(image)
		image.baseConstraints(self)
	}
}

extension UIView {
	func baseConstraints(
		_ parent : UIView,
		_ top : CGFloat = 0,
		_ bottom : CGFloat = 0,
		_ leading : CGFloat = 0,
		_ trailing : CGFloat = 0
	){
		self.translatesAutoresizingMaskIntoConstraints = false
		self.topAnchor.constraint(
			equalTo: parent.safeAreaLayoutGuide.topAnchor,
			constant: top
		).isActive = true
		self.bottomAnchor.constraint(
			equalTo: parent.safeAreaLayoutGuide.bottomAnchor,
			constant: bottom
		).isActive = true
		self.leadingAnchor.constraint(
			equalTo: parent.safeAreaLayoutGuide.leadingAnchor,
			constant: leading
		).isActive = true
		self.trailingAnchor.constraint(
			equalTo: parent.safeAreaLayoutGuide.trailingAnchor,
			constant: trailing
		).isActive = true
	}
}

final class TrainStopAnnotationView: StopAnnotationView {
	static let reuseIdentifier = "TrainStopAnnotationViewReuseIdentifier"
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		setupUI("ice.big")
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI("ice.big")
	}
}
final class TramStopAnnotationView: StopAnnotationView {
	static let reuseIdentifier = "TramStopAnnotationViewReuseIdentifier"
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		   super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		setupUI("tram.big")
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI("tram.big")
	}
}

final class UBahnStopAnnotationView: StopAnnotationView {
	static let reuseIdentifier = "UBahnStopAnnotationViewReuseIdentifier"
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		   super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		setupUI("u.big")
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI("u.big")
	}
}

final class SBahnStopAnnotationView: StopAnnotationView {
	static let reuseIdentifier = "SBahnStopAnnotationViewReuseIdentifier"
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		   super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		setupUI("s.big")
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI("s.big")
	}
}

final class BusStopAnnotationView: StopAnnotationView {
	static let reuseIdentifier = "BusStopAnnotationViewReuseIdentifier"
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		   super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		   setupUI("bus.big")
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI("bus.big")
	}	
}



struct BusAnnotationSwiftUIView : UIViewRepresentable {
	func makeUIView(context: Context) -> BusStopAnnotationView {
		return BusStopAnnotationView(annotation: nil, reuseIdentifier: nil)
	}
	func updateUIView(_ uiView: BusStopAnnotationView, context: Context) {}

	func makeCoordinator() -> Coordinator {
		return Coordinator()
	}

	class Coordinator: NSObject {}
}

struct TrainAnnotationSwiftUIView : UIViewRepresentable {
	func makeUIView(context: Context) -> TrainStopAnnotationView {
		return TrainStopAnnotationView(annotation: nil, reuseIdentifier: nil)
	}
	func updateUIView(_ uiView: TrainStopAnnotationView, context: Context) {}

	func makeCoordinator() -> Coordinator {
		return Coordinator()
	}

	class Coordinator: NSObject {}
}

struct BusStop_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			TrainAnnotationSwiftUIView()
			BusAnnotationSwiftUIView()
		}
	}
}
