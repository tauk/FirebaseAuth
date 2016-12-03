//
//  AfterLoginViewController.swift
//  FirebaseAuth
//
//  Created by Tauseef Kamal on 11/25/16.
//  Copyright © 2016 Tauseef Kamal. All rights reserved.
//

import UIKit

class AfterLoginViewController: UIViewController {
    
    var userName = ""
    @IBOutlet weak var lblUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblUserName.text = "Welcome \(userName)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
