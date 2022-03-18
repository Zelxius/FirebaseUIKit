//
//  AddViewController.swift
//  FirebaseUIKIT
//
//  Created by Colimasoft on 18/03/22.
//

import UIKit
import SwiftUI

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var plataformas: UIPickerView!
    @IBOutlet weak var portada: UIImageView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    var image = UIImage()
    
    let plat = ["playstation", "xbox", "nintendo"]
    var consola = "playstation"
    
    override func viewDidLoad() {
        progress.isHidden = true
        super.viewDidLoad()
        plataformas.delegate = self
        plataformas.dataSource = self

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return plat.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return plat[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        consola = plat[row]
        print(consola)
    }
    
    @IBAction func cargarimagen(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenTomada = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        image = imagenTomada!
        portada.image = image
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func guardar(_ sender: UIButton) {
        progress.isHidden = false
        progress.startAnimating()
        guard let title = titulo.text else { return }
        guard let descri = desc.text else { return }
        FirebaseViewModel.shared.save(titulo: title, desc: descri, plataforma: consola, portada: image) { done in
            if done {
                self.titulo.text = ""
                self.desc.text = ""
                self.portada.image = UIImage(systemName: "photo")
                self.progress.stopAnimating()
                self.progress.isHidden = true
            }
        }
    }
}
