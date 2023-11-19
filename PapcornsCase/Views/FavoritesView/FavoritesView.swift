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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .black
        setupPageTitle()
        setupCollectionView()
        loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
        collectionView.reloadData()
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
