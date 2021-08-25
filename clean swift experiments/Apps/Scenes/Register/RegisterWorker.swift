import UIKit
import FirebaseAuth
import FirebaseFirestore
class RegisterWorker
{
    let firestoreDB = Firestore.firestore()
    
    func doSignUp (name : String, email : String, password : String, completion: @escaping (_ name: String?,_ errorProduced: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResultData, error in
            if let e = error {
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
