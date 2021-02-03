//
//  SideNavViewController.swift
//  GroupChat
//
//  Created by Eric Tu on 2/3/21.
//

import UIKit

class GroupListSideNavVC : UIViewController {

    override func viewWillAppear(_ animated: Bool) {

    }
    
    let db : MyDatabase = FirebaseDB()
    @IBAction func pressedDeleteButton(_ sender: Any) {
    }
    
    
    @IBAction func pressedLogOutButton(_ sender: Any) {
        db.signOut()
        dismiss(animated: true, completion: nil)
    }
    
}
