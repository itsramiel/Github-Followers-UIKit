//
//  GFAvatarImageView.swift
//  GhFollowers
//
//  Created by Rami Elwan on 11.03.24.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let placeholderImage = UIImage(resource: .avatarPlaceholder)
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
