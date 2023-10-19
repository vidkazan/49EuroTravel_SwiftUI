//
//  D-ticketLogo.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct DTicketLogo: View {
	var body: some View {
		ZStack{
			dTicketLogoTop()
				.fill(Color(uiColor: UIColor(red: 0.17, green: 0.17, blue: 0.16, alpha: 1)))
			dTicketLogoCenter()
				.fill(Color(uiColor: UIColor(red: 0.9, green: 0.19, blue: 0.15, alpha: 1)))
			dTicketLogoBottom()
				.fill(Color(uiColor: UIColor(red: 0.99, green: 0.75, blue: 0, alpha: 1)))
		}
		.frame(width: 0.7*17,height: 0.7*22)
	}
}

struct dTicketLogoTop: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let width = rect.size.width
		let height = rect.size.height
		path.move(to: CGPoint(x: 0.84376*width, y: 0.3029*height))
		path.addLine(to: CGPoint(x: 0.17461*width, y: 0.3029*height))
		path.addCurve(to: CGPoint(x: 0.13045*width, y: 0.26804*height), control1: CGPoint(x: 0.15022*width, y: 0.3029*height), control2: CGPoint(x: 0.13045*width, y: 0.28729*height))
		path.addCurve(to: CGPoint(x: 0.17461*width, y: 0.23319*height), control1: CGPoint(x: 0.13045*width, y: 0.24879*height), control2: CGPoint(x: 0.15022*width, y: 0.23319*height))
		path.addLine(to: CGPoint(x: 0.84376*width, y: 0.23319*height))
		path.addCurve(to: CGPoint(x: 0.88791*width, y: 0.26804*height), control1: CGPoint(x: 0.86814*width, y: 0.23319*height), control2: CGPoint(x: 0.88791*width, y: 0.24879*height))
		path.addCurve(to: CGPoint(x: 0.84376*width, y: 0.3029*height), control1: CGPoint(x: 0.88791*width, y: 0.28729*height), control2: CGPoint(x: 0.86814*width, y: 0.3029*height))
		path.closeSubpath()
		path.move(to: CGPoint(x: 0.80931*width, y: 0.18671*height))
		path.addLine(to: CGPoint(x: 0.19439*width, y: 0.18671*height))
		path.addCurve(to: CGPoint(x: 0.15023*width, y: 0.15186*height), control1: CGPoint(x: 0.16998*width, y: 0.18671*height), control2: CGPoint(x: 0.15023*width, y: 0.17111*height))
		path.addCurve(to: CGPoint(x: 0.19439*width, y: 0.117*height), control1: CGPoint(x: 0.15023*width, y: 0.13261*height), control2: CGPoint(x: 0.16998*width, y: 0.117*height))
		path.addLine(to: CGPoint(x: 0.80931*width, y: 0.117*height))
		path.addCurve(to: CGPoint(x: 0.85347*width, y: 0.15186*height), control1: CGPoint(x: 0.8337*width, y: 0.117*height), control2: CGPoint(x: 0.85347*width, y: 0.13261*height))
		path.addCurve(to: CGPoint(x: 0.80931*width, y: 0.18671*height), control1: CGPoint(x: 0.85347*width, y: 0.17111*height), control2: CGPoint(x: 0.8337*width, y: 0.18671*height))
		path.closeSubpath()
		path.move(to: CGPoint(x: 0.46546*width, y: 0.07053*height))
		path.addLine(to: CGPoint(x: 0.34125*width, y: 0.07053*height))
		path.addCurve(to: CGPoint(x: 0.29709*width, y: 0.03568*height), control1: CGPoint(x: 0.31684*width, y: 0.07053*height), control2: CGPoint(x: 0.29709*width, y: 0.05493*height))
		path.addCurve(to: CGPoint(x: 0.34125*width, y: 0.00083*height), control1: CGPoint(x: 0.29709*width, y: 0.01643*height), control2: CGPoint(x: 0.31684*width, y: 0.00083*height))
		path.addLine(to: CGPoint(x: 0.46546*width, y: 0.00083*height))
		path.addCurve(to: CGPoint(x: 0.50962*width, y: 0.03568*height), control1: CGPoint(x: 0.48985*width, y: 0.00083*height), control2: CGPoint(x: 0.50962*width, y: 0.01643*height))
		path.addCurve(to: CGPoint(x: 0.46546*width, y: 0.07053*height), control1: CGPoint(x: 0.50962*width, y: 0.05493*height), control2: CGPoint(x: 0.48985*width, y: 0.07053*height))
		path.closeSubpath()
		return path
	}
}




