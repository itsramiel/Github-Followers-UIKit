//
//  FollowersListVC.swift
//  GhFollowers
//
//  Created by Rami Elwan on 09.03.24.
//

import UIKit

class FollowersListVC: UIViewController {
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, errorMessage in
            if let errorMessage {
                self.presentGFAlertOnMainThread(title: "Smthn Bad Happened", message: errorMessage, buttonTitle: "Ok")
                return
            }
            
            guard let followers else { return }
            print("Followers count = \(followers.count)")
            print(followers)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
