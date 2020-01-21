//
//  Data+JSONFile.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 02.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
import XCTest

extension Data {
  
  public static func fromJSON(
    fileName: String,
    file: StaticString = #file,
    line: UInt = #line
  ) throws -> Data {
    
    let bundle = Bundle(for: TestBundleClass.self)
    let url = try XCTUnwrap(
      bundle.url(
        forResource:
        fileName, withExtension: "json"),
      "Unable to find \(fileName).json. Did you add it to the tests?",
      file: file,
      line: line)
    return try Data(contentsOf: url)
  }
  
  public func toAny() throws -> Any {
    try JSONSerialization.jsonObject(with: self, options: .allowFragments)
  }
}

private class TestBundleClass { }
