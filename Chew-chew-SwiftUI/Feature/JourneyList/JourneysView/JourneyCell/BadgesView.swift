//
//  BadgesView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.08.23.
//

import SwiftUI

struct BadgesView: View {
	let badges : [Badges]
	init(badges: [Badges]) {
		self.badges = badges
	}
	
	var body: some View {
		HStack {
			ForEach(badges,id: \.hashValue) { badge in
				BadgeView(badge)
			}
		}
	}
}
