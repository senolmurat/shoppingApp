//
//  ProfileViewModel.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import Foundation
import API
import FirebaseAuth
import FirebaseFirestoreSwift

protocol ProfileDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didErrorOccurred(_ message: String)
    func didGetProfile(response: ProfileViewModel.FetchProfile.Response)
    func didLogout(response: ProfileViewModel.FetchLogout.Response)
}

protocol UserItem {
    var userId: String? {get}
    var userEmail: String? {get}
    var userName: String? {get}
}

extension UserEntity: UserItem {
    var userId: String? {
        id
    }
    
    var userEmail: String? {
        email
    }
    
    var userName: String? {
        username
    }
}

final class ProfileViewModel {
    
    public enum FetchProfile {
        struct Request {}
        struct Response {
            var user: UserItem?
        }
    }
    
    public enum FetchLogout {
        struct Request {}
        struct Response {}
    }
    
    weak var delegate: ProfileDelegate?
    
    private(set) var profileResponse: ProfileViewModel.FetchProfile.Response? {
        didSet {
            delegate?.didGetProfile(response: profileResponse!)
        }
    }

    init(){}
    
    func fetchProfile(_ request: ProfileViewModel.FetchProfile.Request) {
        guard let userId = FirebaseManager.currentAuthUser?.uid else {
            self.delegate?.didErrorOccurred("Something went wrong. User does not exists")
            return
        }
        // TODO: fetch from firebase
        let userRef = FirebaseManager.db.collection("users").document(userId)

        userRef.getDocument(as: UserEntity.self) { result in
            switch result {
                case .success(let user):
                self.profileResponse = .init(user: user)
                case .failure(let error):
                    self.delegate?.didErrorOccurred(error)
            }
        }
    }
    
    func fetchLogout() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.delegate?.didLogout(response: .init())
        } catch let signOutError{
            self.delegate?.didErrorOccurred(signOutError)
        }
    }
}
