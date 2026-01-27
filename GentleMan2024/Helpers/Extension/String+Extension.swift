//
//  String+Extension.swift
//  Glamera Business
//
//  Created by Abdelhamid Naeem on 10/02/2021.
//

import UIKit

extension String {
    func getEncodedFileURL() -> String? {
        // Encode the URL string
        if let encodedURLString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            // Check if it’s meant to be a local file URL
            let fullURLString = "file://\(encodedURLString)" // Use file:// for local files
            return fullURLString
        }
        return nil
    }
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
