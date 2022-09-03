//
//  APIServiceTests.swift
//  CarRentAppTests
//
//  Created by Subhash . on 03/09/22.
//

import XCTest
@testable import CarRentApp


class APIServiceTests: XCTestCase {
    
    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetch_popular_cars() {

        // Given A apiservice
        let sut = self.sut!

        // When fetch popular car
        let expect = XCTestExpectation(description: "callback")

        sut.fetchCarsData(complete: { (success, cars, error) in
            expect.fulfill()
            XCTAssertEqual( cars.count, 28)
            for car in cars {
                XCTAssertNotNil(car.id)
            }
            
        })

        wait(for: [expect], timeout: 3.1)
    }
    
}
