//
//  Sheet.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 17.02.24.
//

import Foundation
import SwiftUI

//extension View {
//	@available(iOS 16.0, *)
//	func bottomSheet<Content : View>(
//		detents : Set<PresentationDetent>,
//		isPresented : Binding<Bool>,
//		dragVisibility : Visibility = .visible,
//		cornerRadius : CGFloat?,
//		largestUndimmedIdentifier : UISheetPresentationController.Detent.Identifier = .large,
//		interactiveDisabled : Bool = true,
//		onDismiss : @escaping ()->(),
//	 	@ViewBuilder content : @escaping ()->Content
//	) -> some View {
//		self.sheet(isPresented: isPresented,onDismiss: onDismiss, content: {
//			content()
//			.presentationDetents(detents)
//			.presentationDragIndicator(dragVisibility)
//			.interactiveDismissDisabled(interactiveDisabled)
//			.onAppear() {
//				guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
//					return
//				}
//				if let controller = windows.windows.first?.rootViewController?.presentedViewController,
//					let sheet = controller.presentationController as? UISheetPresentationController {
//					sheet.largestUndimmedDetentIdentifier = largestUndimmedIdentifier
//					sheet.preferredCornerRadius = cornerRadius
//				}
//			}
//		})
//	}
//}
