//
//  LoginVC.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/21/24.
//

import UIKit

class LoginVC: BaseViewController, Alertable, UITextFieldDelegate {

    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
    
    private var viewModel: LoginViewModel!
    
    static func create(
        with viewModel: LoginViewModel
    ) -> LoginVC {
        let view: LoginVC = LoginVC.loadFromNib()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        phoneNumberTxt.delegate = self
        phoneNumberTxt.keyboardType = .numberPad

    }

    private func bind(to viewModel: LoginViewModel) {
        viewModel.loading.observe { [weak self] in self?.updateLoading($0) }
        viewModel.mobileNumber.observe{ [weak self] in self?.updatePhoneNumber($0) }
    }

    @IBAction func continueBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func continueGuestBtn(_ sender: UIButton) {
        UserDefaultsManager.shared.asAGuestFlag = true
    }
    
    @IBAction func changeLangBtn(_ sender: UIButton) {
    }
    
    private func updatePhoneNumber(_ phoneNumber: String) {
        phoneNumberTxt.text = phoneNumber
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ensure the new string contains only numeric characters
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }

        // Ensure the length is not more than 10
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        return newLength <= 10
    }
}
