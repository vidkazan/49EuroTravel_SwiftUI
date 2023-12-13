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
	
	let columns = [
		GridItem(.adaptive(minimum: 40)),
		GridItem(.adaptive(minimum: 40))
	]
	
	var body: some View {
//		LazyVGrid(columns: columns,alignment: .trailing, spacing: 2) {
//			ForEach(badges,id: \.hashValue) { badge in
//				BadgeView(badge: badge)
//			}
//		}

		HStack{
			ForEach(badges,id: \.hashValue) { badge in
				BadgeView(badge: badge)
			}
		}
	}
}
