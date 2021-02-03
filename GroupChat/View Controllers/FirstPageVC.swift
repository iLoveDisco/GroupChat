//
//  FirstPageVC.swift
//  GroupChat
//
//  Created by Eric Tu on 2/2/21.
//

import UIKit

class FirstPageVC : UIViewController {
    // Database Singleton
    let db = FirebaseDB()
    
    // Segue ID's
    let groupsListID = "GroupsListID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if db.isUserSignedIn() {
            print("User is already signed in as \(db.getUserEmail())")
            self.performSegue(withIdentifier: self.groupsListID, sender: self)
            return
        }
        
        db.listenForAuthStateChange { (isSignedIn) in
            if isSignedIn {
                self.performSegue(withIdentifier: self.groupsListID, sender: self)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        db.closeListeners()
    }
    
}
