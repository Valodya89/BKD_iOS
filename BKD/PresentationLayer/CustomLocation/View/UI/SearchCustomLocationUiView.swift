//
//  SearchCustomLocationUiView.swift
//  BKD
//
//  Created by Karine Karapetyan on 28-05-21.
//

import UIKit

protocol SearchCustomLocationUIViewControllerDelegate: AnyObject {
    func goToPlaces()
    func updateTableViewHeight(tableHeight: CGFloat, tableData: String)
}

class SearchCustomLocationUIViewController: UIViewController, StoryboardInitializable {

    //MARK: - Outlets
    @IBOutlet weak var mSearchBckgV: UIView!
    @IBOutlet weak var mSearchTxtFl: UITextField!
    
    //MARK: Variables
    weak var delegate: SearchCustomLocationUIViewControllerDelegate?
    let searchCustomLocationViewModel = SearchCustomLocationViewModel()
    var keyboardHeight:CGFloat?
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    
    func setUpView() {
        mSearchTxtFl.returnKeyType = .search
        mSearchTxtFl.delegate = self
    }
       
    
    func serachPlaceFromGoogle(place: String)  {
        //https://maps.googleapis.com/maps/api/place/textsearch/output?parameters
        searchCustomLocationViewModel.getGooglePlaces(place: place) { (result) in
            print(result as Any)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            print(keyboardHeight)
        }
    }
    
    
}


//MARK: UITextFieldDelegate
//MARK: -------------------------
extension SearchCustomLocationUIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        serachPlaceFromGoogle(place: textField.text!)
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let fullString = NSString(string: text).replacingCharacters(in: range, with: string)

        var height:CGFloat = CGFloat( fullString.count * 45)
        
//        if  textField.text!.count > 8 {
//            height = 360
//        }
        if  height >= UIScreen.main.bounds.height - keyboardHeight! - 170 {
            height = UIScreen.main.bounds.height - keyboardHeight! - 170
        }
            delegate?.updateTableViewHeight(tableHeight: height, tableData: textField.text!)
            
        return true

    }
}

