//
//  SearchPhoneCodeViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-07-21.
//

import UIKit
protocol SearchPhoneCodeViewControllerDelegate: AnyObject {
    func didSelectCountry(_ country: PhoneCode)
}

class SearchPhoneCodeViewController: UIViewController, StoryboardInitializable {
    //MARK: - Outlets

    @IBOutlet weak var mSearchBtn: UIButton!
    @IBOutlet weak var mSearchTableV: UITableView!
    @IBOutlet weak var mSearchTxtFl: TextField!
    @IBOutlet weak var mSearchContentV: UIView!
    
    //MARK: - Variables
    private let applicationSettings: ApplicationSettings = .shared
    var phoneCodes: [PhoneCode] = []
    weak var delegate: SearchPhoneCodeViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        mSearchTxtFl.delegate = self
        phoneCodes = applicationSettings.phoneCodes!
        mSearchContentV.setShadow(color: color_shadow!)
        mSearchTxtFl.setPlaceholder(string: Constant.Texts.search, font: font_search_cell!, color: color_email!)
    }
    
    
    @IBAction func searc(_ sender: UIButton) {
        self.search(text: mSearchTxtFl.text ?? "")
    }
    

}

//MARK: - UITableViewDelegate, UITableViewDataSource
//MARK: --------------------------------
extension SearchPhoneCodeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPhoneCodeTableViewCell.identifier, for: indexPath) as!  SearchPhoneCodeTableViewCell
        let model = phoneCodes[indexPath.row]
        cell.setCellInfo(item: model)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: SearchPhoneCodeTableViewCell = tableView.cellForRow(at:indexPath) as!   SearchPhoneCodeTableViewCell
        cell.layer.cornerRadius = 8
        cell.backgroundColor = color_dark_register!
        cell.mCountryLb.textColor = color_menu!

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ) {
            self.dismiss(animated: true) {
                if self.phoneCodes.count > 0 {
                    self.delegate?.didSelectCountry(self.phoneCodes[indexPath.row])
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func search(text: String) {
        let phoneCodesStore: [PhoneCode] = applicationSettings.phoneCodes!
        self.phoneCodes = phoneCodesStore.filter {
            if text.isEmpty {
                return true
                
            }; return $0.country?.lowercased().contains(text.lowercased()) ?? false }
        mSearchTableV.reloadData()
    }
    
}


//MARK: - UITextFieldDelegate

extension SearchPhoneCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mSearchTxtFl.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return true
        }
        
        let updatingString = text.replacingCharacters(in: textRange, with: string)
        self.search(text: updatingString)
        
        return true
    }
}
