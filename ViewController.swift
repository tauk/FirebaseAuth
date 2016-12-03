//
//  ViewController.swift
//  FirebaseAuth
//
//  Created by Tauseef Kamal on 11/24/16.
//  Copyright © 2016 Tauseef Kamal. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        //move the text fields away from the center
        txtUsername.center.x += view.bounds.width
        txtPassword.center.x -= view.bounds.width
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1.5, delay: 1.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.9,
                                   options: [], animations: {
                                    self.txtUsername.center.x -= self.view.bounds.width
                                    self.txtPassword.center.x += self.view.bounds.width
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doLogin(_ sender: Any) {
        let tUsername = txtUsername.text
        let tPassword = txtPassword.text
        
        if (tUsername == "" || tPassword == "") {
            self.showAlert(titleText: "Error", messageText: "Enter username and password")
            return
        }
        
        let dbReference = FIRDatabase.database().reference()
        
        //reference to users in database until the username in the useraccounts
        let usersReference = dbReference.child("useraccounts").child(tUsername!)
        
        //data comes into a snapshot object
        usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //self.lblStatus.text = "\(snapshot.exists())"
            
            //check the snapshot object - if does not exist the username does not exist - show error and return
            if (snapshot.exists() == false) {
                //we dont have a user with this username - Login failed!
                self.showAlert(titleText: "Login Failed!", messageText: "Incorrect username or password")
                return
            }
            
            //if we reach here we have a username but we still need to verify the password entered by the user
            
            //from the snapshot get the entry as key-value (KV)pair
            //use a swift native Dictionary object to hold the KV pair
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            //use the key "password" to get the value for the password
            let password = snapshotValue["password"]
            //let email = snapshotValue["email"]
            
            //check if the password from useraccount.username is same tPassword entered by the user
            if (password == tPassword) {
                //self.lblStatus.text = "login true!"
                
                //passwords are matching - do login perform segue to another view
                self.performSegue(withIdentifier: "showAfterLoginView", sender: nil)
            }
            else {
                //we dont have matching password for this username
                self.showAlert(titleText: "Login Failed!", messageText: "Incorrect username / password")
            }
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showAfterLoginView") {
            if let nextController = segue.destination as? AfterLoginViewController {
                nextController.userName = txtUsername.text!
            }
        }
    }
    
    //reusable method to show alert box
    private func showAlert(titleText:String, messageText:String) {
        let errorAlert = UIAlertController(title: titleText, message:messageText,
                                           preferredStyle: UIAlertControllerStyle.alert)
        
        //add a button to the alert message with title OK
        errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        //display the error message
        self.present(errorAlert, animated: true, completion: nil)
    }

}

