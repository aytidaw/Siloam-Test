//
//  AuthenticationViewModel.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import Foundation
import UIKit

protocol AuthenticationViewModelDelegate {
    func successLogin()
    func failedLogin(title: String, message: String)
}

enum AuthPage {
    case login
    case signUp
}

class AuthenticationViewModel {
    
    var authPage: AuthPage = .login
    
    var delegate: AuthenticationViewModelDelegate?
    
    func validateLogin(username: String, password: String) {
        if (username.isEmpty == true || password.isEmpty == true) {
            self.delegate?.failedLogin(title: Constants.ConstantText.Alert.rawValue,
                                       message: Constants.ConstantText.MessageInputField.rawValue )
            return
        }
        
        if authPage == .login {
            let loginSuccess = AuthenticationManager.signIn(username: username, password: password)
            
            if loginSuccess {
                self.delegate?.successLogin()
                UserDefaults.standard.set(true, forKey: Constants.ConstantText.isLoggin.rawValue)
            } else {
                self.delegate?.failedLogin(title: Constants.ConstantText.LoginFailed.rawValue, message: Constants.ConstantText.LoginFailedMessage.rawValue)
            }
            
        } else {
            let signupSuccess = AuthenticationManager.signUp(username: username, password: password)
            
            if signupSuccess {
                self.delegate?.successLogin()
            } else {
                self.delegate?.failedLogin(title: Constants.ConstantText.SignUp.rawValue,
                                           message: Constants.ConstantText.SignUpFailedMessage.rawValue)
            }
            
        }
        
    }
}
