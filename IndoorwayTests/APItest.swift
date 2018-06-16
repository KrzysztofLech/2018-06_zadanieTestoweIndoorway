//
//  APItest.swift
//  IndoorwayTests
//
//  Created by Krzysztof Lech on 16.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import XCTest

class APItest: XCTestCase {
    
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: .default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testValidCallToEndpointGetsHTTPStatusCode200() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos/")
        let promise = expectation(description: "Status code: 200")

        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in

            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return

            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {

                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
}
