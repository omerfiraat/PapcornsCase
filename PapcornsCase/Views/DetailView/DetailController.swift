//
//  DetailController.swift
//  PapcornsCase
//
//  Created by Ömer Firat on 17.11.2023.
//

import UIKit
import SnapKit

final class DetailController: UIViewController {
    var content: ContentResponseModel?
    private lazy var imageView = UIImageView()
    private lazy var name = UILabel()
    private lazy var shareButton = UIButton()
    private lazy var downloadButton = UIButton()
    private lazy var likeDislikeView = LikeDislikeView()

    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = .black
        super.viewDidLoad()
        setupUI()
        customizeNavigationBar()
        updateHeartButtonIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHeartButtonIcon()
    }
    
    private func setupUI() {
        configureImageView()
        configureName()
        configureLikeDislikeView()
        configureShareButton()
        configureDownloadButton()
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        imageView.load(from: content?.imageUrl)
        imageView.contentMode = .scaleToFill
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(2.5)
        }
    }
    
    private func configureName() {
        view.addSubview(name)
        name.text = content?.contentName
        name.font = .boldSystemFont(ofSize: 34)
        name.textColor = .white
        name.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.leading.equalTo(16)
        }
    }
    
    private func configureLikeDislikeView() {
        view.addSubview(likeDislikeView)
        likeDislikeView.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(24)
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.height.equalTo(87)
        }
    }
    
    private func configureShareButton() {
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        shareButton.setTitle("Share", for: .normal)
        shareButton.backgroundColor = .white
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.layer.cornerRadius = 8
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(likeDislikeView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
    }
    
    private func configureDownloadButton() {
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(.black, for: .normal)
        downloadButton.backgroundColor = .white
        downloadButton.layer.cornerRadius = 8
        view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(shareButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
    }
    
    @objc private func shareButtonTapped() {
        guard let contentName = content?.contentName else { return }
    
        let items: [Any] = [contentName]
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }

    @objc private func downloadButtonTapped() {
        guard let image = imageView.image else { return }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully")
        }
    }
    
    private func customizeNavigationBar() {
        navigationController?.navigationBar.tintColor = .white

        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem

        let heartIcon = UIImage(systemName: "heart")
        let heartButton = UIBarButtonItem(image: heartIcon, style: .plain, target: self, action: #selector(heartButtonTapped))
        navigationItem.rightBarButtonItem = heartButton
        updateHeartButtonIcon()
    }
    
    private func updateHeartButtonIcon() {
        guard let content = content else { return }

        let isFavorite = isContentFavorited(content)
        let heartIcon = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        let heartButton = UIBarButtonItem(image: heartIcon, style: .plain, target: self, action: #selector(heartButtonTapped))
        navigationItem.rightBarButtonItem = heartButton
    }

    private func isContentFavorited(_ content: ContentResponseModel) -> Bool {
        guard let data = UserDefaults.standard.data(forKey: "favorites"),
              let favorites = try? JSONDecoder().decode([ContentResponseModel].self, from: data) else {
            return false
        }
        return favorites.contains(where: { $0.categoryId == content.categoryId && $0.contentId == content.contentId })
    }

    @objc private func heartButtonTapped() {
        guard let content = content else { return }

        var favorites = [ContentResponseModel]()
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let savedFavorites = try? JSONDecoder().decode([ContentResponseModel].self, from: data) {
            favorites = savedFavorites
        }

        if isContentFavorited(content) {
            favorites.removeAll(where: { $0.contentId == content.contentId })
        } else {
            favorites.append(content)
        }

        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: "favorites")
        }

        updateHeartButtonIcon()
    }
}
