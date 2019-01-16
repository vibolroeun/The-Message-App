//
//  BlockViewController.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 1/15/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import UIKit
import ProgressHUD

class BlockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UsersTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    var blockUsersArray : [FUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        loadUsers()
    }
    
    //MARK: TableVeiwData Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        notificationLabel.isHidden = blockUsersArray.count != 0
        
        return blockUsersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UsersTableViewCell
        
        cell.delegate = self
        
        cell.generateCellWith(fUser: blockUsersArray[indexPath.row], indexPath: indexPath)
        
        return cell
        
    }
    
    //MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "Unblock"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        var tempBlockedUsers = FUser.currentUser()!.blockedUsers
        let userIdToUnblock = blockUsersArray[indexPath.row].objectId
        tempBlockedUsers.remove(at: tempBlockedUsers.index(of: userIdToUnblock)!)
        
        blockUsersArray.remove(at: indexPath.row)
        
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID : tempBlockedUsers]) { (error) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
            }
            self.tableView.reloadData()
        }
    }
    
    //MARK: LoadBlocked Users
    
    func loadUsers() {
        
        if FUser.currentUser()!.blockedUsers.count > 0 {
            ProgressHUD.show()
            
            getUsersFromFirestore(withIds: FUser.currentUser()!.blockedUsers) { (allBlockUsers) in
                ProgressHUD.dismiss()
                
                self.blockUsersArray = allBlockUsers
                self.tableView.reloadData()
            }
        }
        
    }
    
    //MARK: UserTableviewCellDelegate
    
    func didTapAvatarImage(indexPath: IndexPath) {
        
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as! ProfileViewTableViewController
        
        profileVC.user = blockUsersArray[indexPath.row]
        
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
   

}
