//
//  ViewController.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 12/30/18.
//  Copyright © 2018 Vibol Roeun. All rights reserved.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {

    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    //MARK: IBActions
    
    @IBAction func backgroundTap(_ sender: Any) {
        dimissKeyboard()
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        dimissKeyboard()
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            loginUser()
            
        }else{
            ProgressHUD.showError("Email and Password is missing!")
        }
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        dimissKeyboard()
        
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""{
            
            if passwordTextField.text == repeatPasswordTextField.text {
                registerUser()
            }else{
                ProgressHUD.showError("Passwords don't match!")
            }
            
        }else{
            ProgressHUD.showError("All fields are required!")
        }
        
    }
    
    //MARK: HelperFunctions
    func dimissKeyboard(){
        self.view.endEditing(false)
    }
    
    func clearTextField(){
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
    
    func loginUser(){
        ProgressHUD.show("Login....")
        
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            //present the app
            self.goToApp()
        }
    
    }
    
    func registerUser(){
        performSegue(withIdentifier: "welcomeToFinishReg", sender: self)
        clearTextField()
        dimissKeyboard()
    }
    
    //MARK: GoToApp
    func goToApp(){
        ProgressHUD.dismiss()
        clearTextField()
        dimissKeyboard()
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
        
    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "welcomeToFinishReg" {
            let vc = segue.destination as! FinishRegistrationViewController
            vc.email = emailTextField.text!
            vc.password = passwordTextField.text!
        }
        
    }
    
}

