//
//  NewGroupViewController.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 2/3/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import UIKit
import ProgressHUD

class NewGroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GroupMemberCollectionViewCellDelegate {

    
    @IBOutlet weak var editAvatarButtonOutlet: UIButton!
    @IBOutlet weak var groupIconImageView: UIImageView!
    @IBOutlet weak var groupSubjectTextField: UITextField!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var iconTapGesture: UITapGestureRecognizer!
    
    var memberIds: [String] = []
    var allMembers: [FUser] = []
    var groupIcon: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        groupIconImageView.isUserInteractionEnabled = true
        groupIconImageView.addGestureRecognizer(iconTapGesture)
        
        updateParticipantsLabel()
    }
    
    //MARK: CollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GroupMemberCollectionViewCell
        
        cell.delegate = self
        cell.generateCell(user: allMembers[indexPath.row], indexPath: indexPath)
        
        return cell
    }
    
    //MARK: IBActions
    
    @objc func createButtonPressed(_ sender: Any) {
        
        if groupSubjectTextField.text != "" {
            
            memberIds.append(FUser.currentId())
            let avatarData = UIImage(named: "groupIcon")!.jpegData(compressionQuality: 0.7)!
            var avatar = avatarData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            if groupIcon != nil {
                let avatarData = groupIcon!.jpegData(compressionQuality: 0.7)!
                avatar = avatarData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            }
            let groupId = UUID().uuidString
            
            //create Group
            let group = Group(groupId: groupId, subject: groupSubjectTextField.text!, ownerId: FUser.currentId(), members: memberIds, avatar: avatar)
            
            group.saveGroup()
            
            startGroupChat(group: group)
            
            // create group recent
            let chatVC = ChatViewController()
            chatVC.titleName = group.groupDictionary[kNAME] as? String
            chatVC.memberIds = group.groupDictionary[kMEMBERS] as? [String]
            chatVC.membersToPush = group.groupDictionary[kMEMBERS] as? [String]
            
            chatVC.chatRoomId = groupId
            chatVC.isGroup = true
            chatVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatVC, animated: true)
            
            
            
        } else {
            ProgressHUD.showError("Subject is required!")
        }
        
    }
    
    @IBAction func groupIconPressed(_ sender: Any) {
        showIconOptions()
    }
    
    @IBAction func editIconButtonPressed(_ sender: Any) {
        showIconOptions()
    }
    
    //MARK: GroupMemberCollectionViewDelegate
    
    func didClickDeleteButton(indexPath: IndexPath) {
        
        allMembers.remove(at: indexPath.row)
        memberIds.remove(at: indexPath.row)
        
        collectionView.reloadData()
    }

    // MARK: HelperFunctions
    
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
                self.groupIconImageView.image = UIImage(named: "cameraIcon")
                self.editAvatarButtonOutlet.isHidden = true
            }
            optionMenu.addAction(resetAction)
        }
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(cancelAction)
        
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            
            if let currentPopoverpresentioncontroller = optionMenu.popoverPresentationController {
                currentPopoverpresentioncontroller.sourceView = editAvatarButtonOutlet
                currentPopoverpresentioncontroller.sourceRect = editAvatarButtonOutlet.bounds
                
                currentPopoverpresentioncontroller.permittedArrowDirections = .up
                self.present(optionMenu, animated: true, completion: nil)
            }
        } else {
            self.present(optionMenu, animated: true, completion: nil)
        }
        
        
    }
    
    func updateParticipantsLabel() {
        
        participantsLabel.text = "PARTICIPANTS: \(allMembers.count)"
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(self.createButtonPressed))]
        
        self.navigationItem.rightBarButtonItem?.isEnabled = allMembers.count > 0
    }

}
