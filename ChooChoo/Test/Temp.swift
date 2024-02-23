//
//  Temp.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 22.02.24.
//

import Foundation
import SwiftUI

struct TempView2: View {
	@Namespace private var animation
	@State private var isZoomed = false

	var frame: Double {
		isZoomed ? 300 : 44
	}

	var body: some View {
		VStack {
			Spacer()
			VStack {
				HStack {
					RoundedRectangle(cornerRadius: 10)
						.fill(.blue)
						.frame(width: frame, height: frame)
						.padding(.top, isZoomed ? 20 : 0)

					if isZoomed == false {
						Text("Taylor Swift – 1989")
							.matchedGeometryEffect(id: "AlbumTitle", in: animation)
							.font(.headline)
						Spacer()
					}
				}
				if isZoomed == true {
					Text("Taylor Swift – 1989")
						.matchedGeometryEffect(id: "AlbumTitle", in: animation)
						.font(.headline)
						.padding(.bottom, 60)
					Spacer()
				}
			}
			.onTapGesture {
				isZoomed.toggle()
			}
			.animation(.smooth, value: isZoomed)
			.padding()
			.frame(maxWidth: .infinity)
			.frame(height: 400)
			.background(Color(white: 0.9))
			.foregroundStyle(.black)
		}
	}
}
struct TempView: View {
	@State private var isFlipped = false
	@Namespace private var animation
	
	var body: some View {
		VStack {
			if isFlipped {
				Circle()
					.fill(.red)
					.frame(width: 44, height: 44)
					.matchedGeometryEffect(id: "Shape", in: animation)
				Text("Taylor Swift – 1989")
					.font(.headline)
					.matchedGeometryEffect(id: "Shap", in: animation)
			} else {
				Text("Taylor Swift – 1989")
					.font(.headline)
					.matchedGeometryEffect(id: "Shap", in: animation)
				Circle()
					.fill(.blue)
					.frame(width: 44, height: 44)
					.matchedGeometryEffect(id: "Shape", in: animation)
			}
		}
		.animation(.smooth, value: isFlipped)
		.onTapGesture {
			isFlipped.toggle()
		}
	}
}

#Preview(body: {
	VStack {
		TempView()
		TempView2()
	}
})
