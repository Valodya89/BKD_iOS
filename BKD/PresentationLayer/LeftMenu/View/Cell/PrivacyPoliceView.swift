//
//  PrivacyPoliceView.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-05-21.
//

import UIKit

class PrivacyPoliceView: UIViewController {

    @IBOutlet weak var mTermsOfUseLb: UILabel!
    @IBOutlet weak var mPrivacyPolicyLb: UILabel!
    @IBOutlet weak var mRightsReservedLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentUI()


    }

    /// Set Atributte to lable
    private func setAttribute(txt: String) -> NSMutableAttributedString {
        let attriString = NSMutableAttributedString(string: txt)
        let range1 = (txt as NSString).range(of: txt)
//        attriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        return attriString
//        mAgreeLb.attributedText = attriString
//        mAgreeLb.isUserInteractionEnabled = true
//        mAgreeLb.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapAgreeLabel(gesture:))))
    }
    
    func contentUI(){
        
        mPrivacyPolicyLb.attributedText = setAttribute(txt: Constant.Texts.privacyPolic)
        mPrivacyPolicyLb.isUserInteractionEnabled = true
        mPrivacyPolicyLb.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapPrivacyPolicyLabel(gesture:))))
        
        mTermsOfUseLb.attributedText = setAttribute(txt: Constant.Texts.termsOfUse)
        mTermsOfUseLb.isUserInteractionEnabled = true
        mTermsOfUseLb.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapTermsOfUseLb(gesture:))))
    }
    
  //MARK: -- Actions
    @IBAction func tapPrivacyPolicyLabel(gesture: UITapGestureRecognizer) {
        let range = (Constant.Texts.privacyPolic as NSString).range(of: Constant.Texts.privacyPolic)
        if gesture.didTapAttributedTextInLabel(label: mPrivacyPolicyLb, inRange: range) {
            
                let termsConditionsVC = TermsConditionsViewController.initFromStoryboard(name: Constant.Storyboards.registration)
                self.navigationController?.pushViewController(termsConditionsVC, animated: true)
        }
    }
    
    @IBAction func tapTermsOfUseLb(gesture: UITapGestureRecognizer) {
        let range = (Constant.Texts.termsOfUse as NSString).range(of: Constant.Texts.termsOfUse)
        if gesture.didTapAttributedTextInLabel(label: mTermsOfUseLb, inRange: range) {
            
                let termsConditionsVC = TermsConditionsViewController.initFromStoryboard(name: Constant.Storyboards.registration)
                self.navigationController?.pushViewController(termsConditionsVC, animated: true)
        }
    }
}
