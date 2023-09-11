//
//  SearchStopViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 03.09.23.
//

import Foundation
import Combine

final class JourneyListViewModel : ObservableObject, Identifiable {
	var depStop : Stop
	var arrStop : Stop
	var timeChooserDate : Date
	@Published private(set) var state : State {
		didSet {
			print(">> journeys state: ",state.status)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
		
	
	init(depStop: Stop, arrStop: Stop, timeChooserDate: Date) {
		self.depStop = depStop
		self.arrStop = arrStop
		self.timeChooserDate = timeChooserDate
		self.state = .init(journeys: [], earlierRef: nil, laterRef: nil, status: .loadingJourneys(.main))
		Publishers.system(
			initial: .init(journeys: [], earlierRef: nil, laterRef: nil, status: .loadingJourneys(.main)),
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoading(),
			]
		)
			.assign(to: \.state, on: self)
			.store(in: &bag)
		}
	deinit {
		   bag.removeAll()
	   }
	   
	func send(event: Event) {
		input.send(event)
	}
}
