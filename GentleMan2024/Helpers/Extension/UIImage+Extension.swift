//
//  UIImage+Extension.swift
//  Glamera Business
//
//  Created by Sterling on 01/3/2021.
//

import UIKit
import ImageIO
import SDWebImage

extension UIImageView {
    func setImageWith(_ linkString: String?, placeholder: String? = "placeHolder") {
        guard let linkString = linkString, !linkString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let url = URL(string: linkString) else {
            DispatchQueue.main.async {
                self.image = UIImage(named: placeholder!)
                self.contentMode = .center
            }
            return
        }
        
        self.sd_setImage(with: url, placeholderImage: UIImage(named: placeholder!)) { _, _, _, _ in
            self.contentMode = .scaleAspectFill
        }
    }

    func setImageWith(url: URL?) {
        guard let url = url else { return  }
        self.sd_setImage(with: url)
    }
}
