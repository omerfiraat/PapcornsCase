//
//  ImageLoadable.swift
//  PapcornsCase
//
//  Created by Ömer Firat on 17.11.2023.
//

import UIKit
import Kingfisher

/// Base protocol for URL and UIImage for image view setup.
protocol ImageLoadable { }

extension URL: ImageLoadable { }
extension String: ImageLoadable { }
extension UIImage: ImageLoadable { }

extension UIImageView {
    /// Depending on loadable type, either fetches image from remote or uses local resource.
    /// - Parameter loadable: Base lodable protocol for URL and UIImage.
    func load(from loadable: ImageLoadable?) {
        guard let loadable else { return }
        
        if let image = loadable as? UIImage {
            self.image = image
        } else if let url = loadable as? URL {
            self.kf.setImage(with: url)
        } else if let urlString = loadable as? String {
            self.kf.setImage(with: URL(string: urlString))
        }
    }
}
