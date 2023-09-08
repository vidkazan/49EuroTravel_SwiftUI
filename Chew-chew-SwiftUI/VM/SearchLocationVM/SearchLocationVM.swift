//
//  SearchLocationViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 05.09.23.
//

import Foundation
import Combine
import SwiftUI

class SearchLocationViewModel : ObservableObject {
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	@Published private(set) var state : State {
		didSet {
			print(":: searchLocations state: ",state.status.description, state.type)
		}
	}
	
	init(type : LocationDirectionType) {
		self.state = State(
			stops: [],
			previousSearchLineString: "",
			status: .idle,
			type: type
		)
		Publishers.system(
			initial: State(
				stops: [],
				previousSearchLineString: "",
				status: .idle,
				type: type
		 ),
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoadingLocation()
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


extension SearchLocationViewModel {
	static func fetchLocations(text : String, type : LocationDirectionType) -> AnyPublisher<[Stop],ApiServiceError> {
		var query : [URLQueryItem] = []
		query = Query.getQueryItems(methods: [
			Query.location(location: text),
			Query.results(max: 5)
		])
		return ApiService.fetchCombine([Stop].self,query: query, type: ApiService.Requests.locations(name: text ), requestGroupId: "")
	}
}
