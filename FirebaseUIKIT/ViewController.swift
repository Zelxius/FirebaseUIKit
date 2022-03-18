//
//  ViewController.swift
//  FirebaseUIKIT
//
//  Created by Zelxius on 18/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // NAVIGATION BAR COLORS
        //doesn't work
        let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .purple
                appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                                  .foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                
                navigationController?.navigationBar.tintColor = .white
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (UserDefaults.standard.object(forKey: "sesion") != nil){
            self.next(identificador: "entrar")
        }
    }
    
    @IBAction func entrar(_ sender: UIButton) {
        guard let emailtxt = email.text else { return }
        guard let passtxt = pass.text else { return }
        FirebaseViewModel.shared.login(email: emailtxt, pass: passtxt) { done in
            UserDefaults.standard.set(true, forKey: "sesion")
            self.next(identificador: "entrar")
        }
    }
    
    @IBAction func registrar(_ sender: UIButton) {
        guard let emailtxt = email.text else { return }
        guard let passtxt = pass.text else { return }
        FirebaseViewModel.shared.createUser(email: emailtxt, pass: passtxt) { done in
            UserDefaults.standard.set(true, forKey: "sesion")
            self.next(identificador: "entrar")
        }
    }
    
    func next(identificador: String){
        performSegue(withIdentifier: identificador, sender: self)
    }
}

