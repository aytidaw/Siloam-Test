//
//  AuthenticationViewController.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import UIKit
import SkyFloatingLabelTextField

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.cornerRadius = 6.0
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 6.0
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    var authVM = AuthenticationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authVM.delegate = self
        setupView()
    }
    
    func setupView() {
        if authVM.authPage == .signUp {
            titleLabel.text = Constants.ConstantText.SignUp.rawValue
            signUpButton.isHidden = true
            loginButton.setTitle(Constants.ConstantText.SignUp.rawValue, for: .normal)
            loginButton.backgroundColor = .systemOrange
            closeButton.isHidden = false
        }
    }

    @IBAction func loginTapped(_ sender: Any) {
        Helper.defaultBlockLoading()
        authVM.validateLogin(username: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        let vc = AuthenticationViewController.loadFromNib()
        vc.authVM.authPage = .signUp
        self.present(vc, animated: true)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension AuthenticationViewController: AuthenticationViewModelDelegate {
    func successLogin() {
        if authVM.authPage == .signUp {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                Helper.stopLoading()
                self?.dismiss(animated: true)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                Helper.stopLoading()
                let searchVC = SearchViewController.loadFromNib()
                self?.navigationController?.pushViewController(searchVC, animated: true)
            }
        }
    }
    
    func failedLogin(title: String, message: String) {
        Helper.stopLoading()
        showPopupAlert(title: title,
                       message: message,
                       actionTitles: ["OK"],
                       actions:[{action1 in },nil])
    }

}
