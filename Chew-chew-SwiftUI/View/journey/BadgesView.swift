//
//  BadgesView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.08.23.
//

import SwiftUI

struct BadgesView: View {
	let badges : [BadgeDataSource]
	init(badges: [BadgeDataSource]) {
		self.badges = badges
	}
    var body: some View {
		HStack{
			ForEach(badges) { badge in
				BadgeView(badge: badge)
			}
			
		}
		.frame(maxWidth: .infinity, alignment: .trailing)
		.padding(EdgeInsets(top: 0, leading: 7, bottom: 7, trailing: 7))
    }
}

//struct BadgesView_Previews: PreviewProvider {
//    static var previews: some View {
//        BadgesView()
//    }
//}
