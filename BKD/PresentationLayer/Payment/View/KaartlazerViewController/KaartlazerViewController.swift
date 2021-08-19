//
//  KaartlazerViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-08-21.
//

import UIKit

class KaartlazerViewController: UIViewController {
    @IBOutlet weak var mContinueLeading: NSLayoutConstraint!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mTextV: UITextView!
    @IBOutlet weak var mContinueBtn: UIButton!
    @IBOutlet weak var mContinueV: UIView!
    @IBOutlet weak var mCodeTxtFl: OneTimeCodeTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        mRightBarBtn.image = #imageLiteral(resourceName: "bkd")
        mCodeTxtFl.defaultCharacter = Constant.Texts.generatedCode
        mCodeTxtFl.configure(with: 5)
    }
    
    
    
    /// Animate Confirm click
    private func clickContinue() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mContinueLeading.constant = self.mContinueV.bounds.width - self.mContinueBtn.frame.size.width
            self.mContinueV.layoutIfNeeded()

        } completion: { _ in
        }
    }
    
    
    
    // MARK: -- Actions
    @IBAction func changeTextFiled(_ sender: OneTimeCodeTextField) {
    }
    
    @IBAction func back(_ sender: Any) {
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        clickContinue()
    }
    
    @IBAction func continueSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        clickContinue()
    }
}
