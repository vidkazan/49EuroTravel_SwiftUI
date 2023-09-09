//
//  SearchStopViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 03.09.23.
//

import Foundation
import Combine

final class SearchJourneyViewModel : ObservableObject, Identifiable {
	@Published var topSearchFieldText : String = ""
	@Published var bottomSearchFieldText : String = ""
	@Published private(set) var state : State {
		didSet {
			print(">> state: ",state.status.description)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	
	init() {
		self.state = State(depStop: nil, arrStop: nil, timeChooserDate: .now, journeys: [], status: .idle)
		Publishers.system(
			initial: State(depStop: nil, arrStop: nil, timeChooserDate: .now, journeys: [], status: .idle),
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoading(),
				self.whenIdleCheckForSufficientDataForJourneyRequest()
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

extension SearchJourneyViewModel {
	func fetchJourneys(dep : Stop,arr : Stop,time: Date) -> AnyPublisher<JourneysContainer,ApiServiceError> {
			var query : [URLQueryItem] = []
			query = Query.getQueryItems(methods: [
				Query.departureTime(departureTime: time),
				Query.departureStop(departureStopId: dep.id),
				Query.arrivalStop(arrivalStopId: arr.id),

				Query.national(icTrains: false),
				Query.nationalExpress(iceTrains: false),
				Query.regionalExpress(reTrains: false),
				Query.pretty(pretyIntend: false),
				Query.taxi(taxi: false),
				Query.remarks(showRemarks: true),
				Query.results(max: 5)
			])
			return ApiService.fetchCombine(JourneysContainer.self,query: query, type: ApiService.Requests.journeys, requestGroupId: "")
	}
}
