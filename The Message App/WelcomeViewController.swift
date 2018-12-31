//
//  ViewController.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 12/30/18.
//  Copyright © 2018 Vibol Roeun. All rights reserved.
//

import UIKit

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
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        dimissKeyboard()
        
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
    
    
    
    
    
}

