//
//  PresentationDetent.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 08.03.24.
//

import Foundation
import SwiftUI

enum ChewPresentationDetent : Hashable {
	case large
	case medium
	case height(CGFloat)
}

@available(iOS 16.0, *)
func makePresentationDetent(
	chewDetents : [ChewPresentationDetent]
) -> [PresentationDetent] {
	return chewDetents.map { chewDetent -> PresentationDetent in
		switch chewDetent {
		case .large:
			return .large
		case .medium:
			return .medium
		case .height(let cGFloat):
			return .height(cGFloat)
		}
	}
}
