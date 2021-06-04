//
//  CustomLocationViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 24-05-21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Mapbox

class CustomLocationViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var mMapV: GMSMapView!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mMarkerInfoBckgV: UIView!
    @IBOutlet weak var mUserLocationBckgV: UIView!
    @IBOutlet weak var mMarkInfoBackgBottom: NSLayoutConstraint!
    
    //MARK: - Variables
    let customLocationViewModel = CustomLocationViewModel()
    let searchTbV = UITableView()
    let marker = GMSMarker()
    var mapBoxView: MGLMapView! =  MGLMapView()

    // The currently selected place.
    var selectedPlace: GMSPlace?
    var currentMarker: GMSMarker?
    var placesClient: GMSPlacesClient!
    var mapViewCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0 , longitude: 0.0)
    private var locationManager = CLLocationManager()
    private var isChangeTableHeight = false
    private var searchTableHeight: CGFloat = 0.0
    private var searchTableData: String = String()
    private lazy  var searchCustomLocationCV = SearchCustomLocationUIViewController.initFromStoryboard(name: Constant.Storyboards.customLocation)
    private lazy  var markerInfoVC = MarkerInfoViewController.initFromStoryboard(name: Constant.Storyboards.customLocation)
    
    //MARK: - Life cycles
    //MARK ---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if  !isChangeTableHeight {
            searchCustomLocationCV.view.frame = CGRect(x: 0,
                                                       y: view.frame.size.height * 0.0099,
                                                       width: view.frame.size.width,
                                                       height: view.frame.height * 0.0655)
            
                markerInfoVC.view.frame = CGRect(x: 0,
                                                 y: 0,
                                                 width: mMarkerInfoBckgV.bounds.width,
                                                 height: mMarkerInfoBckgV.bounds.height)
            self.searchTbV.frame = CGRect(x: self.searchCustomLocationCV.mSearchBckgV.frame.origin.x,
                                          y: self.searchCustomLocationCV.view.frame.size.height + self.searchCustomLocationCV.view.frame.origin.y + 6,
                                          width: self.searchCustomLocationCV.mSearchBckgV.frame.size.width,
                                          height:0.0)
        } else {
            UIView.animate(withDuration: 0.3, animations: { [self] in
                self.searchTbV.frame = CGRect(x: self.searchCustomLocationCV.mSearchBckgV.frame.origin.x,
                                              y: self.searchCustomLocationCV.view.frame.size.height + self.searchCustomLocationCV.view.frame.origin.y + 6,
                                              width: self.searchCustomLocationCV.mSearchBckgV.frame.size.width,
                                              height: self.searchTableHeight)
            }, completion: nil)
            
        }
        if UIScreen.main.nativeBounds.height <= 1334 {
            self.markerInfoVC.mSearchBottom.constant = -15
        }
    }
    func setUpView() {
        mRightBarBtn.image = UIImage(named:"bkd")?.withRenderingMode(.alwaysOriginal)
        addChildView()
        addMarkerInfoView()
        configureDelegates()
        configureMapView()
        configureTableView()
    }
    
    /// configure Delegates
    private func configureDelegates() {
        searchCustomLocationCV.delegate = self
        markerInfoVC.delegate = self
        locationManager.delegate = self
        mMapV.delegate = self
       searchTbV.delegate = self
       searchTbV.dataSource = self
        mapBoxView.delegate = self
        
    }
    
    /// configure map view
    private func configureMapView() {
        mMapV.isMyLocationEnabled = true
        addInactiveCoordinates()
        moveCameraPosition(cord2D: CLLocationCoordinate2D(latitude: (InactiveLocationRangeData.inactiveLocationRangeModel)[0].latitude, longitude: InactiveLocationRangeData.inactiveLocationRangeModel[0].longitude))
        //  placesClient = GMSPlacesClient.shared()
        
    }
    
    /// configure table view
    private func configureTableView() {

        searchTbV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchTbV.backgroundColor = color_background
        searchTbV.dataSource = self
        searchTbV.delegate = self
        searchTbV.translatesAutoresizingMaskIntoConstraints = true
        searchTbV.rowHeight = UITableView.automaticDimension

        self.view.addSubview(searchTbV)
    }
    
    private func addChildView(){
        addChild(searchCustomLocationCV)
        view.addSubview(searchCustomLocationCV.view)
    }
    private func addMarkerInfoView(){
        addChild(markerInfoVC)
        mMarkerInfoBckgV.addSubview(markerInfoVC.view)
        // markerInfoVC.view.isHidden = true
        
    }
    private func addInactiveCoordinates(){
        for inactiveLocation in InactiveLocationRangeData.inactiveLocationRangeModel {
            drawRangeCircle(cord2D: CLLocationCoordinate2D(latitude:inactiveLocation.latitude, longitude: inactiveLocation.longitude),
                            radius: inactiveLocation.radius)
        }
    }
    
    private func addPlace(longitude: Double, latitude: Double ,
                          place: GMSPlace) {
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = mapViewCenterCoordinate
        marker.title = "location"
        marker.snippet = place.name
        marker.map = self.mMapV
        marker.icon = img_map_marker
    }
    
    private func addMarker(longitude: Double, latitude: Double , marker: GMSMarker) {
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: longitude, longitude: latitude)
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        // marker.title = "Sydney"
        //marker.snippet = "Australia"
        marker.position = center
        marker.map = mMapV
        marker.icon = img_map_marker
        currentMarker = marker
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        self.mMapV!.animate(to: camera)
    }
    
    private func  deleteMarker() {
       // self.markerInfoVC.mPriceBckVCenterVertical.constant = 0
        self.view.layoutIfNeeded()
        currentMarker?.map = nil
    }
    
    private func drawRangeCircle(cord2D: CLLocationCoordinate2D, radius: Double) {
        
        let circ = GMSCircle(position: cord2D, radius: CLLocationDistance(radius))
        circ.fillColor = color_map_circle!.withAlphaComponent(0.2)
        circ.strokeColor = .clear
        //  circ.isTappable = true
        circ.map = mMapV
    }
    private func moveCameraPosition(cord2D: CLLocationCoordinate2D) {
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: cord2D.latitude, longitude: cord2D.latitude, zoom: 9.0)
        self.mMapV!.animate(to: camera)
    }
    
    private func showMarkerInfo() {
        showAddressNameByGeocoder()
        mUserLocationBckgV.isHidden = true
        markerInfoVC.mDeleteAddressBtn.isHidden = false
        self.markerInfoVC.mErrorLb.isHidden = true
        markerInfoVC.mUserAddressLb.textColor = color_navigationBar
        markerInfoVC.mSearchBackgV.isUserInteractionEnabled = true
        markerInfoVC.mSearchBackgV.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: { [self] in
            mMarkInfoBackgBottom.constant = 0
            self.view.layoutIfNeeded()
        })        
    }
    
    private func showAddressNameByGeocoder() {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(mapViewCenterCoordinate) { response, _ in
            guard let address1 = response?.firstResult()?.lines?.first else {
                self.markerInfoVC.mUserAddressLb.text = "Can't detect address"
                return
            }
            self.markerInfoVC.mUserAddressLb.text = address1
       }
    }
    
    func showCurrentLocation() {
        let locationObj = locationManager.location!
        let coord = locationObj.coordinate
        let lattitude = coord.latitude
        let longitude = coord.longitude
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: zoom)
        self.mMapV!.animate(to: camera)
    }
    
    
    //MARK: ACTIONS
    //MARK ---------------------
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func userLocation(_ sender: UIButton) {
        showCurrentLocation()
    }
    
}


