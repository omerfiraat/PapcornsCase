//
//  ViewModel.swift
//  PapcornsCase
//
//  Created by Ömer Firat on 17.11.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

final class ViewModel {
    
    private lazy var database = Firestore.firestore()
    lazy var categories = [CategoryResponseModel]()
    lazy var contents = [ContentResponseModel]()
    
    func sortData() {
        categories.sort { $0.order < $1.order }
    }

    func fetchCategoryData() async throws {
        let querySnapshot = try await database.collection("category").getDocuments()
        self.categories = querySnapshot.documents.compactMap { document in
            let data = document.data()
            return CategoryResponseModel(id: data["id"] as? Int ?? 0,
                                         order: data["order"] as? Int ?? 0,
                                         title: data["title"] as? String ?? "",
                                         type: data["type"] as? Int ?? 0)
        }
        sortData()
    }
    
    func fetchContentData() async throws {
        let querySnapshot = try await database.collection("content").getDocuments()
        self.contents = querySnapshot.documents.compactMap { document in
            let data = document.data()
            return ContentResponseModel(categoryId: data["categoryId"] as? Int ?? 0,
                                        contentId: data["contentId"] as? Int ?? 0,
                                        contentName: data["contentName"] as? String ?? "",
                                        imageUrl: data["imageUrl"] as? String ?? "")
        }
    }
    
    func signInAnonymously() async throws -> Bool {
        do {
            try await Auth.auth().signInAnonymously()
            return true
        } catch {
            throw error
        }
    }
}
