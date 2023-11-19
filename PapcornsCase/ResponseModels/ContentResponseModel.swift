//
//  ContentResponseModel.swift
//  PapcornsCase
//
//  Created by Ömer Firat on 17.11.2023.
//

import Foundation

final class ContentResponseModel: Codable, Equatable {
    
    var categoryId: Int
    
    static func ==(lhs: ContentResponseModel, rhs: ContentResponseModel) -> Bool {
        return lhs.categoryId == rhs.categoryId && lhs.contentId == rhs.contentId
    }
    
    var contentId: Int
    var contentName: String
    var imageUrl: String

    init(categoryId: Int, contentId: Int, contentName: String, imageUrl: String) {
        self.categoryId = categoryId
        self.contentId = contentId
        self.contentName = contentName
        self.imageUrl = imageUrl
    }
}
