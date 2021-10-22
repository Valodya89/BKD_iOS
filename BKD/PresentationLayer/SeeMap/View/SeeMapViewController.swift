//
//  SeeMapViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-05-21.
//

import UIKit
import GoogleMaps
import SideMenu

class SeeMapViewController: BaseViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mAddreassBckgV: UIView!
    @IBOutlet weak var mSwipeGestureBckgV: UIView!
    
    //MARK: - Variables
    var menu: SideMenuNavigationController?
    let marker = GMSMarker()
    var locationManager = CLLocationManager()
    var mapView: GMSMapView?
    var mapViewCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0 , longitude: 0.0)
    
    var parking: Parking?

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
    }
    
    
    func setUpView() {
        navigationController?.setNavigationBarBackground(color: color_navigationBar!)
        configureNavigationBar()
        configureMapView()
        addChildView()
        configureDelegates()
    }
  
    
    private func configureNavigationBar() {
        // menu
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mRightBarBtn.image = img_bkd
    }
    /// configure Delegates
    private func configureDelegates() {
        mapView?.delegate = self
        locationManager.delegate = self
        addressVC.delegate = self
    }
    
    
    /// configure map view
    func configureMapView() {
        
        guard let parking = parking else { return }
        mapView = GMSMapView(frame: self.view.bounds)

        self.view.addSubview(mapView!)
        addMarker(longitude: parking.longitude, latitude: parking.latitude, marker: marker)
        mapView!.isMyLocationEnabled = true
        self.mapView!.animate(toZoom: 4)
        self.view.bringSubviewToFront(mSwipeGestureBckgV)
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
        addressVC.didMove(toParent: self)
    }
    
    private func addMarker(longitude: Double, latitude: Double , marker: GMSMarker) {
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: longitude, longitude: latitude)
        marker.map = mapView
        marker.icon = img_map_marker
        showAddressNameByGeocoder(mapViewCenterCoordinate: marker.position)
    }
    
    private func showAddressNameByGeocoder(mapViewCenterCoordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(mapViewCenterCoordinate) { response, _ in
            guard let address = response?.firstResult()?.lines?.first else {
                self.addressVC.mAddressNameLb.text = Constant.Texts.errAddress
                return
            }
            self.addressVC.mAddressNameLb.text = address
       }
    }
    
    func showCurrentLocation() {
        let locationObj = locationManager.location!
        let coord = locationObj.coordinate
        let lattitude = coord.latitude
        let longitude = coord.longitude
        let camera: GMSCameraPosition =  GMSCameraPosition(target: CLLocationCoordinate2D(latitude: lattitude, longitude: longitude), zoom: zoom, bearing: 0, viewingAngle: 0)
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
        var url = "yandexnavi://build_route_on_map?lat_to=\(mapViewCenterCoordinate.latitude)&lon_to=\(mapViewCenterCoordinate.longitude)"
        if UIApplication.shared.canOpenURL(URL(string: url)!) {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        } else {
            url = "https://itunes.apple.com/ru/app/yandex.navigator/id474500851"
            if UIApplication.shared.canOpenURL(URL(string: url)!) {
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }
        }
        
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
           }
       }

    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first {
            mapView!.camera = GMSCameraPosition(target: location.coordinate, zoom: zoom, bearing: 0, viewingAngle: 0)
               locationManager.stopUpdatingLocation()
           }
       }
}
  
extension SeeMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("willMove")
    //
    }

    // Touch drag and lift
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt position \(position)")

    //
    }

    // Touch and lift
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("yes")
    }
}
