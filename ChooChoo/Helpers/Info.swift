//
//  Info.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 08.03.24.
//

import Foundation
import SwiftUI

enum InfoType : Int, Hashable, CaseIterable {
	case followJourney
}

struct InfoSheet : View {
	let infoType : InfoType
	
	public var body: some View {
		switch infoType {
		case .followJourney:
			HowToFollowJourneyView()
		}
	}
}
