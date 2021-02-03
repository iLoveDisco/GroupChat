//
//  LogInPageVC.swift
//  GroupChat
//
//  Created by Eric Tu on 2/2/21.
//

import UIKit

class LogInPageVC : UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let db = FirebaseDB()
    let showGroupsListID = "GroupsListID"
    
    @IBAction func pressedLoginButton(_ sender: Any) {
        db.signInWithEmail(email: emailTextField.text!, pw: passwordTextField.text!) {
            self.dismiss(animated: true) {
                print(self.presentingViewController)
                self.presentingViewController?.performSegue(withIdentifier: self.showGroupsListID, sender: nil)
            }
        }
    }
    @IBAction func pressedCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
