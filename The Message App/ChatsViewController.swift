//
//  ChatsViewController.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 1/2/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       navigationController?.navigationBar.prefersLargeTitles = true
    }

    //MARK: IBActions
    
    @IBAction func createNewChatButtonPressed(_ sender: Any) {
        
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersTableView") as! UsersTableViewController
        
        self.navigationController?.pushViewController(userVC, animated: true)
        
    }
    
}
