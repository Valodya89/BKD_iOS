//
//  DetailsViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-06-21.
//

import UIKit

class DetailsViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var carPhotosView: CarPhotosView!
    @IBOutlet weak var mCarInfoV: CarInfoView!
    @IBOutlet weak var mDetailsAndTailLiftV: DetailsAndTailLiftView!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
   
    @IBOutlet weak var mDetailsTbV: DetailsTableView!
    @IBOutlet weak var mTariffCarouselV: TariffCarouselView!
    @IBOutlet weak var mDetailsTableBckgV: UIView!
       @IBOutlet weak var mTailLiftTbV: TailLiftTableView!
    @IBOutlet weak var mTailLiftTableBckgV: UIView!
    
    @IBOutlet weak var mDetailsTbVHeight: NSLayoutConstraint!
    @IBOutlet weak var mTailLiftTbVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mAccessoriesBtn: UIButton!
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mAdditionalDriverBtn: UIButton!
    
    @IBOutlet weak var mSearchWithValueStackV: SearchWithValueView!
    @IBOutlet weak var mSearchV: SearchView!
    @IBOutlet weak var mReserveBckgV: UIView!
    @IBOutlet weak var mReserveBtn: UIButton!
    
    //MARK: Varables
    private lazy  var tariffSlideVC = TariffSlideViewController.initFromStoryboard(name: Constant.Storyboards.details)
    
    let datePicker = UIDatePicker()
    let backgroundV =  UIView()
    var responderTxtFl = UITextField()
    
    private let scrollPadding: CGFloat = 60
    private  var tariffSlideY: CGFloat = 0
    private var lastContentOffset: CGFloat = 0
    private var previousContentPosition: CGPoint?
    private var scrollContentHeight: CGFloat = 0.0
    private var isScrolled = false
    private var isFromSerach = true
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if scrollContentHeight == 0.0 {
            
            scrollContentHeight = isFromSerach ? mScrollV.bounds.height + mTariffCarouselV.bounds.height + mSearchWithValueStackV.bounds.height : mScrollV.bounds.height + mTariffCarouselV.bounds.height 
            
        }
        mScrollV.contentSize.height = scrollContentHeight
        setTableViewsHeight()
        setTariffSlideViewFrame()
    }
    
    func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = #imageLiteral(resourceName: "bkd").withRenderingMode(.alwaysOriginal)
        configureViews()
        configureTransparentView()
        configureDelegates()
        addTariffSliedView()
        showLocation()
        didPressEdit()
            
    }
    
    private func configureTransparentView()  {
        backgroundV.frame = self.view.bounds
        backgroundV.backgroundColor = .black
        backgroundV.alpha = 0.6
    }
    /// set height to details or tailLift tableView
    func  setTableViewsHeight() {
        if DetailsData.detailsModel.count > 11{
            mDetailsTbVHeight.constant = 11 * detail_cell_height
        } else {
            mDetailsTbVHeight.constant = CGFloat(DetailsData.detailsModel.count) * detail_cell_height
        }
        mDetailsTbV.frame.size = CGSize(width: mDetailsTbV.frame.size.width, height: mDetailsTbVHeight.constant)
        self.view.layoutIfNeeded()
        if TailLiftData.tailLiftModel.count > 10 {
            mTailLiftTbVHeight.constant = 10 * tailLift_cell_height
        } else {
            mTailLiftTbVHeight.constant = CGFloat(TailLiftData.tailLiftModel.count) * tailLift_cell_height
        }
    }
    
    ///set frame to Tariff Slide View
    func setTariffSlideViewFrame() {
        var bottomPadding:CGFloat  = 0
        let tariffSlideHeight = self.view.bounds.height * 0.08168
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            bottomPadding = window.safeAreaInsets.bottom
        }
        if UIScreen.main.nativeBounds.height <= 1334 {
            bottomPadding = 22
        }
        if !isScrolled {
            tariffSlideY = (self.view.bounds.height * 0.742574) - bottomPadding
            tariffSlideVC.view.frame = CGRect(x: 0,
                                              y: tariffSlideY,
                                              width: self.view.bounds.width,
                                              height: tariffSlideHeight)
        }
    }
    private func configureViews () {
        mDetailsTbV.setShadow(color: color_shadow!)
        mDetailsTbV.layer.cornerRadius = 3
        mTailLiftTableBckgV.setShadow(color: color_shadow!)
        mTailLiftTableBckgV.layer.cornerRadius = 3
        mAccessoriesBtn.layer.cornerRadius = 8
        mAdditionalDriverBtn.layer.cornerRadius = 8
        mReserveBckgV.setGradientWithCornerRadius(cornerRadius: 0.0, startColor:color_Offline_bckg!, endColor:color_Offline_bckg!.withAlphaComponent(0.85) )
        mReserveBckgV.roundCorners(corners: [.topRight], radius: 20)
        
    }
    func configureDelegates() {
        mDetailsAndTailLiftV.delegate = self
        mTariffCarouselV.delegate = self
        mSearchV.delegate = self
        mScrollV.delegate = self
        
    }
    
    /// Add child view
    func addTariffSliedView() {
        addChild(tariffSlideVC)
        self.view.addSubview(tariffSlideVC.view)

       // self.view.bringSubviewToFront(mDetailsTbV)

    }
    
    /// ScrollView will scroll to bottom
    private func scrollToBottom(distance: CGFloat) {
        let y = mScrollV.contentSize.height - mScrollV.bounds.height + mScrollV.contentInset.bottom + distance
        previousContentPosition = mScrollV.contentOffset
        scrollContentHeight = mScrollV.contentSize.height
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: { [self] in
                self.mScrollV.contentOffset.y = y
            }, completion: nil)
        }
    }
    private func scrollToBack() {
//scrollContentHeight = mScrollV.bounds.height + mTariffCarouselV.bounds.height + mSearchV.bounds.height
        mScrollV.setContentOffset(previousContentPosition ?? CGPoint.zero, animated: true)
    }

    /// will be hidden search view
    private func hideSearchView() {
        UIView.animate(withDuration: 1) { [self] in
            self.mSearchV.alpha = 0.0
        } completion: { [self]  _ in
            self.mSearchV.isHidden = true
        }
    }
   
    //MARK: METHODS
    //MARK: ---------------
    func didPressEdit() {
        mSearchWithValueStackV.didPressEdit = {
            UIView.animate(withDuration: 1.0) { [self] in
                self.mSearchWithValueStackV.alpha = 0.0
                showSearchView(isSelect: true)
            } completion: {[self] _ in
                self.mSearchWithValueStackV.isHidden = true
            }

        }
    }
    func hideDateInfo(dayBtn : UIButton,
                      monthBtn: UIButton,
                      hidden: Bool,
                      txtFl: UITextField)  {
        dayBtn.isHidden = hidden
        monthBtn.isHidden = hidden
        if hidden == false {
            responderTxtFl.text = ""
        }
    }
    
    ///Will put new values from pickerDate
    func showSelectedDate(dayBtn : UIButton?, monthBtn: UIButton?) {
        if responderTxtFl.tag > 1 {
            responderTxtFl.font =  UIFont.init(name: (responderTxtFl.font?.fontName)!, size: 18.0)

            responderTxtFl.text = datePicker.date.getHour()
            responderTxtFl.textColor = color_entered_date

        } else {
            dayBtn?.setTitle(String(datePicker.date.get(.day)), for: .normal)
            monthBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)
        }
    }
    
    
    ///will be show the selected location to map from the list of tables
    func showLocation() {
        mSearchV!.mLocationDropDownView.didSelectSeeMap = { [weak self]  in
            let seeMapContr = UIStoryboard(name: Constant.Storyboards.seeMap, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.seeMap) as! SeeMapViewController
            self?.navigationController?.pushViewController(seeMapContr, animated: true)
        }
    }
    ///will be show the custom location map controller
    func showCustomLocationMap() {
        let customLocationContr = UIStoryboard(name: Constant.Storyboards.customLocation, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.customLocation) as! CustomLocationViewController
        self.navigationController?.pushViewController(customLocationContr, animated: true)
    }
    
    func showAlertCustomLocation(checkedBtn: UIButton) {
        BKDAlert().showAlert(on: self,
                             title:Constant.Texts.titleCustomLocation,
                             message: Constant.Texts.messageCustomLocation,
                             messageSecond: Constant.Texts.messageCustomLocation2,
                             cancelTitle: Constant.Texts.cancel,
                             okTitle: Constant.Texts.agree,cancelAction: {
                                checkedBtn.setImage(img_uncheck_box, for: .normal)
                             }, okAction: { [self] in
                                self.showCustomLocationMap()
                             })
    }
    
    @objc func donePressed() {
        responderTxtFl.resignFirstResponder()
        scrollToBack()
        DispatchQueue.main.async() {
            self.backgroundV.removeFromSuperview()
        }
    
        if responderTxtFl.tag == 0 { // PickUpDate
        
            hideDateInfo(dayBtn: mSearchV!.mDayPickUpBtn,
                          monthBtn: mSearchV!.mMonthPickUpBtn,
                          hidden: false, txtFl: responderTxtFl)
            showSelectedDate(dayBtn: mSearchV!.mDayPickUpBtn,
                             monthBtn: mSearchV!.mMonthPickUpBtn)
            
        } else if responderTxtFl.tag == 1 { // ReturnDate
            hideDateInfo(dayBtn: mSearchV!.mDayReturnDateBtn,
                          monthBtn: mSearchV!.mMonthReturnDateBtn,
                          hidden: false, txtFl: responderTxtFl)
            showSelectedDate(dayBtn: mSearchV!.mDayReturnDateBtn,
                             monthBtn: mSearchV!.mMonthReturnDateBtn)
            
        } else {
            showSelectedDate(dayBtn: nil, monthBtn: nil)
            
        }
    }
    
    
    
    //MARK: ACTIONS
    //MARK: --------------------

    ///Navigation controller will back to pravius controller
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func accessories(_ sender: UIButton) {
        let accessoriesVC = UIStoryboard(name: Constant.Storyboards.accessories, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.accessories) as! AccessoriesUIViewController
        self.navigationController?.pushViewController(accessoriesVC, animated: true)
    }
    @IBAction func additionalDriver(_ sender: UIButton) {
        let myDriverVC = UIStoryboard(name: Constant.Storyboards.myDrivers, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.myDrivers) as! MyDriversViewController
        self.navigationController?.pushViewController(myDriverVC, animated: true)
    }
    
    @IBAction func reserve(_ sender: UIButton) {
        let recerve = UIStoryboard(name: Constant.Storyboards.reserve, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.reserve) as! ReserveViewController
        self.navigationController?.pushViewController(recerve, animated: true)
    }
}

 
//MARK: DetailsAndTailLiftViewDelegate
//MARK: ----------------------------------
extension DetailsViewController: DetailsAndTailLiftViewDelegate {
    
