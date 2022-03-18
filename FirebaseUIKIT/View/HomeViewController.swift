//
//  HomeViewController.swift
//  FirebaseUIKIT
//
//  Created by Zelxius on 18/03/22.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func salir(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: "sesion")
        dismiss(animated: true, completion: nil)
    }
    
}
