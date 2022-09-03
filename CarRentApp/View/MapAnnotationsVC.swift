//
//  MapAnnotationsVC.swift
//  CarRentApp
//
//  Created by Subhash . on 02/09/22.
//

import UIKit
import MapKit

//MARK: - MapAnnotationsVC
class MapAnnotationsVC: UIViewController, MKMapViewDelegate {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    
    var carsArray: [CarModel] = [CarModel]()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadAnnotationsOnMapView()
    }
    
    func loadAnnotationsOnMapView() {
        for location in carsArray {
            let annotations = MKPointAnnotation()
            annotations.title = location.name! + "-" + "\(location.group!)"
            annotations.coordinate = CLLocationCoordinate2D(latitude: location.latitude! , longitude: location.longitude!)
            mapView.addAnnotation(annotations)
        }
    }
    
    //MARK: - Map Delegate Method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseId = "reuseId"
            var annotationsView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if annotationsView == nil {
                annotationsView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationsView!.canShowCallout = true
            }else {
                annotationsView!.annotation = annotation
            }

            annotationsView!.image = UIImage(named: "mapIcon.png")
            return annotationsView
        }
    
    //MARK: - CancelAction
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
