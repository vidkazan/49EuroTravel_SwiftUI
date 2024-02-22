//
//  ChildAnnotationViews.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 22.02.24.
//

import Foundation
import MapKit

class BusStopAnnotationView : StopAnnotationView, ChewAnnotationView {
	static var reuseIdentifier = NSStringFromClass(BusStopAnnotationView.self)
}
class IceStopAnnotationView : StopAnnotationView, ChewAnnotationView {
	static var reuseIdentifier = NSStringFromClass(IceStopAnnotationView.self)
}
class ReStopAnnotationView : StopAnnotationView , ChewAnnotationView{
	static var reuseIdentifier = NSStringFromClass(ReStopAnnotationView.self)
}
class SStopAnnotationView : StopAnnotationView , ChewAnnotationView{
	static var reuseIdentifier = NSStringFromClass(SStopAnnotationView.self)
}
class UStopAnnotationView : StopAnnotationView , ChewAnnotationView{
	static var reuseIdentifier = NSStringFromClass(UStopAnnotationView.self)
}
class TramStopAnnotationView : StopAnnotationView , ChewAnnotationView{
	static var reuseIdentifier = NSStringFromClass(TramStopAnnotationView.self)
}
class ShipStopAnnotationView : StopAnnotationView , ChewAnnotationView{
	static var reuseIdentifier = NSStringFromClass(ShipStopAnnotationView.self)
}
class TaxiStopAnnotationView : StopAnnotationView , ChewAnnotationView{
	static var reuseIdentifier = NSStringFromClass(TaxiStopAnnotationView.self)
}
class FootStopAnnotationView : StopAnnotationView , ChewAnnotationView{
	static var reuseIdentifier = NSStringFromClass(FootStopAnnotationView.self)
}
class TransferStopAnnotationView : StopAnnotationView , ChewAnnotationView{
	static var reuseIdentifier = NSStringFromClass(TransferStopAnnotationView.self)
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		self.zPriority = .max
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
