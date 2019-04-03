//
//  ViewController.swift
//  mapsapi
//
//  Created by Joy Paul on 4/3/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    var mapView: GMSMapView?
    
    //init the location manager for device location
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mapView
        initMapView()
        checkLocationServices()
    }
    
    //check if the location service is actually enabled
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManger()
            checkLocationAuthorization()
        } else{
            
        }
    }
    
    //sets up location manager. Call when location services are enabled
    func setupLocationManger(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //the levels of location authorization and what to do
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        
        //only gets location when the app is open, the ideal condition
        case .authorizedWhenInUse:
            //centering the mapView on device's location
            centersCameraOnDevice()
            break
        //when user hasn't picked an allow or not allow auth option, ideal to ask for permission here
        case .notDetermined:
            //requesting when in use permission of location tracking
            locationManager.requestWhenInUseAuthorization()
            break
        //location services can be blocked by the device admin and user can't turn it on/off
        case .restricted:
            //display an alert letting them know what is going on
            break
        //once denied permission, user has to manually enable permissions again
        case .denied:
            //show an alert to let them know how to authorize again
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("Unknown value")
            fatalError()
        }
    }
    
    func deviceLocationButton(){
        let btn: UIButton = UIButton(type: UIButton.ButtonType.roundedRect)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        btn.setTitle("MyButton", for: UIControl.State.normal)
        self.view.addSubview(btn)
    }
    
    //init the GMS view **must check for internet connection first**
    func initMapView(){
        //the api access key for GMS
        GMSServices.provideAPIKey("your_api_key_here")
        
        //createing some dummy markers
        createMapMarkers(with: "stuff", with: "stuff caption", with: CLLocationCoordinate2D(latitude: 40.852651, longitude: -73.877160))
        
        createMapMarkers(with: "stuff 2", with: "stuff caption", with: CLLocationCoordinate2D(latitude: 40.824718, longitude: -73.870377))
        
        createMapMarkers(with: "stuff 3", with: "stuff caption", with: CLLocationCoordinate2D(latitude: 40.821302, longitude: -73.844189))
    }
    
    //camera helps center the position of the view, will use user's current location
    func centersCameraOnDevice(){
        if let location = locationManager.location?.coordinate{
            print(location.latitude)
            print(location.longitude)
            
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 13.0)
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            self.mapView?.isMyLocationEnabled = true
            
            locationManager.startUpdatingLocation()
        }
    }
    
    //creates markers on lat, lon and with title and sinppet
    func createMapMarkers(with title: String, with snippet: String, with latandlon: CLLocationCoordinate2D){
        // init marker variable
        let marker = GMSMarker()
        
        //specify the positions (lat and lon)
        marker.position = latandlon
        
        //any title and text you need
        marker.title = "\(title)"
        marker.snippet = "\(snippet)"
        
        //map the marker
        marker.map = mapView
    }
}



//Extending CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    //if auth changed, run through the switch case statements
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
