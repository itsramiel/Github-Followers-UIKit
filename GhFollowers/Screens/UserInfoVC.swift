//
//  UserInfoVC.swift
//  GhFollowers
//
//  Created by Rami Elwan on 15.03.24.
//

import UIKit

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var username: String!
    
    var user: User? {
        didSet {
            guard let user else { return }
            DispatchQueue.main.async {
                self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                self.add(childVC: GFRepoItemVC(user: user), to: self.itemViewOne)
                self.add(childVC: GFFollowerItemVC(user: user), to: self.itemViewTwo)
                self.displayDateLabel(user: user)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    func getUserInfo(){
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let networkUser):
                user = networkUser
            case .failure(let error):
                break
            }
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func displayDateLabel(user: User) {
        guard let createdAt = user.createdAt.UTCStringToDate() else { return }
        let formattedDate = createdAt.convertToMonthYearFormat()
        self.dateLabel.text = "Github since \(formattedDate)"
    }
    
    func layoutUI() {
        let subviews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        let padding: CGFloat = 20
        let gap: CGFloat = 20
        
        for subview in subviews {
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: gap),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: gap),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: gap),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
