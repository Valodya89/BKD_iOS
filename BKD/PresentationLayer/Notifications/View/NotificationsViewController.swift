//
//  NotificationsViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import SideMenu


class NotificationsViewController: BaseViewController {

    //MARK: -- Outlets
    @IBOutlet weak var mSelectBtn: UIButton!
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mSelectAllBtn: UIButton!
    @IBOutlet weak var mDeleteBtn: UIButton!
    @IBOutlet weak var mNotificationTbV: UITableView!
    @IBOutlet weak var mMenuBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var mTableBottom: NSLayoutConstraint!
    
    var menu: SideMenuNavigationController?
    lazy var notificationsViewModel = NotificationsViewModel()
    var  notifications: [NotificationModel]? //=  NotificationData.notificationModel
    var selected: Bool = false

    //MARK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        configureUI()
        setUpView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mDeleteBtn.setGradientWithCornerRadius(cornerRadius: 8.0, startColor: color_gradient_register_start!, endColor: color_gradient_register_end!)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mDeleteBtn.setGradientWithCornerRadius(cornerRadius: 8.0, startColor: color_gradient_register_start!, endColor: color_gradient_register_end!)
    }
    
    private func setUpView() {
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationsViewController.handleMenuToggle), name: Constant.Notifications.dismissMenu, object: nil)
       
    }
    
//    ///Set menu
//    func setmenu(menu: SideMenuNavigationController?) {
//        menu?.leftSide = true
//        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
//        SideMenuManager.default.leftMenuNavigationController = menu
//        menu?.setNavigationBarHidden(true, animated: true)
//        menu?.menuWidth = 310
//        menu?.presentDuration = 0.8
//        // menu
//        self.menu = SideMenuNavigationController(rootViewController: LeftViewController())
//        self.setmenu(menu: menu)
//    }
    
    ///Configure UI
    func configureUI() {
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mRightBarBtn.image = img_bkd
        mNotificationTbV.register(NavigationTableCell.nib(), forCellReuseIdentifier: NavigationTableCell.identifier)
        mSelectBtn.layer.cornerRadius = mSelectBtn.frame.height/2
        mSelectBtn.setBorder(color: color_navigationBar!, width: 2)
        mCancelBtn.layer.cornerRadius = mSelectBtn.frame.height/2
        mCancelBtn.setBorder(color: color_navigationBar!, width: 2)
        mSelectBtn.isHidden = (notifications?.count == 0 || notifications == nil)
        
    }
    
    ///Set back hover color
    func unselectButton(_ btn: UIButton) {
        btn.backgroundColor = .clear
        btn.titleLabel?.textColor = color_navigationBar!
    }
    
    ///Check is all notifications was deleted
    func checkIsDeleteAll() {
        if notifications?.count == 0 {
            mSelectBtn.isHidden = true
            mDeleteBtn.isHidden = true
            mCancelBtn.isHidden = true
            mSelectAllBtn.isHidden = true

        }
    }
    
    ///Hidde or show delete button with animation
    func animateDeleteBtn(isHidde: Bool) {
        self.loadViewIfNeeded()

        UIView.animate(withDuration: 0.7) { [self] in
            self.mDeleteBtn.alpha = isHidde ? 0.0 : 1.0
            self.mTableBottom.constant = isHidde ? 0 : 100
            if !isHidde {
                self.mDeleteBtn.isHidden = isHidde
            }
        } completion: {_ in
            if isHidde {
                self.mDeleteBtn.isHidden = isHidde
            }
        }
    }
    
    ///Show alert to delete notification
    func showAlert(indexPath: IndexPath) {
        BKDAlert().showAlert(on: self, message: Constant.Texts.deleteNotif, cancelTitle: Constant.Texts.cancel, okTitle: Constant.Texts.delete) {
        } okAction: {
            self.notifications?.remove(at: indexPath.row)
            self.mNotificationTbV.deleteRows(at: [indexPath], with: .fade)
            self.checkIsDeleteAll()
        }
    }

//MARK: -- Actions
    @IBAction func menu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true, completion: nil)

    }
    
    @IBAction func selectNotif(_ sender: UIButton) {
        sender.setClickTitleColor(color_menu!)
        sender.backgroundColor = color_navigationBar!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
            self.animateDeleteBtn(isHidde: false)
            self.mCancelBtn.isHidden = false
            self.mSelectAllBtn.isHidden = false
            sender.isHidden = true
            self.unselectButton(sender)
            self.selected = true
            self.mNotificationTbV.reloadData()

         }
    }
   
    @IBAction func cancel(_ sender: UIButton) {
        sender.setClickTitleColor(color_menu!)
        sender.backgroundColor = color_navigationBar!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
            self.animateDeleteBtn(isHidde: true)
            self.mSelectBtn.isHidden = false
            self.mSelectAllBtn.isHidden = true
            sender.isHidden = true
            self.loadViewIfNeeded()
            self.unselectButton(sender)
            self.selected = false
            self.notifications = self.notificationsViewModel.unselectAllNotifications(notifications: self.notifications)
            self.mNotificationTbV.reloadData()
         }
    }
    
    @IBAction func selectAllNotification(_ sender: UIButton) {
        notifications = notificationsViewModel.selectAllNotifications(notifications: notifications)
        mNotificationTbV.reloadData()
    }
    
    @IBAction func deleteNotification(_ sender: UIButton) {
        notifications = notificationsViewModel.deleteNotifications(notifications: notifications)
        mNotificationTbV.reloadData()
        self.checkIsDeleteAll()

    }
    
    ///Dismiss left menu and open chant screen
    @objc private func handleMenuToggle(notification: Notification) {
        menu?.dismiss(animated: true, completion: nil)
        openChatPage(viewCont: self)
    }
}

//MARK: -- UITableViewDelegate, UITableViewDataSource
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationTableCell.identifier, for: indexPath) as! NavigationTableCell
        
        let item = notifications![indexPath.row]
        cell.pressSelected = selected
        cell.setCellInfo(item: item, index: indexPath.row)
        cell.notificationSelected = { index in
            self.notifications![index].isSelect = !((self.notifications![index].isSelect))
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showAlert(indexPath: indexPath)
        }
    }
    
}
