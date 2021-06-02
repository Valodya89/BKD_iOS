//
//  OnlineChatViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 01-06-21.
//

import UIKit
protocol OnlineChatViewControllerDelegate: AnyObject {

}
class OnlineChatViewController: UIViewController, StoryboardInitializable {
    
    //MARK: Outlets
    @IBOutlet weak var mDismissBtn: UIButton!
    @IBOutlet weak var mChatTbV: UITableView!
    //MARK: Variables
    weak var delegate: OnlineChatViewControllerDelegate?
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVuew()
    }
    func setupVuew() {
        let chatVC = ChatViewController()
        self.present(chatVC, animated: true, completion: nil)
       // configureDelegates()
       // mChatTbV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
//    private func configureDelegates(){
//        mChatTbV.delegate = self
//        mChatTbV.dataSource = self
//    }
    //MARK: - Action
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


////MARK: UITableViewDelegate, UITableViewDataSource
//extension OnlineChatViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Jon Smit"
//        cell.accessoryType = .disclosureIndicator
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        // show chat messages
//        let chatVC = ChatViewController()
//        self.present(chatVC, animated: true, completion: nil)
//    }
//
//
//}
