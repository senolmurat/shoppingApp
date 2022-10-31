//
//  FirebaseManager.swift
//  PhotoApp
//
//  Created by Murat ŞENOL on 16.10.2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

protocol FirebaseManagerDelegate: AnyObject {
    func didUpdateFavourites()
    func didUpdateBookmarks()
}

struct FirebaseManager {
    
    static weak var delegate: FirebaseManagerDelegate?
    static let currentAuthUser = Auth.auth().currentUser
    static let db = Firestore.firestore()
    
    static func addFavourites(photoID: String) {
        db.collection("users").document(currentAuthUser!.uid).updateData([
            "favourites": FieldValue.arrayUnion([photoID])
        ])
        delegate?.didUpdateFavourites()
    }
    
    static func addBookmarks(photoID: String) {
        db.collection("users").document(currentAuthUser!.uid).updateData([
            "bookmarks": FieldValue.arrayUnion([photoID])
        ])
        delegate?.didUpdateBookmarks()
    }
    
    static func changeUsername(username: String) {
        db.collection("users").document(currentAuthUser!.uid).updateData([
            "username": username
        ])
    }
}
