//
//  CustomLocationViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 24-05-21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

enum PlacesError: Error {
    case failedToFind
    case failedToGetCordinates
}

protocol CustomLocationViewControllerDelegate: AnyObject {
    func getCustomLocation(_ locationPlace: String,
                           coordinate: CLLocationCoordinate2D,
                           price: Double?)
}

class CustomLocationViewController: BaseViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var mMapV: GMSMapView!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mMarkerInfoBckgV: UIView!
    @IBOutlet weak var mUserLocationBckgV: UIView!
    @IBOutlet weak var mSwipeGestureBckgV: UIView!
    @IBOutlet weak var mSearchBtn: UIButton!
    @IBOutlet weak var mSearchLb: UILabel!
    @IBOutlet weak var mMarkInfoBackgBottom: NSLayoutConstraint!
    
    //MARK: - Variables
    var resultsViewController: GMSAutocompleteResultsViewController?
     var searchController: UISearchController?
     var resultView: UITextView?

    let customLocationViewModel = CustomLocationViewModel()
    var restrictedZones:[RestrictedZones]?
    let marker = GMSMarker()


    // The currently selected place.
    var currentMarker: GMSMarker?
   // var placesClient: GMSPlacesClient!
    var mapViewCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0 , longitude: 0.0)
    private var locationManager = CLLocationManager()
    var customLocation:CustomLocation?

    private lazy  var markerInfoVC = MarkerInfoViewController.initFromStoryboard(name: Constant.Storyboards.customLocation)
    private lazy  var addNewMarkerVC = MarkNewAddressViewController.initFromStoryboard(name: Constant.Storyboards.customLocation)
    
    weak var delegate: CustomLocationViewControllerDelegate?
    
    public var isAddDamageAddress: Bool = false
    //MARK: - Life cycles
    //MARK ---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        markerInfoVC.view.frame = CGRect(x: 0,
                                         y: 0,
                                         width: mMarkerInfoBckgV.bounds.width,
                                         height: mMarkerInfoBckgV.bounds.height)
        addNewMarkerVC.view.frame = CGRect(x: 0, y: 30,
                                            width: mMarkerInfoBckgV.bounds.width,
                                             height: mMarkerInfoBckgV.bounds.height - 30)
        
        if UIScreen.main.nativeBounds.height <= 1334 {
            self.markerInfoVC.mContinueBottom.constant = -15

        }
    }
    
    
    func setUpView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mRightBarBtn.image = img_bkd
        restrictedZones = ApplicationSettings.shared.restrictedZones
        if isAddDamageAddress {
            addNewAddressMarkerView()
        } else {
            addMarkerInfoView()
            addRestrictedZones()

        }
        configureDelegates()
        configureMapView()
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
        
        markerInfoVC.delegate = self
        //addNewMarkerVC.delegate = self
        locationManager.delegate = self
        mMapV.delegate = self
    }
    
    /// configure map view
    private func configureMapView() {
        mMapV.isMyLocationEnabled = true
        moveCameraPosition(cord2D: CLLocationCoordinate2D(latitude:40.194582, longitude:  44.495332) )
          placesClient = GMSPlacesClient.shared()
        self.view.bringSubviewToFront(mSwipeGestureBckgV)
    }
    
    ///Add marker information  view
    private func addMarkerInfoView(){
        addChild(markerInfoVC)
        mMarkerInfoBckgV.addSubview(markerInfoVC.view)
        markerInfoVC.didMove(toParent: self)
    }
    
    ///Add new marker information  view
    private func addNewAddressMarkerView(){
        addChild(addNewMarkerVC)
        mMarkerInfoBckgV.addSubview(addNewMarkerVC.view)
        addNewMarkerVC.didMove(toParent: self)
    }
   
    
    ///Add restricted zones
    private func addRestrictedZones(){
        guard let restrictedZones = restrictedZones  else { return }
        for restrictedZone in restrictedZones {
            drawRestractZone(cord2D: CLLocationCoordinate2D(latitude:restrictedZone.latitude, longitude: restrictedZone.longitude),
                            radius: restrictedZone.radius)
        }
    }
    
    
    ///Add marker on the map
    private func addMarker(longitude: Double, latitude: Double , marker: GMSMarker) {
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: longitude, longitude: latitude)
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.position = center
        marker.map = mMapV
        marker.icon = img_map_marker
        currentMarker = marker
    }
    
    ///Delete marker
    private func  deleteMarker() {
        self.view.layoutIfNeeded()
        currentMarker?.map = nil
        self.markerInfoVC.mValueBackgV.isHidden = true
        
    }
    
    ///Draw restract Zone on the map
    private func drawRestractZone(cord2D: CLLocationCoordinate2D, radius: Double) {
        
        let circ = GMSCircle(position: cord2D, radius: CLLocationDistance(radius))
        circ.fillColor = color_map_circle!.withAlphaComponent(0.2)
        circ.strokeColor = .clear
        circ.map = mMapV
    }
    
    ///Move camera position
    private func moveCameraPosition(cord2D: CLLocationCoordinate2D) {
        let camera: GMSCameraPosition =  GMSCameraPosition(target: CLLocationCoordinate2D(latitude: cord2D.latitude, longitude: cord2D.longitude), zoom: zoom, bearing: 0, viewingAngle: 0)
        self.mMapV!.animate(to: camera)
    }
    
    ///Show information of marked location
    private func showMarkerInfo() {
        showAddressNameByGeocoder()
        mUserLocationBckgV.isHidden = true
        markerInfoVC.mDeleteAddressBtn.isHidden = false
        self.markerInfoVC.mErrorLb.isHidden = true
        markerInfoVC.mUserAddressLb.textColor = color_navigationBar
        markerInfoVC.mContinueBackgV.isUserInteractionEnabled = true
        markerInfoVC.mContinueBackgV.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: { [self] in
            mMarkInfoBackgBottom.constant = 0
            self.view.layoutIfNeeded()
        })        
    }
    
    ///Show information of marked location
    private func showAddNewAddressMarkerInfo() {
        showAddressNameByGeocoder()
        mUserLocationBckgV.isHidden = true        
        addNewMarkerVC.mNewAddressLb.textColor = color_navigationBar
        UIView.animate(withDuration: 0.3, animations: { [self] in
            mMarkInfoBackgBottom.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    
    ///Show address name
    private func showAddressNameByGeocoder() {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(mapViewCenterCoordinate) { response, _ in
            guard let address1 = response?.firstResult()?.lines?.first else {
                if self.isAddDamageAddress {
                    self.addNewMarkerVC.mNewAddressLb.text = Constant.Texts.errAddress
                } else {
                    self.markerInfoVC.mUserAddressLb.text = Constant.Texts.errAddress
                }
                return
            }
            
            if self.isAddDamageAddress {
                self.addNewMarkerVC.mNewAddressLb.text = address1
            } else {
                self.markerInfoVC.mUserAddressLb.text = address1
            }
       }
    }
    
    ///Show curren t location
    func showCurrentLocation() {
        let locationObj = locationManager.location!
        let coord = locationObj.coordinate
        moveCameraPosition(cord2D: coord)
    }
    
    
    ///Check is cordinate in restract zone
    func isInRestractZone(coordinate: CLLocationCoordinate2D) -> Bool{
        for restrictedZone in restrictedZones! {
            var finish = false
            
            customLocationViewModel.isMarkerInInactiveCordinate(restrictedZone: restrictedZone,
                        toCoordinate: coordinate) { [self] (isInCoordinate) in
                
                if isInCoordinate == true {
                    self.markerInfoVC.mErrorLb.isHidden = false
                    self.markerInfoVC.mUserAddressLb.textColor = color_error
                    self.markerInfoVC.mContinueBackgV.isUserInteractionEnabled = false
                    self.markerInfoVC.mContinueBackgV.alpha = 0.8
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
    
    ///Update screen info depend on coordinate
    func updateMapByCoordinate(coordinate: CLLocationCoordinate2D) {
        
        self.addMarker(longitude: coordinate.longitude, latitude: coordinate.latitude, marker: marker)
        mapViewCenterCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        if isAddDamageAddress {
           showAddNewAddressMarkerInfo()
        } else {
            showMarkerInfo()
            let _ = isInRestractZone(coordinate: coordinate)
        }
    }
    
    
    ///show Autocomplete View Controller
    func showAutocompleteViewController() {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.tableCellBackgroundColor = color_background!
        autocompleteController.secondaryTextColor = color_main!
        autocompleteController.primaryTextColor = color_navigationBar!

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        
        //search by country
        filter.type = .establishment
        filter.countries = ["AM"]
       // filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
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
    
    @IBAction func search(_ sender: UIButton) {
        showAutocompleteViewController()
    }
}



//MARK: MarkerInfoViewControllerDelegate
//MARK ---------------------
extension CustomLocationViewController: MarkerInfoViewControllerDelegate {
    
    func didPressContinue(place: String, price: Double?) {
        self.delegate?.getCustomLocation(place, coordinate: mapViewCenterCoordinate, price: price)
        self.navigationController?.popViewController(animated: true)
    }
    
    func didPressUserLocation()  {
        showCurrentLocation()
    }
    
    func didPressDeleteLocation() {
        deleteMarker()
    }
}


//MARK: GMSMapViewDelegate
//MARK: -------------------------
extension CustomLocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        updateMapByCoordinate(coordinate: coordinate)
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
    
      self.resolveLocation(place: place) { result  in
        switch result {
        case .success(let coordinate):
            self.updateMapByCoordinate(coordinate: coordinate)
            self.moveCameraPosition(cord2D: coordinate)
            print(coordinate)
        case .failure( _ ):
            self.showAlertMessage(Constant.Texts.errLocation)
        }
    }
    
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

    
/////Resolve Location
// private func resolveLocation(place: GMSPlace, completion: @escaping (Result<CLLocationCoordinate2D, Error> ) -> Void) {
//
//        placesClient.fetchPlace(fromPlaceID: place.placeID ?? "",
//                                placeFields: .coordinate,
//                                sessionToken: nil) { (googlePlace, error) in
//            guard let googlePlace = googlePlace, error == nil else {
//                completion(.failure(PlacesError.failedToGetCordinates))
//                return
//            }
//            let coordinate = CLLocationCoordinate2DMake(googlePlace.coordinate.latitude,
//                                                        googlePlace.coordinate.longitude)
//            completion(.success(coordinate))
//        }
//    }
}


//extension CustomLocationViewController: MarkNewAddressViewControllerDelegate  {
//    func didPressContinue(place: String) {
//
//    }
//
//
//
//}
