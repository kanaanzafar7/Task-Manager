//
//  RegisterWorker.swift
//  clean swift experiments
//
//  Created by Kanaan Zafar on 20/08/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class RegisterWorker
{
    let firestoreDB = Firestore.firestore()
    
    func doSignUp (name : String, email : String, password : String, completion: @escaping (_ name: String?,_ errorProduced: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResultData, error in
            if let e = error {
                //                delegate?.failedToLogin(error: e)
                completion(nil, e)
                
            } else {
                if let userId = authResultData?.user.uid {
                    self.firestoreDB.collection(Constants.FirestoreKeys.users).document(userId)                        .setData([Constants.FirestoreKeys.userName : name]) { error in
                        if let err = error {
                            completion(nil, err)
                        } else {
                            completion(name, nil)
                        }
                    }
                }
            }
        }
    }
}
