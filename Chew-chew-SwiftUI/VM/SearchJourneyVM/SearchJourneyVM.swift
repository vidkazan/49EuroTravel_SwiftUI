//
//  SearchStopViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 03.09.23.
//

import Foundation
import Combine

final class SearchJourneyViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State {
		didSet {
			print(">> state: ",state.description)
		}
	}
	var depStop : Stop?
	var arrStop : Stop?
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	var journeysData : JourneysContainer? {
		didSet {
			self.constructJourneysCollectionViewData()
		}
	}
	var resultJourneysCollectionViewDataSourse : AllJourneysCollectionViewDataSourse
	
	init() {
		self.resultJourneysCollectionViewDataSourse = .init(journeys: [])
		self.state = .idle
		Publishers.system(
			initial: .idle,
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
	func fetchJourneys() -> AnyPublisher<JourneysContainer,ApiServiceError> {
			var query : [URLQueryItem] = []
			query = Query.getQueryItems(methods: [
				Query.departureTime(departureTime: .now),
				Query.departureStop(departureStopId: self.depStop?.id),
				Query.arrivalStop(arrivalStopId: self.arrStop?.id),

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
