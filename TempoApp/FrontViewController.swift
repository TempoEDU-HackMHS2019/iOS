//
//  FrontViewController.swift
//  Memerator
//
//  Created by Chew on 3/25/19.
//  Copyright © 2019 Memerator Dev Group. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class FrontViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let authkey = defaults.string(forKey: defaultsKeys.keyOne)
        
        let headers: HTTPHeaders = [
            "Authorization": authkey!
        ]
        
        AF.request("https://api.tempoapp.pro/v1/profile", method: .get, headers: headers).responseJSON { response in
            print(response)
            if response.response?.statusCode == 429 {
                return
            }
            //to get JSON return value
            let json = JSON(response.data as Any)
            self.welcomeLabel.text = "Welcome, \(json["username"].string!)"
        }
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Log-out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(FrontViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        let realm = try! Realm()
        
        let data = realm.objects(UserData.self)
        try! realm.write {
            realm.delete(data)
        }
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = false
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func toEventsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toEventsSegue", sender: self)
    }
    
}
