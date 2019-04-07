//
//  CreateViewController.swift
//  TempoApp
//
//  Created by Chew on 4/6/19.
//  Copyright © 2019 TempoApp Development. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class CreateViewController: UIViewController {

    // IBOutlets for labels found in the storyboard.
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var authkey:String!
    
    // These run when the view is loaded, however we do not need it.
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // When the create account button is pressed, make the account duh.
    @IBAction func createAccountButton(_ sender: Any) {
        // Convert input boxes => something we can use.
        let parameters = [
            "email": emailText.text,
            "password": passText.text,
            "phone": phoneText.text,
            "username": usernameText.text
        ]
        // Send request to the server to make a new account.
        AF.request("https://api.tempoapp.pro/v1/create", method: .post, parameters: parameters).responseJSON { response in
            print(response)
            let json = JSON(response.data as Any)
            if response.response?.statusCode == 429 {
                self.errorLabel.text = "Error: You are doing that too fast!"
                return
            }
            if response.response?.statusCode == 400 {
                self.errorLabel.text = json["reason"].string!
                return
            }
            //to get JSON return value
            self.authkey = json["key"].string!
            
            // Store API key between sessions.
            let realm = try! Realm()
            
            let data = UserData()
            data.api_key = json["key"].string!
            print("Storing: \(String(describing: data.api_key))")
            try! realm.write {
                realm.add(data)
            }
            
            self.defaults.set(self.authkey, forKey: defaultsKeys.keyOne)
            
            // Off to the front.
            self.performSegue(withIdentifier: "FromCreateToFrontSegue", sender: self)
        }

        
    }

}