    func didPressDetails(willOpen: Bool) {
        if willOpen  {
            scrollToBottom(distance: 0.0)
            if self.mTailLiftTableBckgV.alpha == 1 {
                // will show Details tableView and close TailLift tableView
                    UIView.transition(with: mTailLiftTableBckgV, duration: 1, options: [.transitionCurlUp,.allowUserInteraction], animations: { [self] in
                        
                        self.mDetailsAndTailLiftV.mTailLiftDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
                        self.mTailLiftTableBckgV.alpha = 0
                    }, completion: { [self]_ in
                        self.mTailLiftTableBckgV.isHidden = true
                        UIView.transition(with: self.mDetailsTbV, duration: 1, options: [.transitionCurlDown,.allowUserInteraction], animations: { [self] in
                            self.mDetailsAndTailLiftV.mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
                            self.mDetailsTbV.alpha = 1
                            self.mDetailsTbV.isHidden = false
                        }, completion: nil)
                    })
                
            } else { // will show Details tableView
                
                UIView.transition(with: mDetailsTableBckgV, duration: 1, options: [.transitionCurlDown,.allowUserInteraction], animations: { [self] in
                    self.mDetailsAndTailLiftV.mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
                    self.mDetailsTableBckgV.alpha = 1
                    self.mDetailsTableBckgV.isHidden = false
                }, completion: nil)
            }
            
        } else if !willOpen { // will hide Details tableView

            UIView.transition(with: mDetailsTableBckgV, duration: 1, options: [.transitionCurlUp,.allowUserInteraction], animations: { [self] in
                self.mDetailsAndTailLiftV.mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
                self.mDetailsTableBckgV.alpha = 0
            }, completion: {_ in
                self.mDetailsTableBckgV.isHidden = true
            })
        }
    }
    
