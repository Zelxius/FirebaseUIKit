//
//  FirebaseViewModel.swift
//  FirebaseUIKIT
//
//  Created by Zelxius on 18/03/22.
//

import Foundation
import Firebase
import UIKit

class FirebaseViewModel{
    
    public static let shared = FirebaseViewModel()
    var datos = [FirebaseModel]()
    
    func login(email:String, pass: String, completion: @escaping (_ done: Bool) -> Void ){
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if user != nil {
                    print("Entro")
                    completion(true)
                }else{
                    if let error = error?.localizedDescription {
                        print("Error en firebase", error)
                    }else{
                        print("Error en la app")
                    }
                }
            }
        }
        
        func createUser(email:String, pass: String, completion: @escaping (_ done: Bool) -> Void ){
            Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                if user != nil {
                    print("Entro y se registro")
                    completion(true)
                }else{
                    if let error = error?.localizedDescription {
                        print("Error en firebase de registro", error)
                    }else{
                        print("Error en la app")
                    }
                }
            }
        }

    // GUARDAR
    func save(titulo:String, desc:String, plataforma:String, portada:UIImage, completion: @escaping (_ done: Bool) -> Void ){
            
            let storage = Storage.storage().reference()
            let nombrePortada = UUID()
            let directorio = storage.child("imagenes/\(nombrePortada)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            
        directorio.putData(portada.pngData()!, metadata: metadata){data,error in
                if error == nil {
                    print("guardo la imagen")
                    // GUARDAR TEXTO
                    let db = Firestore.firestore()
                    let id = UUID().uuidString
                    guard let idUser = Auth.auth().currentUser?.uid else { return  }
                    guard let email = Auth.auth().currentUser?.email else { return  }
                    let campos : [String:Any] = ["titulo":titulo,"desc":desc,"portada":String(describing: directorio),"idUser":idUser,"email":email,"plataforma":plataforma]
                    db.collection("juegos").document(id).setData(campos){error in
                        if let error = error?.localizedDescription{
                            print("error al guardar en firestore", error)
                        }else{
                            print("guardo todo")
                            completion(true)
                        }
                    }
                    
                    // TERMINO DE GUARDAR TEXTO
                }else{
                    if let error = error?.localizedDescription {
                        print("fallo al subir la imagen en storage", error)
                    }else{
                        print("fallo la app")
                    }
                }
            }
            
        }
    
    // mostrar
    func getData(completion: @escaping (_ done: Bool) -> Void ){
            let db = Firestore.firestore()
            db.collection("juegos").addSnapshotListener { (QuerySnapshot, error) in
                if let error = error?.localizedDescription{
                    print("error al mostrar datos ", error)
                }else{
                    self.datos.removeAll()
                    for document in QuerySnapshot!.documents {
                        let valor = document.data()
                        let id = document.documentID
                        let titulo = valor["titulo"] as? String ?? "sin titulo"
                        let desc = valor["desc"] as? String ?? "sin desc"
                        let portada = valor["portada"] as? String ?? "sin portada"
                        let plataforma = valor["plataforma"] as? String ?? "sin plataforma"
                        DispatchQueue.main.async {
                            let registros = FirebaseModel(id: id, titulo: titulo, desc: desc, portada: portada, plataforma: plataforma)
                            self.datos.append(registros)
                            completion(true)
                        }
                    }
                }
            }
        }
    
    // ELIMINAR
    
    func delete(index:FirebaseModel){
            // eliminar firestore
            let id = index.id
            let db = Firestore.firestore()
            db.collection("juegos").document(id).delete()
            // eliminar del storage
            let imagen = index.portada
            let borrarImagen = Storage.storage().reference(forURL: imagen)
            borrarImagen.delete(completion: nil)
        }
    
    // EDITAR
        
        func edit(titulo:String, desc:String, plataforma:String, id:String, completion: @escaping (_ done:Bool) -> Void ){
            let db = Firestore.firestore()
            let campos : [String:Any] = ["titulo":titulo,"desc":desc,"plataforma":plataforma]
            db.collection("juegos").document(id).updateData(campos){error in
                if let error = error?.localizedDescription {
                    print("Error al editar", error)
                }else{
                    print("edito solo texto")
                    completion(true)
                }
            }
        }
        
        // EDITAR CON IMAGEN
        func editWithImage(titulo:String, desc:String, plataforma:String, id:String, index:FirebaseModel, portada: UIImage, completion: @escaping (_ done:Bool) -> Void ){
            // Eliminar imagen
            let imagen = index.portada
            let borrarImagen = Storage.storage().reference(forURL: imagen)
            borrarImagen.delete(completion: nil)
            
            // Subir la nueva imagen
            
            let storage = Storage.storage().reference()
            let nombrePortada = UUID()
            let directorio = storage.child("imagenes/\(nombrePortada)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            
            directorio.putData(portada.pngData()!, metadata: metadata){data,error in
                if error == nil {
                    print("guardo la imagen nueva")
                    // EDITANDO TEXTO
                    let db = Firestore.firestore()
                    let campos : [String:Any] = ["titulo":titulo,"desc":desc, "portada":String(describing: directorio), "plataforma":plataforma]
                    db.collection("juegos").document(id).updateData(campos){error in
                        if let error = error?.localizedDescription {
                            print("Error al editar", error)
                        }else{
                            print("edito solo texto")
                            completion(true)
                        }
                    }
                    
                    // TERMINO DE GUARDAR TEXTO
                }else{
                    if let error = error?.localizedDescription {
                        print("fallo al subir la imagen en storage", error)
                    }else{
                        print("fallo la app")
                    }
                }
            }
        }

}
