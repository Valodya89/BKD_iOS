//
//  SeeMapViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-05-21.
//

import UIKit
import GoogleMaps
import SideMenu

class SeeMapViewController: BaseViewController, GMSMapViewDelegate {
    
    //MARK: - Outlets

    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mAddreassBckgV: UIView!
    
    //MARK: - Variables
    var menu: SideMenuNavigationController?
    let marker = GMSMarker()
    var locationManager = CLLocationManager()
    var mapView: GMSMapView?
   private lazy  var addressVC = AddressNameViewController.initFromStoryboard(name: Constant.Storyboards.seeMap)

    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addressVC.view.frame = CGRect(x: mAddreassBckgV.frame.origin.x,
                                       y:  mAddreassBckgV.frame.origin.y,
                                       width: mAddreassBckgV.bounds.size.width,
                                       height: mAddreassBckgV.bounds.size.height)
        guard let _ = marker.snippet, let _  = marker.title else {
            return }
        addressVC.mAddressNameLb.text = marker.snippet! + ", " + marker.title!
    }
    func setUpView() {
        configureNavigationBar()
        configureMapView()
        addChildView()
        configureDelegates()
    }
  
    
    private func configureNavigationBar() {
        // menu
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mRightBarBtn.image = UIImage(named:"bkd")?.withRenderingMode(.alwaysOriginal)
    }
    /// configure Delegates
    private func configureDelegates() {
        locationManager.delegate = self
        addressVC.delegate = self

    }
    /// configure map view
    func configureMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: zoom)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView!)
        addMarker(longitude: -33.86, latitude: 151.20, marker: marker)
        mapView!.isMyLocationEnabled = true
        mapView!.settings.compassButton = true
        mapView!.settings.myLocationButton = true
    }
    
    func  configureLocation()  {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
          switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
              print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
              print("Access")
          default :
            return
          }
        } else {
          print("Location services are not enabled")
        }
    }
    
    private func addChildView(){
        addChild(addressVC)
        view.addSubview(addressVC.view)
    }
    
    private func addMarker(longitude: Double, latitude: Double , marker: GMSMarker) {
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: longitude, longitude: latitude)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        marker.icon = img_map_marker
    }
    
    func showCurrentLocation() {
        mapView!.settings.myLocationButton = true
        let locationObj = locationManager.location!
        let coord = locationObj.coordinate
        let lattitude = coord.latitude
        let longitude = coord.longitude
        print(" lat in  updating \(lattitude) ")
        print(" long in  updating \(longitude)")

        let center = CLLocationCoordinate2D(latitude: locationObj.coordinate.latitude, longitude: locationObj.coordinate.longitude)
//        let marker = GMSMarker()
//        marker.position = center
//        marker.title = "current location"
//        marker.map = mapView
//        marker.icon = img_map_marker
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: zoom)
        self.mapView!.animate(to: camera)
    }
    
    //MARK: Action
    @IBAction func menu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true, completion: nil)
    }
}


//MARK: AddressNameViewControllerDelegate
extension SeeMapViewController: AddressNameViewControllerDelegate {
    func didPressOk() {
        self.navigationController?.popViewController(animated: true)

    }
    
    func didPressRoute() {
        
    }
    
    func didPressUserLocation() {
        self.showCurrentLocation()
    }
    
        
}

//MARK: CLLocationManagerDelegate
extension SeeMapViewController: CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
              // locationManager.startUpdatingLocation()

            mapView!.isMyLocationEnabled = true
            mapView!.settings.myLocationButton = true
           }
       }

    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first {
            mapView!.camera = GMSCameraPosition(target: location.coordinate, zoom: zoom, bearing: 0, viewingAngle: 0)
               locationManager.stopUpdatingLocation()

           }
       }
   // @available(iOS 14.0, *)

//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//        case .authorizedAlways:
//            return
//        case .authorizedWhenInUse:
//            return
//        case .denied:
//            return
//        case .restricted:
//            locationManager.requestWhenInUseAuthorization()
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        default:
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//    //Location Manager delegates
//    @available(iOS 12.0, *)
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let newLocation = locations.last // find your device location
//        mapView!.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 14.0) // show your device location on map
//        mapView!.settings.myLocationButton = true // show current location button
//        let lat = (newLocation?.coordinate.latitude)! // get current location latitude
//        let long = (newLocation?.coordinate.longitude)! //get current location longitude
//
//        marker.position = CLLocationCoordinate2DMake(lat,long)
//        marker.map = mapView
//        print("Current Lat Long - " ,lat, long )
//        locationManager.stopUpdatingLocation()
//
//    }
}
  