    func didPressTailLift(willOpen: Bool) {
        scrollToBottom(distance: 0.0)

        // will show TailLift tableView
        if willOpen {
            UIView.transition(with: mTailLiftTableBckgV, duration: 1, options: [.transitionCurlDown,.allowUserInteraction], animations: { [self] in
                self.mTailLiftTableBckgV.alpha = 1
                self.mTailLiftTableBckgV.isHidden = false
            }, completion: nil)
        } else if !willOpen { // will hide TailLift tableView
            UIView.transition(with: mTailLiftTableBckgV, duration: 1, options: [.transitionCurlUp,.allowUserInteraction], animations: { [self] in
                self.mTailLiftTableBckgV.alpha = 0
            }, completion: {_ in
                self.mTailLiftTableBckgV.isHidden = true
            })
        }
    }
    
}


//MARK: TariffCarouselViewDelegate
//MARK: ----------------------------
extension DetailsViewController: TariffCarouselViewDelegate {
    func showSearchView(isSelect: Bool) {
        if mSearchV.isHidden  {
            mSearchV.isHidden = false
            UIView.animate(withDuration: 1.5) { [self] in
                mScrollV.contentSize.height = mScrollV.contentSize.height + mSearchV.bounds.height
                self.scrollToBottom(distance: 0.0)
                self.mSearchV.alpha = 1
            }
        }
    }
    
