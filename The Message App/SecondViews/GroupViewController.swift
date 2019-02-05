//
//  GroupViewController.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 2/5/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import UIKit
import ProgressHUD

class GroupViewController: UIViewController {

    @IBOutlet weak var cameraButtonOutlet: UIImageView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet var iconTapGesture: UITapGestureRecognizer!
    
    var group: NSDictionary!
    var groupIcon: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButtonOutlet.isUserInteractionEnabled = true
        cameraButtonOutlet.addGestureRecognizer(iconTapGesture)
        
        setupUI()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Invite Users", style: .plain, target: self, action: #selector(self.inviteUsers))]
    }
    
    //MARK: IBActions
    
    @IBAction func cameraIconTapped(_ sender: Any) {
        
        showIconOptions()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        showIconOptions()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func inviteUsers() {
        
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inviteUsersTableView") as! InviteUsersTableViewController
        
        userVC.group = group
        self.navigationController?.pushViewController(userVC, animated: true)
        
    }
    
    //MARK: Helpers
    
    func setupUI(){
        
        self.title = "Group"
        groupNameTextField.text = group[kNAME] as? String
        
        imageFromData(pictureData: group[kAVATAR] as! String) { (avatarImage) in
            
            if avatarImage != nil {
                self.cameraButtonOutlet.image = avatarImage!
            }
        }
        
    }
    
    func showIconOptions() {
    
        let optionMenu = UIAlertController(title: "Choose group Icon", message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take/Choose Photo", style: .default) { (alert) in
            print("camera")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
        
        }
        
        if groupIcon != nil {
            let resetAction = UIAlertAction(title: "Reset", style: .default) { (alert) in

            self.groupIcon = nil
            self.cameraButtonOutlet.image = UIImage(named: "cameraIcon")
            self.editButtonOutlet.isHidden = true
            }
            optionMenu.addAction(resetAction)
        }
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(cancelAction)
        
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
        
            if let currentPopoverpresentioncontroller = optionMenu.popoverPresentationController {
            currentPopoverpresentioncontroller.sourceView = editButtonOutlet
            currentPopoverpresentioncontroller.sourceRect = editButtonOutlet.bounds
        
            currentPopoverpresentioncontroller.permittedArrowDirections = .up
            self.present(optionMenu, animated: true, completion: nil)
            }
        } else {
            self.present(optionMenu, animated: true, completion: nil)
        }
    
    
    }

    
    
}
