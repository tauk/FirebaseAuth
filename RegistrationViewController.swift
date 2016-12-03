//
//  RegistrationViewController.swift
//  FirebaseAuth
//
//  Created by Tauseef Kamal on 11/27/16.
//  Copyright © 2016 Tauseef Kamal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //mask password fields
        tfPassword.isSecureTextEntry = true
        tfConfirmPassword.isSecureTextEntry = true
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doRegister(_ sender: Any) {
        let userName = tfUserName.text! as String
        let password = tfPassword.text! as String
        let confirmPassword = tfConfirmPassword.text! as String
        let email = tfEmail.text! as String
        
        //do some validations which are required before registration
        if (userName == "" || password == "" || confirmPassword == "" || email == "") {
            showAlert(titleText: "User Error!", messageText: "Please fill all textboxes")
            return
        }
        
        //check if passwords are less than 6 chars
        if (userName.characters.count < 5 || password.characters.count < 5 ||
            confirmPassword.characters.count < 5) {
            showAlert(titleText: "User Error", messageText: "User name and password must be at least 5 characters or more")
            return
        }
        
        //check if passwords are matching
        if (password != confirmPassword) {
            showAlert(titleText: "User Error!", messageText: "Passwords not matching!")
            return
        }
        
        
        //get a database reference 
        let dbReference = FIRDatabase.database().reference()
        
        //reference to userName in "useraccounts" in database
        let userNameReference = dbReference.child("useraccounts").child(userName)

        userNameReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //check the snapshot object - if it does exist a user exists with this user name - show error and return
            if (snapshot.exists() == true) {
                //we dont have a user with this username - Login failed!
                self.showAlert(titleText: "Username exists", messageText: "Choose another username!")
                return
            }
            
            //create the new reference with values
            userNameReference.setValue(["password":password, "email":email])
            
            //self.showAlert(titleText: "Useraccount created", messageText: "Login now!")
            
            //registration done show login view
            self.performSegue(withIdentifier: "showLoginView", sender: nil)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
