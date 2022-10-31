//
//  AuthViewModel.swift
//  Crypto App
//
//  Created by Pazarama iOS Bootcamp on 9.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseRemoteConfig

protocol AuthDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didSignedUp()
    func didSignedIn()
}

final class AuthViewModel {
    init() {}
    
    weak var delegate: AuthDelegate?
    
    func signUp(_ credential: String,_ password: String, username: String) {
        Auth.auth().createUser(withEmail: credential, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                self.delegate?.didErrorOccurred(error)
                return
            }
            print(authResult)
            if let uID = authResult?.user.uid {
                FirebaseManager.db.collection("users").document(uID).setData([
                    "id": uID,
                    "username": username,
                    "email": credential,
                    "favourites": [],
                    "bookmarks" : []
                ]) { err in
                    if let err = err {
                        self.delegate?.didErrorOccurred(err)
                    } else {
                        self.delegate?.didSignedUp()
                    }
                }
            }
        }
    }
    
    func signIn(_ credential: String,_ password: String) {
        Auth.auth().signIn(withEmail: credential, password: password) { [weak self] authResult, error in
            guard let _ = self else { return }
            if let error = error {
                print(error.localizedDescription)
                self?.delegate?.didErrorOccurred(error)
                return
            }
            print(authResult)
            
            self?.delegate?.didSignedIn()
            // TODO: show alert info
        }
    }
    
    func fetchRemoteConfig(completion: @escaping (Bool) -> Void) {
            let remoteConfig = RemoteConfig.remoteConfig()
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            remoteConfig.configSettings = settings
            remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
            
            remoteConfig.fetch { (status, error) -> Void in
                if status == .success {
                    remoteConfig.activate { _, error in
                        
                        if let error = error {
                            self.delegate?.didErrorOccurred(error)
                            return
                        }
                        
                        let isSignUpDisabled = remoteConfig.configValue(forKey: "isSignUpDisabled").boolValue
                        DispatchQueue.main.async {
                            completion(isSignUpDisabled)
                        }
                    }
                } else {
                    guard let error = error else {
                        return
                    }
                    self.delegate?.didErrorOccurred(error)
                }
            }
        }
}
