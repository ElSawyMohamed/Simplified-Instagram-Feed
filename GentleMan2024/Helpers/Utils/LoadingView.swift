//
//  LoadingView.swift
//  CodeBase
//
//  Created by MohamedSawy on 4/7/24.
//

import UIKit

class LoadingView {

    private static var spinner: UIActivityIndicatorView?

    static func show() {
        DispatchQueue.main.async {
            if spinner == nil {
                guard let windowScene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first(where: { $0.activationState == .foregroundActive }),
                    let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }
                let frame = window.bounds
                let spinner = UIActivityIndicatorView(frame: frame)
                spinner.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                spinner.style = .large
                spinner.color = AppColors.primaryColor
                window.addSubview(spinner)
                spinner.center = window.center

                spinner.startAnimating()
                self.spinner = spinner
            }
        }
    }

    static func hide() {
        DispatchQueue.main.async {
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
            spinner = nil
        }
    }

    static func startObservingOrientationChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    static func stopObservingOrientationChanges() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc static func update() {
        DispatchQueue.main.async {
            hide()
            show()
        }
    }
}
