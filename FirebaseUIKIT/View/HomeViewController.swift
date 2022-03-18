//
//  HomeViewController.swift
//  FirebaseUIKIT
//
//  Created by Zelxius on 18/03/22.
//

import UIKit
import Firebase

class Celda: UITableViewCell {
    
    @IBOutlet weak var portada: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var plataforma: UILabel!
    @IBOutlet weak var desc: UITextView!
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabla: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        FirebaseViewModel.shared.getData { done in
            if done{
                self.tabla.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseViewModel.shared.datos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Celda
        let juego = FirebaseViewModel.shared.datos[indexPath.row]
        cell.titulo.text = juego.titulo
        cell.desc.text = juego.desc
        cell.plataforma.text = juego.plataforma
        
        Storage.storage().reference(forURL: juego.portada).getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error?.localizedDescription{
                print("Error al traer la imagen", error)
            }else{
                DispatchQueue.main.async {
                    cell.portada.image = UIImage(data: data!)
                    self.tabla.reloadData()
                }
            }
        }
        return cell
    }
    
    // editar
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "enviar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviar"{
            if let id = tabla.indexPathForSelectedRow{
                let fila = FirebaseViewModel.shared.datos[id.row]
                let destino = segue.destination as! AddViewController
                destino.datos = fila
            }
        }
    }
    
    // eliminar
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "borrar") { (_, _, _) in
            let juego = FirebaseViewModel.shared.datos[indexPath.row]
            FirebaseViewModel.shared.delete(index: juego)
        }
        delete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    

    @IBAction func salir(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: "sesion")
        dismiss(animated: true, completion: nil)
    }
    
}
