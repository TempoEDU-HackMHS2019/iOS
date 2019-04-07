//
//  FrontViewController.swift
//  TempoApp
//
//  Created by Chew on 4/7/19.
//  Copyright © 2019 TempoApp Development. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class FrontViewController: UIViewController {
    // Define variables we will use later.
    @IBOutlet weak var welcomeLabel: UILabel!

    let defaults = UserDefaults.standard

    @IBOutlet weak var hotbar: UILabel!
    // This method will run when the view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Send a request for the user's profile.
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
            self.hotbar.text = "Your hotbar: \(json["hotbar"].double ?? 0.0)"
        }

        // Replace back button with Log-out
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Log-out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(FrontViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    // Button that will go to events
    @IBAction func toEventsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toEventsSegue", sender: self)
    }

    // Method to log out when the button is pressed.
    @objc func back(sender: UIBarButtonItem) {
        let realm = try! Realm()

        let data = realm.objects(UserData.self)
        try! realm.write {
            realm.delete(data)
        }
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }

    // Hide back button when the view will appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = false
    }

}
