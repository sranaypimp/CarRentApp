//
//  APIService.swift
//  CarRentApp
//
//  Created by Kushal Rana on 02/09/22.
//

import Foundation

//MARK: - APIError
enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

//MARK: - APIServiceProtocol
protocol APIServiceProtocol {
    func fetchCarsData( complete: @escaping ( _ success: Bool, _ cars: [CarModel], _ error: APIError? )->() )
}

//MARK: - fetchCarsData
class APIService: APIServiceProtocol {
    // Simulate a long waiting for fetching
    func fetchCarsData( complete: @escaping ( _ success: Bool, _ cars: [CarModel], _ error: APIError? )->() ) {
        DispatchQueue.global().async {
            sleep(3)
            let path = Bundle.main.path(forResource: "sixt", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let cars = try! decoder.decode([CarModel].self, from: data)
            complete( true, cars, nil)
        }
    }
}
