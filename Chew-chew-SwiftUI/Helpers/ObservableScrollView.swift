//
//  ObservableScrollView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
  static var defaultValue = CGFloat.zero
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
	  value += nextValue()
  }
}

struct ObservableScrollView<Content>: View where Content : View {
  @Namespace var scrollSpace

  @Binding var scrollOffset: CGFloat
	let content: (ScrollViewProxy) -> Content

	init(scrollOffset: Binding<CGFloat>,offset: Int = 0,
	   @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
	_scrollOffset = scrollOffset
	self.content = content
  }

  var body: some View {
	ScrollView(showsIndicators: false) {
	  ScrollViewReader { proxy in
		  content(proxy)
		  .background(GeometryReader { geo in
			  let offsetY = -geo.frame(in: .named(scrollSpace)).minY
			  Color.clear
				.preference(key: ScrollViewOffsetPreferenceKey.self,
							value: offsetY)
		  })
	  }
	}
	.coordinateSpace(name: scrollSpace)
	.onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { offsetY in
	  scrollOffset = offsetY
	}
  }
}

