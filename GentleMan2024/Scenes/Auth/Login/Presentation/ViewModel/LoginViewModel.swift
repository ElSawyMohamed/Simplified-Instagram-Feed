//
//  LoginViewModel.swift
//  GentleMan2024
//
//  Created by MohamedSawy on 4/18/24.
//

import Foundation

struct LoginViewModelActions {
}

protocol LoginViewModelInput {
}

protocol LoginViewModelOutput {
    var loading: BindableObservable<Loading?> { get }
    var mobileNumber: BindableObservable<String> { get }
    var error: BindableObservable<String> { get }
    var errorTitle: String { get }
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput

final class DefaultLoginViewModel: LoginViewModel {
    
    private let loginUseCase: LoginUseCase
    private let actions: LoginViewModelActions?

    let loading: BindableObservable<Loading?> = BindableObservable(.none)
    let countryCode: BindableObservable<String> = BindableObservable("")
    let mobileNumber: BindableObservable<String> = BindableObservable("")
    let error: BindableObservable<String> = BindableObservable("")
    let errorTitle = NSLocalizedString("Error", comment: "")

    init(
        loginUseCase: LoginUseCase,
        actions: LoginViewModelActions? = nil
    ) {
        self.loginUseCase = loginUseCase
        self.actions = actions
    }
        
    private func login(countryCode: String, mobileNumber: String, loading: Loading) {
        
        self.loading.value = loading
        self.mobileNumber.value = mobileNumber
        self.countryCode.value = countryCode
               
        loginUseCase.execute(requestValue: .init(communicationMethod: 1, countryCode: self.countryCode.value, mobileNumber: self.mobileNumber.value), completion: { [weak self] result in
            guard let self = self else {return}
            self.loading.value = .none
            DispatchQueue.main.async {
                self.loading.value = .none
                switch result {
                case .success(let loginModel): break
//                    self.handleState(state: loginModel.state ?? 0, mobileNumber: mobileNumber)
                case .failure(let error):
                    self.handle(error: error)
                }
            }
        })
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
        "No internet connection" :"Something went wrong!"
    }
}
