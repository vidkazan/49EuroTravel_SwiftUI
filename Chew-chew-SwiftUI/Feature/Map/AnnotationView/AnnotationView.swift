//
//  BusStopAnnotationView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.02.24.
//

import Foundation
import MapKit
import SwiftUI

protocol ChewAnnotationView {
	var titleLabel: UILabel?  { get set }
	var imageView: UIImageView? { get set }
	func setupUI(_ iconAssetName : String)
	func setFrame(frame : CGRect)
}

class StopAnnotationView : MKAnnotationView{
	var titleLabel: UILabel?
	var imageView: UIImageView?
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		self.setFrame(frame: .init(origin: .zero, size: .init(width: 35, height: 35)))
		self.canShowCallout = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setFrame(frame: CGRect) {
		self.frame = frame
	}
	
	func setupUI(_ iconAssetName : String) {
		let image = UIImage(imageLiteralResourceName: iconAssetName)
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit

		addSubview(imageView)
		imageView.chewConstraint(.top(), parent: self,height: 25)
		self.imageView = imageView
		if let imageView = self.imageView {
			titleLabel = UILabel()
			titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
			titleLabel?.textAlignment = .center
			self.addSubview(titleLabel!)
			titleLabel?.chewConstraint(.top(to: imageView), parent: self, width: 120)
		}
		
	}
	override func prepareForReuse() {
		super.prepareForReuse()
		self.imageView = nil
		self.titleLabel?.text = nil
	}
}
