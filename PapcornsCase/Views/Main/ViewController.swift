//
//  ViewController.swift
//  PapcornsCase
//
//  Created by Ömer Firat on 14.11.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SnapKit

final class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private lazy var viewModel = ViewModel()
    private lazy var collectionView = UICollectionView()
    private lazy var pageTitle = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupPageTitle()
        setupCollectionView()
        fetchData()
    }
    
    private func fetchData() {
        Task {
            do {
                try await viewModel.signInAnonymously()
                try await viewModel.fetchCategoryData()
                try await viewModel.fetchContentData()
                viewModel.sortData()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Veri çekme hatası: \(error)")
            }
        }
    }
    
    private func setupPageTitle() {
        view.addSubview(pageTitle)
        pageTitle.backgroundColor = .clear
        pageTitle.text = "Discover"
        pageTitle.textColor = .white
        pageTitle.font = .boldSystemFont(ofSize: 34)
        pageTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(16)
        }
    }
    
    private func setupCollectionView() {
        configureCollectionView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(pageTitle.snp.bottom).offset(32)
            make.leading.trailing.equalTo(view).inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.isUserInteractionEnabled = true

        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.reuseIdentifier)
    }

    
    // MARK: - Collection View Layout Configuration

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }

            let itemSize = sectionIndex == 0
                ? NSCollectionLayoutSize(widthDimension: .absolute(166.5), heightDimension: .absolute(296))
                : NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(200))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)

            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(itemSize.widthDimension.dimension * 2 + 4), heightDimension: itemSize.heightDimension)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(4)

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .zero

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]

            return section
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categoryId = viewModel.categories[section].id
        return viewModel.contents.filter { $0.categoryId == categoryId }.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            fatalError("Unable to dequeue CollectionViewCell")
        }
        
        let categoryId = viewModel.categories[indexPath.section].id
        let contentsForThisCategory = viewModel.contents.filter { $0.categoryId == categoryId }
        let content = contentsForThisCategory[indexPath.row]
        
        cell.imageView.load(from: content.imageUrl)

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.categories.count
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryId = viewModel.categories[indexPath.section].id
        let contentsForThisCategory = viewModel.contents.filter { $0.categoryId == categoryId }
        let content = contentsForThisCategory[indexPath.row]

        let detailController = DetailController()
        detailController.content = content

        navigationController?.pushViewController(detailController, animated: false)

    }
    
    // MARK: - Supplementary View Configuration
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                withReuseIdentifier: CategoryHeaderView.reuseIdentifier,
                                                                                for: indexPath) as? CategoryHeaderView else {
            fatalError("Invalid view type")
        }

        let category = viewModel.categories[indexPath.section]
        headerView.titleLabel.text = category.title
        return headerView
    }
}

