//
//  File.swift
//  GentleMan2024
//
//  Created by Hamada Ragab on 13/05/2024.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateLoading(_ loading: Loading?) {
        switch loading {
        case .Start:
            LoadingView.show()
        case .Stop, .none:
            LoadingView.hide()
        }
    }
}
