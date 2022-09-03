//
//  CarModel.swift
//  CarRentApp
//
//  Created by Kushal Rana on 02/09/22.
//

import Foundation

// Rana

//MARK: - Car Model
struct CarModel: Codable {
    let id: String?
    let name: String?
    let group: String?
    let fuelType: String?
    let carImageUrl: String?
    let transmission: String?
    let fuelLevel: Double?
    let licensePlate: String?
    let innerCleanliness: String?
    let latitude: Double?
    let longitude: Double?
}