struct dTicketLogoCenter: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let width = rect.size.width
		let height = rect.size.height
		path.move(to: CGPoint(x: 0.69653*width, y: height))
		path.addLine(to: CGPoint(x: 0.20887*width, y: height))
		path.addCurve(to: CGPoint(x: 0.16471*width, y: 0.96514*height), control1: CGPoint(x: 0.18448*width, y: height), control2: CGPoint(x: 0.16471*width, y: 0.98439*height))
		path.addCurve(to: CGPoint(x: 0.20887*width, y: 0.93029*height), control1: CGPoint(x: 0.16471*width, y: 0.94589*height), control2: CGPoint(x: 0.18448*width, y: 0.93029*height))
		path.addLine(to: CGPoint(x: 0.69653*width, y: 0.93029*height))
		path.addCurve(to: CGPoint(x: 0.74069*width, y: 0.96514*height), control1: CGPoint(x: 0.72092*width, y: 0.93029*height), control2: CGPoint(x: 0.74069*width, y: 0.94589*height))
		path.addCurve(to: CGPoint(x: 0.69653*width, y: height), control1: CGPoint(x: 0.74069*width, y: 0.98439*height), control2: CGPoint(x: 0.72092*width, y: height))
		path.closeSubpath()
		path.move(to: CGPoint(x: 0.86495*width, y: 0.88376*height))
		path.addLine(to: CGPoint(x: 0.26671*width, y: 0.88376*height))
		path.addCurve(to: CGPoint(x: 0.22255*width, y: 0.84891*height), control1: CGPoint(x: 0.24232*width, y: 0.88376*height), control2: CGPoint(x: 0.22255*width, y: 0.86816*height))
		path.addCurve(to: CGPoint(x: 0.26671*width, y: 0.81405*height), control1: CGPoint(x: 0.22255*width, y: 0.82965*height), control2: CGPoint(x: 0.24232*width, y: 0.81405*height))
		path.addLine(to: CGPoint(x: 0.86495*width, y: 0.81405*height))
		path.addCurve(to: CGPoint(x: 0.90911*width, y: 0.84891*height), control1: CGPoint(x: 0.88934*width, y: 0.81405*height), control2: CGPoint(x: 0.90911*width, y: 0.82965*height))
		path.addCurve(to: CGPoint(x: 0.86495*width, y: 0.88376*height), control1: CGPoint(x: 0.90911*width, y: 0.86816*height), control2: CGPoint(x: 0.88934*width, y: 0.88376*height))
		path.closeSubpath()
		path.move(to: CGPoint(x: 0.71425*width, y: 0.76761*height))
		path.addLine(to: CGPoint(x: 0.10809*width, y: 0.76761*height))
		path.addCurve(to: CGPoint(x: 0.06393*width, y: 0.73276*height), control1: CGPoint(x: 0.0837*width, y: 0.76761*height), control2: CGPoint(x: 0.06393*width, y: 0.75201*height))
		path.addCurve(to: CGPoint(x: 0.10809*width, y: 0.69791*height), control1: CGPoint(x: 0.06393*width, y: 0.71351*height), control2: CGPoint(x: 0.0837*width, y: 0.69791*height))
		path.addLine(to: CGPoint(x: 0.71425*width, y: 0.69791*height))
		path.addCurve(to: CGPoint(x: 0.75841*width, y: 0.73276*height), control1: CGPoint(x: 0.73864*width, y: 0.69791*height), control2: CGPoint(x: 0.75841*width, y: 0.71351*height))
		path.addCurve(to: CGPoint(x: 0.71425*width, y: 0.76761*height), control1: CGPoint(x: 0.75841*width, y: 0.75201*height), control2: CGPoint(x: 0.73864*width, y: 0.76761*height))
		path.closeSubpath()
		return path
	}
}