//MARK: SearchCustomLocationUIViewControllerDelegate
//MARK ---------------------
extension CustomLocationViewController: SearchCustomLocationUIViewControllerDelegate {
    func updateTableViewHeight(tableHeight: CGFloat, tableData: String) {
        isChangeTableHeight = true
        searchTableHeight = tableHeight
        searchTbV.reloadData()
        self.view.setNeedsLayout()
    }
    
    func goToPlaces()  {
        
    }
}

//MARK: MarkerInfoViewControllerDelegate
//MARK ---------------------
extension CustomLocationViewController: MarkerInfoViewControllerDelegate {
    func didPressUserLocation()  {
        showCurrentLocation()
    }
    
    func didPressDeleteLocation() {
        deleteMarker()
    }
}

////MARK: UITableViewDelegate
////MARK ---------------------
extension CustomLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "this is my test"
        cell.textLabel?.font = font_search_cell
        cell.textLabel?.textColor = color_navigationBar
        cell.backgroundColor = color_background
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: GMSAutocompleteViewControllerDelegate
//MARK ---------------------
//extension CustomLocationViewController: GMSAutocompleteViewControllerDelegate {
//
//    func viewController(_ vcontroller: GMSAutocompleteViewController,
//                        didAutocompleteWith place: GMSPlace ) {
//        dismiss(animated: true, completion: nil)
//
//        self.mMapV.clear()
//        self.searchCustomLocationCV.mSearchTxtFl.text = place.name
//        mapViewCenterCoordinate = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        self.addPlace(longitude: place.coordinate.longitude,
//                      latitude: place.coordinate.latitude,
//                      place: place)
//        self.mMapV.camera = GMSCameraPosition.camera(withTarget: mapViewCenterCoordinate, zoom: zoom)
//
//    }
//
//    func viewController(_ vcontroller: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error ) {
//
//        print(error.localizedDescription)
//    }
//
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//
//    }
//
//}


//MARK: GMSMapViewDelegate
//MARK: -------------------------
extension CustomLocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.addMarker(longitude: coordinate.longitude, latitude: coordinate.latitude, marker: marker)
        mapViewCenterCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        showMarkerInfo()
        for inactiveLocation in InactiveLocationRangeData.inactiveLocationRangeModel {
            var finish = false
            customLocationViewModel.isMarkerInInactiveCordinate(fromCoordinate: CLLocationCoordinate2D(latitude: inactiveLocation.latitude, longitude:inactiveLocation.longitude) ,
                                                                toCoordinate: coordinate,
                                                                radius: inactiveLocation.radius) { [self] (isInCoordinate) in
                if isInCoordinate == true {
                    self.markerInfoVC.mErrorLb.isHidden = false
                    self.markerInfoVC.mUserAddressLb.textColor = color_error
                    self.markerInfoVC.mSearchBackgV.isUserInteractionEnabled = false
                    self.markerInfoVC.mSearchBackgV.alpha = 0.8
                    finish = true
                }
            }
            if finish == true {
                return
            }
        }
        print("didTapAt coordinate = \(coordinate)")
    }
}


//MARK: CLLocationManagerDelegate
//MARK ---------------------
extension CustomLocationViewController: CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mMapV!.camera = GMSCameraPosition(target: location.coordinate, zoom: zoom, bearing: 0, viewingAngle: 0)
            
            let marker = GMSMarker()
            // marker.position = center
            marker.title = "current location"
            marker.map = mMapV
            marker.icon = img_map_marker
            locationManager.stopUpdatingLocation()
        }
    }
}


extension CustomLocationViewController: MGLMapViewDelegate {
   
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {

        mapViewCenterCoordinate = mapView.centerCoordinate
    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        //self.addressLbl.text = "checking.."
    }
}
