//
//  SplashVC.swift
//
//  Created by MohamedSawy on 4/28/24.
//

import UIKit
import SDWebImage

class SplashVC: UIViewController {
    
    @IBOutlet weak var splashImg: UIImageView!
    
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.66) { [weak self] in
            guard let self = self else { return }
            self.navigateToMainVC()
        }
    }
    
    func navigateToMainVC() {
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController!,
            appDIContainer: appDIContainer
        )
        appFlowCoordinator?.startMain()
    }
}
