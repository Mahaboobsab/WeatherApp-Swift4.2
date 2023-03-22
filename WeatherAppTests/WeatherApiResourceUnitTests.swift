//
//  WeatherApiResourceUnitTests.swift
//  WeatherAppTests
//
//  Created by mituser on 22/03/23.
//

import XCTest

final class WeatherApiResourceUnitTests: XCTestCase {

    func test_WithValidAPIresourceReturnsResponse() {
        // ARRANGE
        // Valid data
        let request = CityRequest(lat: "12.9756", lon: "10.99", city: nil)
        let resource = CityApiResource()
        let expectation = self.expectation(description: "ValidRequest_Returns_LoginResponse")
        
        resource.authenticateUser(request: request) { (cityAPIResponse) in
            // ASSERT
            XCTAssertNotNil(cityAPIResponse)
            XCTAssertNil(cityAPIResponse?.message)
            XCTAssertEqual("\(request.lat ?? "")", "\(cityAPIResponse?.coord?.lat ?? 0.0)")
            XCTAssertEqual("Gashua", cityAPIResponse?.name)
            XCTAssertEqual(2341656, cityAPIResponse?.id)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {

                expectation.fulfill()
            })
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}
