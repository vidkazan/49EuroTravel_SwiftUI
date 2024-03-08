//
//  UIView+Constraints.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 20.02.24.
//

import Foundation
import UIKit

extension UIView {
	enum ChewConstraintType {
		case fillParent
		case top(to: UIView? = nil)
		case leading(to: UIView? = nil)
	}
}

extension UIView {
	func chewConstraint(
		_ type : ChewConstraintType,
		parent : UIView,
		top : CGFloat = 0,
		bottom : CGFloat = 0,
		leading : CGFloat = 0,
		trailing : CGFloat = 0,
		width : CGFloat? = nil,
		height : CGFloat? = nil
	){
		self.translatesAutoresizingMaskIntoConstraints = false
		
		switch type {
		case .fillParent:
			parentViewFillConstraint(parent,top,bottom,leading,trailing)
		case let .top(toView):
			if let toView = toView {
				self.topAnchor.constraint(equalTo: toView.bottomAnchor,constant: top).isActive = true
			} else {
				self.topAnchor.constraint(equalTo: parent.topAnchor,constant: top).isActive = true
			}
			
			if let height = height {
				self.heightAnchor.constraint(equalToConstant: height).isActive = true
			} else {
				self.bottomAnchor.constraint(equalTo: parent.bottomAnchor,constant: bottom).isActive = true
			}
			
			if let width = width {
				self.widthAnchor.constraint(equalToConstant: width).isActive = true
				self.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
			} else {
				self.leadingAnchor.constraint(equalTo: parent.leadingAnchor,constant: leading).isActive = true
				self.trailingAnchor.constraint(equalTo: parent.trailingAnchor,constant: trailing).isActive = true
			}
			
		case let .leading(toView):
				self.topAnchor.constraint(
					equalTo: parent.topAnchor,
					constant: top
				).isActive = true
				self.bottomAnchor.constraint(
					equalTo: parent.bottomAnchor,
					constant: bottom
				).isActive = true
			
				if let toView = toView {
					self.leadingAnchor.constraint(
						equalTo: toView.trailingAnchor,
						constant: leading
					).isActive = true
				} else {
					self.leadingAnchor.constraint(
						equalTo: parent.leadingAnchor,
						constant: leading
					).isActive = true
				}
			
				if let width = width {
					self.widthAnchor.constraint(
						equalToConstant: width
					).isActive = true
				} else {
					self.trailingAnchor.constraint(
						equalTo: parent.trailingAnchor,
						constant: trailing
					).isActive = true
				}
		}
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
