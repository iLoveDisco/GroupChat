//
//  SignUpPageVC.swift
//  GroupChat
//
//  Created by Eric Tu on 2/2/21.
//

import UIKit

class SignUpPageVC : UIViewController {
    let db : MyDatabase = FirebaseDB()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    let showGroupsListID = "GroupsListID"
    
    @IBAction func pressedRegisterButton(_ sender: Any) {
        db.signUpWithEmail(
            email: emailTextField.text!,
            firstName: firstNameTextField.text!,
            lastName: lastNameTextField.text!,
            pw: passwordTextField.text!) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
