//
//  JourneyScrollViewLoader.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct JourneyScrollViewLoader: View {
    var body: some View {
		VStack{
			Spacer()
			ProgressView()
				.progressViewStyle(.circular)
				.tint(.white)
			Spacer()
		}
    }
}

struct JourneyScrollViewLoader_Previews: PreviewProvider {
    static var previews: some View {
        JourneyScrollViewLoader()
    }
}
