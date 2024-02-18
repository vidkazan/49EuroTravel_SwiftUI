//
//  LineType.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.12.23.
//

import Foundation
import SwiftUI

enum LineType : String,Equatable,Hashable, CaseIterable {
	static func < (lhs: LineType, rhs: LineType) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
	case nationalExpress
	case national
	case regionalExpress
	case regional
	case suburban
	case bus
	case ferry
	case subway
	case tram
	case taxi
	case transfer
	case foot
	
	var shortValue : String {
		switch self {
		case .nationalExpress:
			return "ICE"
		case .national:
			return "IC,EC"
		case .regionalExpress:
			return "IRE"
		case .regional:
			return "RE,RB"
		case .suburban:
			return "S-bahn"
		case .bus:
			return "Bus"
		case .ferry:
			return "Ferry"
		case .subway:
			return "U-bahn"
		case .tram:
			return "Tram"
		case .taxi:
			return "Taxi"
		case .transfer:
			return "Transfer"
		case .foot:
			return "Boot"
		}
	}
	
	var icon : String? {
		switch self {
		case .nationalExpress:
			return "ice"
		case .national:
			return "ice"
		case .regionalExpress:
			return "re"
		case .regional:
			return "re"
		case .suburban:
			return "s"
		case .bus:
			return "bus"
		case .ferry:
			return "ship"
		case .subway:
			return "u"
		case .tram:
			return "tram"
		case .taxi:
			return "taxi"
		case .transfer:
			return nil
		case .foot:
			return nil
		}
	}
	
	var color : Color {
		switch self {
		case .nationalExpress:
			return Color.transport.iceGray
		case .national:
			return Color.transport.iceGray
		case .regionalExpress:
			return Color.transport.reGray
		case .regional:
			return Color.transport.reGray
		case .suburban:
			return Color.transport.sGreen
		case .bus:
			return Color.transport.busMagenta
		case .ferry:
			return Color.transport.shipCyan
		case .subway:
			return Color.transport.uBlue
		case .tram:
			return Color.transport.tramRed
		case .taxi:
			return Color.transport.taxiYellow
		case .transfer:
			return .clear
		case .foot:
			return Color.chewGrayScale10
		}
	}
	var id: Int {
		switch self {
		case .bus:
			return 0
		case .ferry:
			return 1
		case .national:
			return 2
		case .nationalExpress:
			return 3
		case .regional:
			return 4
		case .regionalExpress:
			return 5
		case .suburban:
			return 6
		case .subway:
			return 7
		case .taxi:
			return 8
		case .tram:
			return 9
		case .transfer:
			return 10
		case .foot:
			return 11
		}
	}
}
