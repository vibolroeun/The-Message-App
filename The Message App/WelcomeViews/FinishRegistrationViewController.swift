//
//  FinishRegistrationViewController.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 1/1/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import UIKit
import ProgressHUD
import ImagePicker

class FinishRegistrationViewController: UIViewController, ImagePickerDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var email: String!
    var password: String!
    var avatarImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.isUserInteractionEnabled = true
    }
    
    //MARK: IBActions
    
    @IBAction func avatarImageTap(_ sender: Any) {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        
        present(imagePickerController, animated: true, completion: nil)
        
        dimissKeyboard()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dimissKeyboard()
        ProgressHUD.show("Registering...")
        
        if nameTextField.text != "" && surnameTextField.text != "" && countryTextField.text != "" && cityTextField.text != "" && phoneTextField.text != "" {
            FUser.registerUserWith(email: email, password: password, firstName: nameTextField.text!, lastName: surnameTextField.text!) { (error) in
                
                if error != nil {
                    ProgressHUD.dismiss()
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                self.registerUser()
            }
            
        }else{
            
            ProgressHUD.showError("All Fields are required!")
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        clearTextField()
        dimissKeyboard()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: HelperFunctions
    
    func dimissKeyboard(){
        self.view.endEditing(false)
    }
    
    func clearTextField(){
        nameTextField.text = ""
        surnameTextField.text = ""
        countryTextField.text = ""
        cityTextField.text = ""
        phoneTextField.text = ""
    }
    
    func registerUser(){
        
        let fullName = nameTextField.text! + " " + surnameTextField.text!
        
        var tempDictionary : Dictionary = [
                kFIRSTNAME : nameTextField.text!,
                kLASTNAME : surnameTextField.text!,
                kFULLNAME : fullName,
                kCOUNTRY : countryTextField.text!,
                kCITY : cityTextField.text!,
                kPHONE : phoneTextField.text!] as [String : Any]
        
        if avatarImage == nil {
            
            imageFromInitials(firstName: nameTextField.text!, lastName: surnameTextField.text!) { (avatarInitials) in
                let avatarIMG = avatarInitials.jpegData(compressionQuality: 0.7)
                let avatar = avatarIMG!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                
                tempDictionary[kAVATAR] = avatar
                
                //finishing registration
                self.finishingRegistration(withValues: tempDictionary)
            }
            
        }else{
            
            let avatarData = avatarImage.jpegData(compressionQuality: 0.5)
            let avatar = avatarData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            tempDictionary[kAVATAR] = avatar
            
            //finishing registration
            self.finishingRegistration(withValues: tempDictionary)
        }
    }
    
    func finishingRegistration(withValues: [String : Any]){
        
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error?.localizedDescription)
                    print(error!.localizedDescription)
                }
                return
            }
            ProgressHUD.dismiss()
            // go to app
            self.goToApp()
        }
    }
    
    func goToApp(){
        clearTextField()
        dimissKeyboard()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID : FUser.currentId()])
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
        
    }
    
    //MARK: ImagePickerDelegate
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if images.count > 0 {
            self.avatarImage = images.first!
            self.avatarImageView.image = self.avatarImage.circleMasked
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
