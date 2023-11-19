//
//  CategoryResponseModel.swift
//  PapcornsCase
//
//  Created by Ömer Firat on 17.11.2023.
//

import Foundation

class CategoryResponseModel {
    var id: Int
    var order: Int
    var title: String
    var type: Int

    init(id: Int, order: Int, title: String, type: Int) {
        self.id = id
        self.order = order
        self.title = title
        self.type = type
    }
}
