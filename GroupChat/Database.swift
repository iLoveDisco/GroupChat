//
//  Database.swift
//  GroupChat
//
//  Created by Eric Tu on 2/2/21.
//

import Firebase
import FirebaseAuth

protocol MyDatabase {
    func isUserSignedIn() -> Bool
    func getUserEmail() -> String
    
    func signInWithEmail(email : String, pw : String, onComplete : @escaping () -> Void)
    func signUpWithEmail(email : String, firstName : String, lastName : String, pw : String, onComplete : @escaping () -> Void)
    func signOut()
    func listenForAuthStateChange(onComplete : @escaping (_ isSignedIn : Bool) -> Void)
    
    func closeListeners()
    
    func createGroup(groupName : String,
                     groupMembers : [String],
                     groupLeaderEmail : String,
                     onComplete : @escaping () -> Void)
    
}

class FirebaseDB : MyDatabase{
    var authStateChangeHandle : AuthStateDidChangeListenerHandle!
    
    init() {
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
        }
    }
    
    func listenForAuthStateChange(onComplete : @escaping (_ isSignedIn : Bool) -> Void) {
        authStateChangeHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            onComplete(Auth.auth().currentUser != nil)
        })
    }
    
    func closeListeners() {
        Auth.auth().removeStateDidChangeListener(authStateChangeHandle)
    }
    
    func createGroup(groupName: String, groupMembers: [String], groupLeaderEmail : String, onComplete: @escaping () -> Void) {
        let docRef = Firestore.firestore().collection("groups").addDocument(data: [
                                                                "group name":groupName,
                                                                "group-leader":groupLeaderEmail])
        
        let collectionRef = Firestore.firestore().collection("groups").document(docRef.documentID).collection("group members")
        
        for memberEmail in groupMembers {
            collectionRef.document(memberEmail).setData(["is member" : true])
        }
        
        Firestore.firestore().collection("users").document(groupLeaderEmail)
    }
    
    func signUpWithEmail(email: String, firstName : String, lastName: String, pw: String, onComplete: @escaping () -> Void) {
        
        // Register the user
        Auth.auth().createUser(withEmail: email, password: pw) { (authResult, error) in
            if let error = error {
                print("[README] Error creating a new user for email/password \(error)")
                return
            }
            
            // Store user in the Firestore
            let usersRef = Firestore.firestore().collection("users")
            usersRef.document(email).setData(["email":email, "first name": firstName, "last name": lastName, "password": pw]) { (error) in
                onComplete()
                print("New user is created with email \(authResult?.user.email)")
            }
        }
    }
    
    
    func signInWithEmail(email: String, pw: String, onComplete : @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: pw) { authResult, error in
            if let error = error {
                print("Error creating a new user for email/password \(error)")
                return
            }
            print("User is signed in with email \(authResult?.user.email)")
            onComplete()
        }
    }
    
    func isUserSignedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func getUserEmail() -> String {
        if self.isUserSignedIn(){
            return (Auth.auth().currentUser?.email)!
        }
        return "error:email not found"
    }
}
