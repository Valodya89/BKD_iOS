//
//  CustomLocationViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 24-05-21.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol CustomLocationViewControllerDelegate: AnyObject {
    func getCustomLocation(_ locationPlace: String)
}

class CustomLocationViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var mMapV: GMSMapView!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mMarkerInfoBckgV: UIView!
    @IBOutlet weak var mUserLocationBckgV: UIView!
    @IBOutlet weak var mSwipeGestureBckgV: UIView!
    @IBOutlet weak var mMarkInfoBackgBottom: NSLayoutConstraint!
    
    //MARK: - Variables
    //let searchVC = UISearchController(searchResultsController: ResultViewController())
    let customLocationViewModel = CustomLocationViewModel()
    var restrictedZones:[RestrictedZones]?
    let searchTbV = UITableView()
    let marker = GMSMarker()


    // The currently selected place.
    var selectedPlace: GMSPlace?
    var currentMarker: GMSMarker?
    var placesClient: GMSPlacesClient!
    var mapViewCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0 , longitude: 0.0)
    private var locationManager = CLLocationManager()
    private var isChangeTableHeight = false
    private var searchTableHeight: CGFloat = 0.0
    private var searchTableData: String = String()
    var customLocation:CustomLocation?
    
    private lazy  var searchCustomLocationCV = SearchCustomLocationUIViewController.initFromStoryboard(name: Constant.Storyboards.customLocation)
    private lazy  var markerInfoVC = MarkerInfoViewController.initFromStoryboard(name: Constant.Storyboards.customLocation)
    weak var delegate: CustomLocationViewControllerDelegate?
    
    //MARK: - Life cycles
    //MARK ---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addSubview(searchVC.searchBar)
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
            self.markerInfoVC.mContinueBottom.constant = -15
        }
    }
    func setUpView() {
        mRightBarBtn.image = img_bkd
        restrictedZones = ApplicationSettings.shared.restrictedZones
        addChildView()
        addMarkerInfoView()
        configureDelegates()
        configureMapView()
        configureTableView()
        addRestrictedZones()
        
    }
    
    
    /// Get marked location price
    func getCustomLocationPrice(longitude: Double, latitude: Double) {
        customLocationViewModel.getCustomLocation(longitude: longitude, latitude: latitude) { [weak self] (result) in
            
            guard let self = self else {return}
            self.customLocation = result
            guard let price = self.customLocation?.amount else {
                self.markerInfoVC.mValueBackgV.isHidden = true
                return
            }
            self.markerInfoVC.mPriceLb.text = String(price)
            self.markerInfoVC.mValueBackgV.isHidden = false

        }
    }
    
    /// configure Delegates
    private func configureDelegates() {
        searchCustomLocationCV.delegate = self
        markerInfoVC.delegate = self
        locationManager.delegate = self
        mMapV.delegate = self
       searchTbV.delegate = self
       searchTbV.dataSource = self
    }
    
    /// configure map view
    private func configureMapView() {
        mMapV.isMyLocationEnabled = true
        moveCameraPosition(cord2D: CLLocationCoordinate2D(latitude:50.296749, longitude:  4.381935))
          placesClient = GMSPlacesClient.shared()
        self.view.bringSubviewToFront(mSwipeGestureBckgV)
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
        searchCustomLocationCV.didMove(toParent: self)
    }
    
    private func addMarkerInfoView(){
        addChild(markerInfoVC)
        mMarkerInfoBckgV.addSubview(markerInfoVC.view)
        markerInfoVC.didMove(toParent: self)
    }
   
    
    ///Add restricted zones
    private func addRestrictedZones(){
        guard let restrictedZones = restrictedZones  else { return }
        for restrictedZone in restrictedZones {
            drawRangeCircle(cord2D: CLLocationCoordinate2D(latitude:restrictedZone.latitude, longitude: restrictedZone.longitude),
                            radius: restrictedZone.radius)
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
        marker.position = center
        marker.map = mMapV
        marker.icon = img_map_marker
        currentMarker = marker
    }
    
    private func  deleteMarker() {
        self.view.layoutIfNeeded()
        currentMarker?.map = nil
        self.markerInfoVC.mValueBackgV.isHidden = true
        
    }
    
    private func drawRangeCircle(cord2D: CLLocationCoordinate2D, radius: Double) {
        
        let circ = GMSCircle(position: cord2D, radius: CLLocationDistance(radius))
        circ.fillColor = color_map_circle!.withAlphaComponent(0.2)
        circ.strokeColor = .clear
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
        markerInfoVC.mContinueBackgV.isUserInteractionEnabled = true
        markerInfoVC.mContinueBackgV.alpha = 1.0
        //markerInfoVC.mContinueBackgV.isHidden = false
        UIView.animate(withDuration: 0.3, animations: { [self] in
            mMarkInfoBackgBottom.constant = 0
            self.view.layoutIfNeeded()
        })        
    }
    
    private func showAddressNameByGeocoder() {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(mapViewCenterCoordinate) { response, _ in
            guard let address1 = response?.firstResult()?.lines?.first else {
                self.markerInfoVC.mUserAddressLb.text = Constant.Texts.cantDetectAddress
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
    
    @IBAction func backSwipe(_ sender: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: SearchCustomLocationUIViewControllerDelegate
//MARK ---------------------
extension CustomLocationViewController: SearchCustomLocationUIViewControllerDelegate {
    func showAutocompleteViewController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
   }
    
    func updateTableViewHeight(tableHeight: CGFloat, tableData: String) {
        isChangeTableHeight = true
        searchTableHeight = tableHeight
        searchTbV.reloadData()
        self.view.setNeedsLayout()
       // goToPlaces()
    }
    
    func goToPlaces()  {
//        let acControllers = GMSAutocompleteViewController()
//        acControllers.delegate = self
//        present(acControllers, animated: true, completion: nil)
    }
    
    
}

//MARK: MarkerInfoViewControllerDelegate
//MARK ---------------------
extension CustomLocationViewController: MarkerInfoViewControllerDelegate {
    func didPressContinue(place: String) {
        self.delegate?.getCustomLocation(place)
        self.navigationController?.popViewController(animated: true)
    }
    
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




//MARK: GMSMapViewDelegate
//MARK: -------------------------
extension CustomLocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.addMarker(longitude: coordinate.longitude, latitude: coordinate.latitude, marker: marker)
        mapViewCenterCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        showMarkerInfo()
        let _ = isInRestractZone(coordinate: coordinate)
    }
    
    private func isInRestractZone(coordinate: CLLocationCoordinate2D) -> Bool{
        for restrictedZone in restrictedZones! {
            var finish = false
            
            customLocationViewModel.isMarkerInInactiveCordinate(restrictedZone: restrictedZone,
                        toCoordinate: coordinate) { [self] (isInCoordinate) in
                
                if isInCoordinate == true {
                    self.markerInfoVC.mErrorLb.isHidden = false
                    self.markerInfoVC.mUserAddressLb.textColor = color_error
                    self.markerInfoVC.mContinueBackgV.isUserInteractionEnabled = false
                     self.markerInfoVC.mContinueBackgV.alpha = 0.8
                    //self.markerInfoVC.mContinueBackgV.isHidden = true
                    self.markerInfoVC.mValueBackgV.isHidden = true
                    finish = true
                }
            }
            if finish == true {
                return true
            }
        }
        getCustomLocationPrice(longitude: coordinate.longitude, latitude: coordinate.latitude)
        return false
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

extension CustomLocationViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
