//
//  BusStopAnnotationView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.02.24.
//

import Foundation
import MapKit
import SwiftUI

class StopAnnotationView : MKAnnotationView {
	var imageView: UIImageView?
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setupUI(_ iconAssetName : String) {
		let image = UIImageView(image: UIImage(imageLiteralResourceName: iconAssetName))
		image.contentMode = .scaleAspectFit
		addSubview(image)
		image.chewConstraint(.fillParent, to: self)
		imageView = image
	}
}

class LabelStopAnnotationView : StopAnnotationView {
	var titleLabel: UILabel?
	
	override func setupUI(_ iconAssetName: String) {
		super.setupUI(iconAssetName)
		if let imageView = self.imageView {
			titleLabel = UILabel()
			titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
			titleLabel?.textAlignment = .center
			self.addSubview(titleLabel!)
			titleLabel?.chewConstraint(.bottom(height: 12, width: 120), to: imageView)
		}
	}
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension UIView {
	enum ChewConstraintType {
		case fillParent
		case bottom(height: CGFloat, width : CGFloat)
		case top
		case right
		case left
	}
}

extension UIView {
	func chewConstraint(
		_ type : ChewConstraintType,
		 to : UIView,
		_ top : CGFloat = 0,
		_ bottom : CGFloat = 0,
		_ leading : CGFloat = 0,
		 _ trailing : CGFloat = 0,
		 _ width : CGFloat = 0,
		 _ height : CGFloat = 0
	){
		self.translatesAutoresizingMaskIntoConstraints = false
		switch type {
		case .fillParent:
			parentViewFillConstraint(to,top,bottom,leading,trailing)
		case let .bottom(height, width):
			self.topAnchor.constraint(
				equalTo: to.bottomAnchor,
				constant: top
			).isActive = true
			self.heightAnchor.constraint(
				equalToConstant: height
			).isActive = true
			self.widthAnchor.constraint(
				equalToConstant: width
			).isActive = true
			self.centerXAnchor.constraint(
				equalTo: to.centerXAnchor
			).isActive = true
		default:
			break
		}
	}
	private func horizontalConstraint(
		_ parent : UIView,
		_ leading : CGFloat,
		_ trailing : CGFloat
	){
		
		self.leadingAnchor.constraint(
			equalTo: parent.safeAreaLayoutGuide.leadingAnchor,
			constant: leading
		).isActive = true
		self.trailingAnchor.constraint(
			equalTo: parent.safeAreaLayoutGuide.trailingAnchor,
			constant: trailing
		).isActive = true
	}
	private func parentViewFillConstraint(
		_ parent : UIView,
		_ top : CGFloat = 0,
		_ bottom : CGFloat = 0,
		_ leading : CGFloat = 0,
		_ trailing : CGFloat = 0
	){
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
