//
//  FavoritesView.swift
//  PapcornsCase
//
//  Created by Ömer Firat on 19.11.2023.
//

import UIKit
import SnapKit

final class FavoritesViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var favorites: [ContentResponseModel] = []
    private lazy var pageTitle = UILabel()
    private lazy var noFavoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "No Favorites"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.isHidden = true
        return label
    }()
    
    private lazy var noFavoritesLabel2: UILabel = {
        let label = UILabel()
        label.text = "Empty. But so full of possibilities."
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.isHidden = true
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .black
        setupPageTitle()
        setupCollectionView()
        loadFavorites()
        configureNoFavorite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
        collectionView.reloadData()
        noFavoritesLabel.isHidden = !favorites.isEmpty
        noFavoritesLabel2.isHidden = !favorites.isEmpty
    }
    
    private func configureNoFavorite() {
        view.addSubview(noFavoritesLabel)
        noFavoritesLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        view.addSubview(noFavoritesLabel2)
        noFavoritesLabel2.snp.makeConstraints { make in
            make.top.equalTo(noFavoritesLabel.snp.bottom).offset(4)
            make.centerX.equalTo(noFavoritesLabel.snp.centerX)
        }
    }
    
    private func setupPageTitle() {
        view.addSubview(pageTitle)
        pageTitle.backgroundColor = .clear
        pageTitle.text = "Favorites"
        pageTitle.textColor = .white
        pageTitle.font = .boldSystemFont(ofSize: 34)
        pageTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(16)
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width / 2) - 24, height: 380)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        let sideInset: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.isUserInteractionEnabled = true
 
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(pageTitle.snp.bottom).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let savedFavorites = try? JSONDecoder().decode([ContentResponseModel].self, from: data) {
            favorites = savedFavorites
            collectionView.reloadData()
        }
        noFavoritesLabel.isHidden = !favorites.isEmpty
        noFavoritesLabel2.isHidden = !favorites.isEmpty
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            fatalError("Unable to dequeue CollectionViewCell")
        }
        
        cell.imageView.load(from: favorites[indexPath.row].imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = favorites[indexPath.row]
        let detailController = DetailController()
        detailController.content = content

        navigationController?.pushViewController(detailController, animated: false)
    }
}