struct dTicketLogoBottom: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let width = rect.size.width
		let height = rect.size.height
		path.move(to: CGPoint(x: 0.62022*width, y: 0.65143*height))
		path.addLine(to: CGPoint(x: 0.07486*width, y: 0.65143*height))
		path.addCurve(to: CGPoint(x: 0.03069*width, y: 0.61658*height), control1: CGPoint(x: 0.05046*width, y: 0.65143*height), control2: CGPoint(x: 0.03069*width, y: 0.63583*height))
		path.addCurve(to: CGPoint(x: 0.07486*width, y: 0.58173*height), control1: CGPoint(x: 0.03069*width, y: 0.59733*height), control2: CGPoint(x: 0.05046*width, y: 0.58173*height))
		path.addLine(to: CGPoint(x: 0.62022*width, y: 0.58173*height))
		path.addCurve(to: CGPoint(x: 0.66438*width, y: 0.61658*height), control1: CGPoint(x: 0.64461*width, y: 0.58173*height), control2: CGPoint(x: 0.66438*width, y: 0.59733*height))
		path.addCurve(to: CGPoint(x: 0.62022*width, y: 0.65143*height), control1: CGPoint(x: 0.66438*width, y: 0.63583*height), control2: CGPoint(x: 0.64461*width, y: 0.65143*height))
		path.closeSubpath()
		path.move(to: CGPoint(x: 0.95095*width, y: 0.53525*height))
		path.addLine(to: CGPoint(x: 0.04842*width, y: 0.53525*height))
		path.addCurve(to: CGPoint(x: 0.00426*width, y: 0.50039*height), control1: CGPoint(x: 0.02403*width, y: 0.53525*height), control2: CGPoint(x: 0.00426*width, y: 0.51965*height))
		path.addCurve(to: CGPoint(x: 0.04842*width, y: 0.46554*height), control1: CGPoint(x: 0.00426*width, y: 0.48114*height), control2: CGPoint(x: 0.02403*width, y: 0.46554*height))
		path.addLine(to: CGPoint(x: 0.95095*width, y: 0.46554*height))
		path.addCurve(to: CGPoint(x: 0.99511*width, y: 0.50039*height), control1: CGPoint(x: 0.97535*width, y: 0.46554*height), control2: CGPoint(x: 0.99511*width, y: 0.48114*height))
		path.addCurve(to: CGPoint(x: 0.95095*width, y: 0.53525*height), control1: CGPoint(x: 0.99511*width, y: 0.51965*height), control2: CGPoint(x: 0.97535*width, y: 0.53525*height))
		path.closeSubpath()
		path.move(to: CGPoint(x: 0.91198*width, y: 0.41907*height))
		path.addLine(to: CGPoint(x: 0.1274*width, y: 0.41907*height))
		path.addCurve(to: CGPoint(x: 0.08324*width, y: 0.38422*height), control1: CGPoint(x: 0.10301*width, y: 0.41907*height), control2: CGPoint(x: 0.08324*width, y: 0.40347*height))
		path.addCurve(to: CGPoint(x: 0.1274*width, y: 0.34937*height), control1: CGPoint(x: 0.08324*width, y: 0.36497*height), control2: CGPoint(x: 0.10301*width, y: 0.34937*height))
		path.addLine(to: CGPoint(x: 0.91198*width, y: 0.34937*height))
		path.addCurve(to: CGPoint(x: 0.95614*width, y: 0.38422*height), control1: CGPoint(x: 0.93637*width, y: 0.34937*height), control2: CGPoint(x: 0.95614*width, y: 0.36497*height))
		path.addCurve(to: CGPoint(x: 0.91198*width, y: 0.41907*height), control1: CGPoint(x: 0.95614*width, y: 0.40347*height), control2: CGPoint(x: 0.93637*width, y: 0.41907*height))
		path.closeSubpath()
		return path
	}
}
