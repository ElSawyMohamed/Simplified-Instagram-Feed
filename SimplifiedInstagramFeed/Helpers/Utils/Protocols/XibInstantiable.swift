//
//  XibInstantiable
//
//  Created by MohamedSawy on 4/21/24.
//

import UIKit

protocol XibInstantiable: NSObjectProtocol {
    associatedtype T
    static var xibName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> T
}

extension XibInstantiable where Self: UIViewController {
    static var xibName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let nib = UINib(nibName: xibName, bundle: bundle)
        guard let vc = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Cannot instantiate view controller \(Self.self) from XIB with name \(xibName)")
        }
        return vc
    }
}
