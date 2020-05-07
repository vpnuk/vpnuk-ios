//
//  SignUpViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 19.04.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit

protocol SignUpView {
    func goToMainScreen()
    func showError(withText text: String)
    func showLoading()
    func hideLoading()
}

class SignUpViewController: UIViewController {
    private var vm: SignUpViewModel = SignUpViewModel()
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    
    @IBAction func signUpButtonTouched(_ sender: UIButton) {
        vm.signUp(withData: .init(
            username: usernameLabel.text,
            password: passwordLabel.text,
            firstName: firstNameLabel.text,
            lastName: lastNameLabel.text,
            email: emailLabel.text
        )) { (result) in
            print(result)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.view = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignUpViewController: SignUpView {
    func goToMainScreen() {
        performSegue(withIdentifier: "MainNavigationSegue", sender: self)
    }
    
    func showError(withText text: String) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    
}
