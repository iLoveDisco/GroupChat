//
//  GroupsListVC.swift
//  GroupChat
//
//  Created by Eric Tu on 2/3/21.
//

import UIKit
import Foundation

class GroupsListVC : UITableViewController {
    let db : MyDatabase = FirebaseDB()
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showCreateGroupDialogue))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        db.listenForAuthStateChange { (isSignedIn) in
            if isSignedIn {
                print("[LOG] Currently signed in")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        db.closeListeners()
    }
    
    @objc func showCreateGroupDialogue() {
        let alertController = UIAlertController(title: "Create a new group", message: "", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Create Group", style: .default) { (action) in
            let groupNameTF = alertController.textFields![0]
            let groupMembers = alertController.textFields![1].text!.components(separatedBy: ",")
            
            self.db.createGroup(groupName: groupNameTF.text!, groupMembers: groupMembers, groupLeaderEmail: self.db.getUserEmail(), onComplete: {self.tableView.reloadData()})
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Group Name"
        })
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Member emails (comma separated)"
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
