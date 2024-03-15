//
//  ViewData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI
import CoreLocation

struct LegViewData : Equatable,Identifiable {
	let id = UUID()
	var isReachable : Bool
	let legType : LegType
	let tripId : String
//	Prognosed<Stop>
	let direction : String
	let legTopPosition : Double
	let legBottomPosition : Double
	var delayedAndNextIsNotReachable : Bool?
	let remarks : [RemarkViewData]
	let legStopsViewData : [StopViewData]
	let footDistance : Int
	let lineViewData : LineViewData
	let progressSegments : Segments
	let time : TimeContainer
	let polyline : PolylineDTO?
	let legDTO : LegDTO?
}

extension LegViewData {
	init(){
		self.isReachable = true
		self.legType = .line
		self.tripId = ""
		self.direction = ""
		self.legTopPosition = 0
		self.legBottomPosition = 0
		self.delayedAndNextIsNotReachable = false
		self.legStopsViewData = []
		self.footDistance = 0
		self.lineViewData = .init(type: .taxi, name: "", shortName: "")
		self.progressSegments = .init(segments: [], heightTotalCollapsed: 0, heightTotalExtended: 0)
		self.time = .init(plannedDeparture: "", plannedArrival: "", actualDeparture: "", actualArrival: "", cancelled: false)
		self.remarks = []
		self.polyline = nil
		self.legDTO = nil
	}
}

enum LocationDirectionType : Int, Hashable, CaseIterable {
	case departure
	case arrival
	
	var placeholder : String {
		switch self {
		case .departure:
			return "from"
		case .arrival:
			return "to"
		}
	}
	
	var description : String {
		switch self {
		case .departure:
			return "departure"
		case .arrival:
			return "arrival"
		}
	}
	
	func sendEvent(send : @escaping (ChewViewModel.Event)->Void)  {
		switch self {
		case .departure:
			send(.didLocationButtonPressed(send: send))
		case .arrival:
			send(.onStopsSwitch)
		}
	}
	
	var baseImage : Image {
		switch self {
		case .departure:
			return Image(.location)
		case .arrival:
			return Image(.arrowUpArrowDown)
		}
	}
}

struct LineViewData : Equatable {
	let type : LineType
	let name : String
	let shortName : String
}

extension LegViewData {
	enum LegType : Equatable,Hashable {
		case footStart(startPointName : String)
		case footMiddle
		case footEnd(finishPointName : String)
		case transfer
		case line
		
		var caseDescription : String {
			switch self {
			case .footStart:
				return "footStart"
			case .footMiddle:
				return "footMiddle"
			case .footEnd:
				return "footEnd"
			case .transfer:
				return "transfer"
			case .line:
				return "line"
			}
		}
	}
}
extension LegViewData {
	var options : [Option] {
		switch legType {
		case .line: [
			Self.showOnMapOption,
			Self.fullLegOption
		]
		default:
			[
				Self.showOnMapOption
			]
		}
	}
}

extension LegViewData {
	struct Option {
		let action : (LegViewData)->()
		let icon : String
		let text : String
	}
	
	static let showOnMapOption = Option(
		action: { leg in
			switch leg.legType {
			case .line,.transfer:
				Model.shared.sheetViewModel.send(event: .didRequestShow(.mapDetails(.lineLeg(leg))))
			default:
				Model.shared.sheetViewModel.send(event: .didRequestShow(.mapDetails(.footDirection(leg))))
			}
		},
		icon: "map",
		text : NSLocalizedString(
			"Show on map",
			comment: "LegDetailsView: menu item"
		)
	)
	static let fullLegOption = Option(
		action: { leg in
			Model.shared.sheetViewModel.send(
				event: .didRequestShow(.fullLeg(leg: leg))
			)
		},
		icon: ChooSFSymbols.trainSideFrontCar.rawValue,
		text: NSLocalizedString(
			"Show full segment",
			comment: "LegDetailsView: menu item"
		)
	)
}
