//
//  MapPickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.02.24.
//

import Foundation
import SwiftUI
import MapKit


struct MapPickerView: View {
	let type : LocationDirectionType
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var vm : MapPickerViewModel
	let closeSheet : ()->Void
	@State private var mapCenterCoords: CLLocationCoordinate2D
	init(vm : MapPickerViewModel,initialCoords: CLLocationCoordinate2D, type : LocationDirectionType, close : @escaping ()->Void) {
		self.mapCenterCoords = initialCoords
		self.type = type
		self.closeSheet = close
		self.vm = vm
	}
	var body: some View {
		NavigationView {
			MapPickerUIView(
				vm: vm,
				mapCenterCoords: mapCenterCoords
			)
			.overlay(alignment: .bottomLeading) { overlay }
			.padding(5)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
						closeSheet()
					}, label: {
						Text("Close")
							.foregroundColor(.chewGray30)
					})
				})
			}
		}
	}
}

extension MapPickerView {
	var overlay : some View {
		Group {
			if let stop  = vm.state.data.selectedStop {
				HStack {
					Text("\(stop.name)")
						.padding(5)
						.chewTextSize(.big)
						.frame(maxWidth: .infinity,alignment: .leading)
					Button(action: {
						chewVM.send(event: .onNewStop(.location(stop), type))
						Model.shared.sheetViewModel.send(event: .didRequestShow(.none))
					}, label: {
						Text("Submit")
							.padding(5)
							.badgeBackgroundStyle(.blue)
							.chewTextSize(.big)
							.foregroundColor(.white)
					})
				}
				.padding(5)
				.badgeBackgroundStyle(.accent)
				.padding(5)
			}
		}
	}
}
