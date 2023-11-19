//
//  LikeDislikeView.swift
//  PapcornsCase
//
//  Created by Ömer Firat on 17.11.2023.
//

import UIKit
import SnapKit
import StoreKit

final class LikeDislikeView: UIView {
    private let likeButton = UIButton()
       private let dislikeButton = UIButton()
       private let titleLabel = UILabel()
       private let stackView = UIStackView()

       override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
       }

       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           setupViews()
       }

       private func setupViews() {
           configureTitle()
           configureLikeButton()
           configureDislikeButton()
           configureStackView()
       }

       private func configureStackView() {
           addSubview(stackView)
           stackView.addArrangedSubview(titleLabel)
           stackView.addArrangedSubview(likeButton)
           stackView.addArrangedSubview(dislikeButton)

           stackView.axis = .horizontal
           stackView.distribution = .fill
           stackView.alignment = .center
           stackView.spacing = 10

           stackView.snp.makeConstraints { make in
               make.edges.equalToSuperview().inset(12)
           }
       }
    
    private func configureLikeButton() {
        likeButton.setImage(UIImage(named: "like"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.backgroundColor = .lightGray
        likeButton.layer.cornerRadius = 8
        likeButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
    }
    
    private func configureDislikeButton() {
        dislikeButton.setImage(UIImage(named: "dislike"), for: .normal)
        dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        dislikeButton.backgroundColor = .lightGray
        dislikeButton.layer.cornerRadius = 8
        dislikeButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
    }
    
    private func configureTitle() {
        self.backgroundColor = .gray
        self.layer.cornerRadius = 16
        
        titleLabel.text = "Do you like it?"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        addSubview(titleLabel)
    }
    
    @objc private func likeButtonTapped() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    @objc private func dislikeButtonTapped() {
        ///Bu şekilde direk kaldırabiliriz fakat constraintleri kaydırabilir.
        ///        self.removeFromSuperview()
        ///Hidden yapmak daha sağlıklı geldiği için bunu kullandım.
        self.isHidden = true
    }
}
