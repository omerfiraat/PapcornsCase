//
//  CollectionViewHeaderCell.swift
//  PapcornsCase
//
//  Created by Ömer Firat on 17.11.2023.
//

import UIKit
import SnapKit

class CategoryHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "category-header-reuse-identifier"

    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textColor = .white
        titleLabel.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
