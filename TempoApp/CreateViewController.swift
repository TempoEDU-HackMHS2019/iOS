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

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var authkey:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let parameters = [
            "email": emailText.text,
            "password": passText.text,
            "phone": phoneText.text,
            "username": usernameText.text
        ]
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
            
            let realm = try! Realm()
            
            let data = UserData()
            data.api_key = json["key"].string!
            print("Storing: \(String(describing: data.api_key))")
            try! realm.write {
                realm.add(data)
            }
            
            self.defaults.set(self.authkey, forKey: defaultsKeys.keyOne)
            
            
            self.performSegue(withIdentifier: "FromCreateToFrontSegue", sender: self)
        }

        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
