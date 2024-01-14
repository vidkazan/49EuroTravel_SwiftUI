//
//  Mock.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 28.11.23.
//

import Foundation
@testable import Chew_chew_SwiftUI

//protocol MockFile {
//	associatedtype T : Decodable
//	
//	func APIRawData() -> Data?
//	
//	func APIDecodedData() -> T?
//}

class MockFile {
	static func url(type : MockType,fileName : String) -> URL {
		let thisSourceFile = URL(fileURLWithPath: #file)
		let thisDirectory = thisSourceFile.deletingLastPathComponent().deletingLastPathComponent()
		return thisDirectory.appendingPathComponent(type.directoryPath + fileName)
	}
	
	static func APIRawData(url : URL) -> Data? {
		do {
			let data = try Data(contentsOf: url)
			return data
		}
		catch {
			print(">> mockFile: failed to load file" + url.path)
			return nil
		}
	}
	
	static func APIDecodedData<T : Decodable>(rawData : Data?) -> T? {
		guard let data = rawData else {
			print(">> mockFile: decodeData: data is nil")
			return nil
		}
		do {
			let res = try JSONDecoder().decode(T.self, from: data)
			return res
		}
		catch {
			print(">> mock JSON decoder error: ",error)
			return nil
		}
	}
}
