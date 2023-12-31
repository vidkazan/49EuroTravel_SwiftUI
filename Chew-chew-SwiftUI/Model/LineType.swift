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
	
	var color : Color {
		switch self {
		case .nationalExpress:
			return Color(red:0.94118, green:0.95294, blue:0.96078)
		case .national:
			return Color(red:0.84314, green:0.86275, blue:0.88235)
		case .regionalExpress:
			return Color(red:0.68627, green:0.70588, blue:0.73333)
		case .regional:
			return Color(red:0.39216, green:0.41176, blue:0.45098)
		case .suburban:
			return Color(red:0.25098, green:0.51373, blue:0.20784)
		case .bus:
			return Color(red: 129/255, green: 73/255, blue: 151/255)
		case .ferry:
			return Color(red: 48/255, green: 159/255, blue: 209/255)
		case .subway:
			return Color(red: 20/255, green: 85/255, blue: 192/255)
		case .tram:
			return Color(red: 197/255, green: 0/255, blue: 20/255)
		case .taxi:
			return Color(red: 255/255, green: 216/255, blue: 0/255)
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
