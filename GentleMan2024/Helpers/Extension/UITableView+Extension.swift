//
//  UITableView+Extension.swift
//  Glamera Business
//
//  Created by Sterling on 22/02/2021.
//

import Foundation
import UIKit
import ViewAnimator

extension UITableView {
    
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type){
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    func dequeue<Cell: UITableViewCell>() -> Cell{
        let identifier = String(describing: Cell.self)
        
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in cell")
        }
        
        return cell
    }
    
    func animateViews(viewsArray: [UIView], animate: AnimationType, delay: Double, duration: TimeInterval) {
        for view in viewsArray {
            view.animate(animations: [animate], delay: delay, duration: duration)
        }
    }
}

//https://medium.com/@mtssonmez/handle-empty-tableview-in-swift-4-ios-11-23635d108409
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 150, width: 200, height: 30))
        messageLabel.text = message
        messageLabel.textColor = AppColors.primaryColor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 150, width: 200, height: 30))
        messageLabel.text = message
        messageLabel.textColor = AppColors.primaryColor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
        
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
}

class DynamaicTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
