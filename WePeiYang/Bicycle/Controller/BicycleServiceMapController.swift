//
//  ViewController.swift
//  MapKitImplementAgain
//
//  Created by Allen X on 7/12/16.
//  Copyright © 2016 twtstudio. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class BicycleServiceMapController: UIViewController {
    
    
    //@IBOutlet var whereAmI: UIButton!
    
    /*@IBAction func whereAmI(sender: AnyObject) {
     if let userLoc:MKUserLocation? = newMapView.userLocation {
     let cl = CLLocation(latitude: (userLoc?.coordinate.latitude)!, longitude: (userLoc?.coordinate.longitude)!)
     centerMapOnLocation(cl)
     } else {
     checkLocationAuthorizationStatus()
     }
     }*/
    var whereAmIButton = UIButton(backgroundImageName: "ic_location", desiredSize: CGSize(width: 32, height: 32))!
    
    //var whereAmI = UIButton(frame: CGRect(x: 100, y: 100, width: 32, height: 32))
    
    @objc func whereAmI(sender: UIButton!) {
        // 迷醉？
        if let userLoc: MKUserLocation? = newMapView.userLocation {
            let cl = CLLocation(latitude: userLoc!.coordinate.latitude, longitude: userLoc!.coordinate.longitude)
            centerMapOnLocation(location: cl)
        } else {
            checkLocationAuthorizationStatus()
            print("FUCKYOU")
        }
    }
    var newMapView = MKMapView()
    
    //@IBOutlet var newMapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 100
    //let BeijingSpot = CLLocation(latitude: 39.903257, longitude: 116.301336)
    let defaultCenterSpot = CLLocation(latitude: 38.998244, longitude: 117.312924)
    var locationManager = CLLocationManager()

    let spots = ParkingSpot.parkingSpots
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            newMapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        newMapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whereAmIButton.addTarget(self, action: #selector(whereAmI(sender: )), for: .touchUpInside)
        
        computeLayout()

//        let centerMapVC = BicycleServiceMapController()
//        centerMapVC.centerMapOnLocation(location: defaultCenterSpot)
//        navigationController?.pushViewController(centerMapVC, animated: true)
//        self.present(centerMapVC, animated: true)
        centerMapOnLocation(location: defaultCenterSpot)
        
        newMapView.delegate = self
        if #available(iOS 9.0, *) {
            newMapView.showsCompass = true
        } else {
            // Fallback on earlier versions
        }
        
        newMapView.addAnnotations(spots!)
        //newMapView.addAnnotation(spot)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Constraint Layout using Snapkit
extension BicycleServiceMapController {
    
    func computeLayout() {
        
        view.addSubview(newMapView)
        newMapView.snp.makeConstraints {
            make in
            make.left.equalTo(view)
            make.top.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        whereAmIButton.alpha = 0.7
        newMapView.addSubview(whereAmIButton)
        whereAmIButton.snp.makeConstraints {
            make in
            make.right.equalTo(view).offset(-24)
            make.top.equalTo(view).offset(132)
        }
    }
}

//MARK: MapView Delegate
extension BicycleServiceMapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is ParkingSpot {
            
            let annotationIdentifier = "AnnotationIdentifier"
            if let dequeuedView = newMapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
                
                //log.word("Reused AnnotationView!")/
                return dequeuedView
            } else {
                
                //let fooAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                //fooAnnotationView.image = UIImage.resizedImage(UIImage(named: "大点位")!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                let fooAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                fooAnnotationView.canShowCallout = false
                //log.word("Created New AnnotationView")/
                return fooAnnotationView
            }
        } else {
            
            let userPinIdentifier = "UserPinIdentifier"
            if let dequeuedView = newMapView.dequeueReusableAnnotationView(withIdentifier: userPinIdentifier) {

                //log.word("Reused UserPinView!")/
                return dequeuedView
            } else {
                
                let fooAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: userPinIdentifier)
                fooAnnotationView.image = UIImage.resizedImage(image: UIImage(named: "小箭头")!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                fooAnnotationView.canShowCallout = false
                //log.word("Created New UserPinView!")/
                return fooAnnotationView
            }
            
        }
    }
    
    

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            let endFrame = view.frame
            view.frame = endFrame.offsetBy(dx: 0, dy: -250)
            UIView.animate(withDuration: 1) {
                view.frame = endFrame
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        guard let spot = view.annotation as? ParkingSpot else {
            return
        }
        guard let userLoc = newMapView.userLocation as? MKUserLocation else {
            (view.annotation as! ParkingSpot).getCurrentStatus {
                let detailView = SpotDetailsView(positionsAvailable: "\((spot.currentNumberOfBikes)!)/\(spot.numberOfBikes)", spotName: spot.title!, distanceFromUser: nil, status: spot.status)
                mapView.addSubview(detailView)
                self.checkLocationAuthorizationStatus()
            }
        }
        
        (view.annotation as! ParkingSpot).getCurrentStatus {
            let detailView = SpotDetailsView(positionsAvailable: "\((spot.currentNumberOfBikes)!)/\(spot.numberOfBikes)", spotName: spot.title!, distanceFromUser: spot.calculateDistance(userLocation: userLoc), status: spot.status)

            //log.any(spot.coordinate)/
            DispatchQueue.main.async {
                mapView.addSubview(detailView)
            }

        }

    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        for view in mapView.subviews {
            if view is SpotDetailsView {
                view.removeFromSuperview()
            }
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
}


//MARK: Geograph info Calculation and Fetching
extension BicycleServiceMapController {
    
}
