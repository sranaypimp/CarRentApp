//
//  CarListViewModelTests.swift
//  CarRentAppTests
//
//  Created by Subhash . on 03/09/22.
//

import XCTest
@testable import CarRentApp


class CarListViewModelTests: XCTestCase {
    
    var sut: CarListViewModel!
    var mockAPIService: MockApiService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockApiService()
        sut = CarListViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func test_fetch_car() {
        // Given
        mockAPIService.completeCars = [CarModel]()

        // When
        sut.initFetch()
    
        // Assert
        XCTAssert(mockAPIService!.isFetchPopularCarCalled)
    }
    
    func test_fetch_car_fail() {
        
        // Given a failed fetch with a certain failure
        let error = APIError.permissionDenied
        
        // When
        sut.initFetch()
        
        mockAPIService.fetchFail(error: error )
        
        // Sut should display predefined error message
        XCTAssertEqual( sut.alertMessage, error.rawValue )
        
    }
    
    func test_create_cell_view_model() {
        // Given
        let cars = StubGenerator().stubCars()
        mockAPIService.completeCars = cars
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableViewClosure = { () in
            expect.fulfill()
        }
        
        // When
        sut.initFetch()
        mockAPIService.fetchSuccess()
        
        // Number of cell view model is equal to the number of cars
        XCTAssertEqual( sut.numberOfCells, cars.count )
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
        
    }
    
    func test_loading_when_fetching() {
        
        //Given
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        sut.updateLoadingStatus = { [weak sut] in
            loadingStatus = sut!.isLoading
            expect.fulfill()
        }
        
        //when fetching
        sut.initFetch()
        
        // Assert
        XCTAssertTrue( loadingStatus )
        
        // When finished fetching
        mockAPIService!.fetchSuccess()
        XCTAssertFalse( loadingStatus )
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_get_cell_view_model() {
        
        //Given a sut with fetched cars
        goToFetchCarFinished()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let testCar = mockAPIService.completeCars[indexPath.row]
        
        // When
        let vm = sut.getCellViewModel(at: indexPath)
        
        //Assert
        XCTAssertEqual( vm.titleText, testCar.name)
        
    }

}

//MARK: State control
extension CarListViewModelTests {
    private func goToFetchCarFinished() {
        mockAPIService.completeCars = StubGenerator().stubCars()
        sut.initFetch()
        mockAPIService.fetchSuccess()
    }
}

class MockApiService: APIServiceProtocol {
    
    var isFetchPopularCarCalled = false
    
    var completeCars: [CarModel] = [CarModel]()
    var completeClosure: ((Bool, [CarModel], APIError?) -> ())!
    
    func fetchCarsData(complete: @escaping (Bool, [CarModel], APIError?) -> ()) {
        isFetchPopularCarCalled = true
        completeClosure = complete
        
    }
    
    func fetchSuccess() {
        completeClosure( true, completeCars, nil )
    }
    
    func fetchFail(error: APIError?) {
        completeClosure( false, completeCars, error )
    }
}

class StubGenerator {
    func stubCars() -> [CarModel] {
        let path = Bundle.main.path(forResource: "sixt", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let cars = try! decoder.decode([CarModel].self, from: data)
        return cars
    }
}


