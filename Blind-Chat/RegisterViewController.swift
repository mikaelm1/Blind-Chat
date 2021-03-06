//
//  ViewController.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/6/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import ChameleonFramework 

class RegisterViewController: UIViewController {
    
    let passwordField: CustomTextField = {
        let t = CustomTextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = FlatWhite()
        t.placeholder = "Enter password"
        t.isSecureTextEntry = true
        return t
    }()
    
    let usernameField: CustomTextField = {
        let t = CustomTextField()
        //t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = FlatWhite()
        t.placeholder = "Enter username"
        t.autocapitalizationType = .none
        t.autocorrectionType = .no
        return t
    }()
    
    let emailField: CustomTextField = {
        let t = CustomTextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = FlatWhite()
        t.placeholder = "Enter email"
        t.autocapitalizationType = .none
        t.autocorrectionType = .no
        return t
    }()
    
    lazy var registerButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = FlatMint()
        b.setTitle("Register", for: [])
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.addTarget(self, action: #selector(loginButtonTapped(sender:)), for: .touchUpInside)
        b.setTitleColor(FlatWhite(), for: [])
        return b
    }()
    
    lazy var loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .clear
        b.setTitle("Login", for: [])
        b.addTarget(self, action: #selector(switchLoginForm(sender:)), for: .touchUpInside)
        b.setTitleColor(FlatWhite(), for: [])
        return b
    }()
    
    let fieldContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = FlatWhite()
        v.layer.masksToBounds = true
        return v
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 1
        sv.axis = .vertical
        return sv
    }()
    
    let chatManager = ChatAPIManager.shared
    let apiManager = APIManager.shared
    var registering = true
    var stackViewHeight: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = FlatBlue()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViews() {
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(usernameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        stackViewHeight = stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.21)
        stackViewHeight?.isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        view.addSubview(registerButton)
        registerButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 8).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    // MARK: - Actions
    
    func switchLoginForm(sender: UIButton) {

        UIView.animate(withDuration: 0.15) {
            self.stackViewHeight?.isActive = false
            self.stackViewHeight = self.stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: self.registering ? 0.14 : 0.21)
            self.stackViewHeight?.isActive = true
            
            self.emailField.isHidden = self.registering ? true : false
            
            self.view.layoutIfNeeded()
        }
        
        if registering {
            registerButton.setTitle("Login", for: [])
            loginButton.setTitle("Register", for: [])
        } else {
            registerButton.setTitle("Register", for: [])
            loginButton.setTitle("Login", for: [])
        }
        
        registering = !registering
    }
    
    func loginButtonTapped(sender: UIButton) {
        if registering {
            let user = User(username: usernameField.text!, email: emailField.text!)
            let pwd = passwordField.text!
            registerUser(user: user, password: pwd)
        } else {
            loginUser()
        }

    }
    
    // MARK: - API Calls 
    
    func registerUser(user: User, password: String) {
        apiManager.registerUser(user: user, withPassword: password) { (error) in
            if let err = error {
                print("Error registering: \(err)")
            } else {
                print("Registered user: \(user.username)")
                self.gotoRoomsVC()
            }
        }
    }
    
    func loginUser() {
        let username = usernameField.text!
        let pwd = passwordField.text!
        apiManager.loginUser(username: username, password: pwd) { (error) in
            if let error = error {
                print("Error logging in: \(error)")
            } else {
                self.gotoRoomsVC()
            }
        }
    }
    
    // MARK: - Helpers
    
    func gotoRoomsVC() {
        DispatchQueue.main.async {
            let vc = ChatRoomsController()
            vc.user = self.getUser()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func getUser() -> String {
        // TODO: - This will be a User model with error handling
        return usernameField.text!
    }

}

