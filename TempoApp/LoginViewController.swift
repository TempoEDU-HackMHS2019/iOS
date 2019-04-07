//
//  LoginViewController.swift
//  TempoApp
//
//  Created by Chew on 4/6/19.
//  Copyright © 2019 TempoApp Development. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

// Intra-app data.
struct defaultsKeys {
    static let keyOne = "firstStringKey"
    static let keyTwo = "secondStringKey"
}

// Really to store API key between app sessions.
class UserData: Object {
    @objc dynamic var api_key: String!
}

class LoginViewController: UIViewController {
    // IBoutlets for labels from the storyboard.
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    let defaults = UserDefaults.standard

    var authkey:String!
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var navigationitem: UINavigationItem!

    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide back button
        self.navigationItem.setHidesBackButton(true, animated: false)

        dismissKeyboard()

        // Check to see if auth key is there, if so, OFF TO THE FRONT NO LOGIN NEEDED.
        let realm = try! Realm()

        let data = realm.objects(UserData.self)

        if data.count > 0 {
            print(data.first?.api_key as Any)
            if data[0].api_key == nil {
                realm.delete(data)
            } else {
                self.defaults.set(data[0].api_key, forKey: defaultsKeys.keyOne)
                self.performSegue(withIdentifier: "ToFrontSegue", sender: self)
            }
        }
    }

    // Self explanatory.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Uh oh! THe user is comig back!!!! omg!!!!! clear everything this is a pep-rally
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = false

        usernameText.text = ""
        passwordText.text = ""
        dismissKeyboard()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordText.resignFirstResponder()
        return true
    }

    // me rn
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // When login button is pressed, handle login!
    @IBAction func loginButton(_ sender: Any) {
        // Input => parameters
        let parameters = [
            "email": self.usernameText.text,
            "password": self.passwordText.text
        ]
        // Send request
        AF.request("https://api.tempoapp.pro/v1/login", method: .post, parameters: parameters).responseJSON { response in
            print(response)
            if response.response?.statusCode == 401 { // If wrong credentials
                self.errorLabel.text = "Error: invalid credentials"
                return
            }
            if response.response?.statusCode == 429 { // If they SPAM THE BUTTON CALM DOWN
                self.errorLabel.text = "Error: You are doing that too fast!"
                return
            }
            //to get JSON return value
            let json = JSON(response.data as Any)
            self.authkey = json["key"].string!
            
            // Store API Key
            let realm = try! Realm()

            let data = UserData()
            data.api_key = json["key"].string!
            print("Storing: \(String(describing: data.api_key))")
            try! realm.write {
                realm.add(data)
            }

            self.defaults.set(self.authkey, forKey: defaultsKeys.keyOne)

            // A job well done, shoo them.
            self.performSegue(withIdentifier: "ToFrontSegue", sender: self)
        }
    }
    
    // Oh you want to create an account? We you covered.
    @IBAction func createAccount(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateAccountSegue", sender: self)
    }

}
