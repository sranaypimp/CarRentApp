//
//  CarListViewModel.swift
//  CarRentApp
//
//  Created by Kushal Rana on 02/09/22.
//

import Foundation

//MARK: - CarListViewModel
class CarListViewModel {
    
    //MARK: - Properties
    let apiService: APIServiceProtocol
    var cars: [CarModel] = [CarModel]() // private
    
    private var cellViewModels: [CarListCellViewModel] = [CarListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue: Bool = false
    
    var selectedCar: CarModel?

    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    //MARK: - init
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.fetchCarsData { [weak self] (success, cars, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processFetchedCarData(cars: cars) // problem
                print("Cars: \(cars)")
                
            }
        }
    }
    
    func initFetchMap()-> [CarModel] {
        self.isLoading = true
        apiService.fetchCarsData { [weak self] (success, cars, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processFetchedCarData(cars: cars) // problem
                print("Cars: \(cars)")
            }
        }
        return cars
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> CarListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( car: CarModel ) -> CarListCellViewModel {

        //Wrap a description
        var id_Str : String = String()
        var descTextContainer: [String] = [String]()
        var groupFuelTypeFuelLevelString: [String] = [String]()
        var latitude : Double = Double()
        var longitude: Double  = Double()
        
        if let id = car.id {
            id_Str = id
        }
        
        if let name = car.name {
            descTextContainer.append(name)
        }
        
        if let transmission = car.transmission {
            
            if transmission == "M" {
                descTextContainer.append( Constants.transmission_M )
            } else {
                descTextContainer.append( Constants.transmission_A  )
            }
        }
        
        if let group = car.group {
            groupFuelTypeFuelLevelString.append(group)
        }
        if let fuelType = car.fuelType {
            if fuelType == "D" {
                groupFuelTypeFuelLevelString.append( Constants.diesel )
            } else if fuelType == "P" {
                groupFuelTypeFuelLevelString.append( Constants.petrol)
            } else {
                groupFuelTypeFuelLevelString.append( Constants.electric)
            }
        }
        
        if let fuelLevel = car.fuelLevel {
            groupFuelTypeFuelLevelString.append(String(fuelLevel))
        }
        
        if let lat = car.latitude {
            latitude = lat
        }
        if let long = car.longitude {
            longitude = long
        }
        
        let desc = descTextContainer.joined(separator: " - ")
        let groupFuelTypeFuelLevelStr = groupFuelTypeFuelLevelString.joined(separator: " | ")
        
        return CarListCellViewModel(
                                            id: id_Str,
                                        titleText: car.name!,
                                       descText: desc,
                                       imageUrl: car.carImageUrl!,
                                     licensePlate: car.licensePlate!,
                                    groupFuelTypeFuelLavel:groupFuelTypeFuelLevelStr,
                                    latitude: latitude,
                                    longitude: longitude)
    }
    
     func processFetchedCarData( cars: [CarModel] ) {
        self.cars = cars // Cache
        var vms = [CarListCellViewModel]()
        for car in cars {
            vms.append( createCellViewModel(car: car) )
        }
        self.cellViewModels = vms
    }
}

//MARK: - CarListCellModel

struct CarListCellViewModel {
    let id: String
    let titleText: String
    let descText: String
    let imageUrl: String
    let licensePlate: String
    let groupFuelTypeFuelLavel: String
    let latitude: Double
    let longitude: Double
}