    func didPressMore() {
        let moreVC = UIStoryboard(name: Constant.Storyboards.more, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.more) as! MoreViewController
        self.navigationController?.pushViewController(moreVC, animated: true)
    }
    
}

//MARK: SearchViewDelegate
//MARK: --------------------
extension DetailsViewController: SearchViewDelegate {
    func didSelectPickUp(textFl: UITextField) {
       
        self.view.addSubview(self.backgroundV)
        print("didSelectPickUp")
        //toolBAr
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //bar Button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.donePressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, done], animated: false)
  
        textFl.inputView = self.datePicker
        textFl.inputAccessoryView = toolBar
        self.responderTxtFl = textFl
        scrollToBottom(distance: mSearchV.bounds.height)

          if #available(iOS 14.0, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
     } else {
         // Fallback on earlier versions
     }
        if textFl.tag > 1 {
            self.datePicker.datePickerMode = .time
            self.datePicker.minimumDate = nil
        } else {
            self.datePicker.datePickerMode = .date
            self.datePicker.minimumDate =  Date()

            self.datePicker.locale = Locale(identifier: "en")
        }
    }
    
    func didSelectLocation(_ text: String, _ tag: Int) {
        
        
    }
    
    func didSelectCustomLocation(_ btn: UIButton, _ isShowAlert: Bool) {
        isShowAlert ? self.showAlertCustomLocation(checkedBtn: btn) : self.showCustomLocationMap()
    }
    
}

//MARK: UIScrollViewDelegate
//MARK: ----------------------------
extension DetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ( scrollView.contentOffset.y == 0) {
            // move up
            if isScrolled {
                isScrolled = false
                UIView.animate(withDuration: 1.0) { [self] in
                    self.tariffSlideVC.view.frame.origin.y -= 500
                    mTariffCarouselV.alpha = 0.0
                    mSearchV.alpha = 0.0
                    self.tariffSlideVC.view.layoutIfNeeded()
                } completion: { [self]_ in
                    self.mTariffCarouselV.isHidden = true
                    mSearchV.isHidden = true
                    scrollContentHeight = mScrollV.bounds.height + mTariffCarouselV.bounds.height
                }
            }
        } else if (scrollView.contentOffset.y > 0) {
            // move down
            if !isScrolled {
                isScrolled = true
                mTariffCarouselV.isHidden = false
                UIView.animate(withDuration: 1.0) { [self] in
                    self.mTariffCarouselV.alpha = 1
                    self.tariffSlideVC.view.frame.origin.y += 500
                    self.tariffSlideVC.view.layoutIfNeeded()
                }
            }
        }
        
    }
    
}
