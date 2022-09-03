//
//  CarListViewController.swift
//  CarRentApp
//
//  Created by Kushal Rana on 02/09/22.
//

import UIKit
import SDWebImage
import MapKit

//MARK: - CarListViewController
class CarListViewController: UIViewController {
    
    //MARK: - @IBOutlet

    @IBOutlet weak var carTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    lazy var viewModel: CarListViewModel = {
        return CarListViewModel()
    }()
    
    var carsArray = [CarModel]()
    var lattitudeValue = Double()
    var longitudeValue = Double()
    
    let showCarsOnMapButton = UIButton(type: .custom)
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
        
        showCarsOnMapButton.isHidden = true
        addMapButtonOnRightSetUp()
    }
    
    func initView() {
        self.navigationItem.title = "Car Rental"
        
        carTableView.estimatedRowHeight = 130
        carTableView.rowHeight = UITableView.automaticDimension
    }
    
    func initVM() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.carTableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.carTableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.carTableView.reloadData()
                self?.showCarsOnMapButton.isHidden = false
            }
        }
       
        viewModel.initFetch()
    }
    
    //MARK: - Not Implemented due to time boundations
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addMapButtonOnRightSetUp(){
       
        showCarsOnMapButton.setTitle("Map", for: .normal)
        showCarsOnMapButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        showCarsOnMapButton.layer.cornerRadius = 5
        showCarsOnMapButton.backgroundColor = .orange
        showCarsOnMapButton.frame = CGRect(x: 0, y: 0, width: 60, height: 25)
        showCarsOnMapButton.addTarget(self, action: #selector(gotoMapPage), for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: showCarsOnMapButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    //MARK: - Navigate to MapAnnotationsVC
    @objc func gotoMapPage(){
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapAnnotationsVC") as! MapAnnotationsVC
        //mapVC.carsArray = [viewModel]
        mapVC.carsArray = viewModel.cars
        self.present(mapVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//MARK: - CarListViewController

extension CarListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "carCellIdentifier", for: indexPath) as? CarListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.carListCellViewModel = cellVM
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
                
        lattitudeValue = viewModel.getCellViewModel(at: indexPath).latitude
        longitudeValue = viewModel.getCellViewModel(at: indexPath).longitude
        
        mapSetUp(carName: viewModel.getCellViewModel(at: indexPath).titleText, carType: viewModel.getCellViewModel(at: indexPath).groupFuelTypeFuelLavel)
    }
    
    //MARK: - MapSetUp
    func mapSetUp(carName: String, carType: String) {
        
        let coordinates = CLLocationCoordinate2DMake(lattitudeValue, longitudeValue)
        let regionDistance:CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = carName + " " + carType
        mapItem.openInMaps(launchOptions: options)
            mapItem.openInMaps(launchOptions: options)
    }
}


//MARK: - Not Implemented due to time bounds
extension CarListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CarDetailOnMapViewController,
            let car = viewModel.selectedCar {
            vc.imageUrl = car.carImageUrl
        }
    }
}




