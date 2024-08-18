//
//  UserInfoVC.swift
//  GhFollowers
//
//  Created by Rami Elwan on 15.03.24.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didTapGithubProfile()
    func didTapFollowers()
}

class UserInfoVC: GFDataLoadingVC {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var username: String!
    weak var followersListDelegate: FollowerListVCDelegate?
    
    var user: User? {
        didSet {
            configureUIElement()
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
            case .failure(_):
                break
            }
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureUIElement() {
        guard let user else { return }
        DispatchQueue.main.async {
            self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
            
            let repoItemVC = GFRepoItemVC(user: user)
            repoItemVC.delegate = self
            self.add(childVC: repoItemVC, to: self.itemViewOne)
            
            let followerItemVC = GFFollowerItemVC(user: user)
            followerItemVC.delegate = self
            self.add(childVC: followerItemVC, to: self.itemViewTwo)
            
            self.displayDateLabel(user: user)
        }
    }
    
    private func displayDateLabel(user: User) {
        let formattedDate = user.createdAt.convertToMonthYearFormat()
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

extension UserInfoVC: UserInfoVCDelegate {
    func didTapGithubProfile() {
        guard let user else { return }
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapFollowers() {
        guard let user else { return }
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No Followers", message: "This user has no followers to display :(", buttonTitle: "Ouch")
            return
        }
        dismissVC()
        followersListDelegate?.didRequestFollowers(for: user.login)
    }
}
