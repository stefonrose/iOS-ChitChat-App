//
//  LoginVC.swift
//  Parse Chat
//
//  Created by Stephon Fonrose on 12/20/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let takenUsernameAlert = UIAlertController(title: "Username Taken", message: "Please try another.", preferredStyle: .alert)
    let userPassSignUpAlert = UIAlertController(title: "Sign-Up Failed", message: "Make sure you entered a valid username and password.", preferredStyle: .alert)
    let userPassRequiredAlert = UIAlertController(title: "Login Failed", message: "Please enter a username/password.", preferredStyle: .alert)
    let invalidPasswordAlert = UIAlertController(title: "Login Failed", message: "Invalid username/password combination. Try again.", preferredStyle: .alert)
    
    let cancelAction0 = UIAlertAction(title: "Ok", style: .cancel)
    let cancelAction1 = UIAlertAction(title: "Ok", style: .cancel)
    let cancelAction2 = UIAlertAction(title: "Ok", style: .cancel)
    let cancelAction3 = UIAlertAction(title: "Ok", style: .cancel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        takenUsernameAlert.addAction(cancelAction0)
        userPassRequiredAlert.addAction(cancelAction1)
        invalidPasswordAlert.addAction(cancelAction2)
        userPassSignUpAlert.addAction(cancelAction3)
        
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) {
            (user: PFUser?, error: Error?) in
            if let error = error {
                if error._code == 200 || error._code == 201 {
                    self.present(self.userPassRequiredAlert, animated: true)
                }
                if error._code == 101 {
                    self.present(self.invalidPasswordAlert, animated: true)
                }
                print("User log in failed: \(error.localizedDescription)")
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text ?? ""
        newUser.password = passwordField.text ?? ""
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                if error._code == 200 || error._code == 201 {
                    self.present(self.userPassSignUpAlert, animated: true)
                }
                if error._code == 202 {
                    self.present(self.takenUsernameAlert, animated: true)
                } else {
                    print(error.localizedDescription)
                }
            } else {
                if success{
                    print("Nothing should be happening! \(success)")
                    //self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
    }
}
