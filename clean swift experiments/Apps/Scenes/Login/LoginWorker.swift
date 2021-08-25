import UIKit
import FirebaseAuth
import FirebaseFirestore
class LoginWorker
{
    let firestoreDB = Firestore.firestore()
    
    func doSomeWork()
    {
    }
    func doSignIn(request: Login.Login.Request, completion: @escaping (_ name: String?,_ errorProduced: Error?) -> Void){
        Auth.auth().signIn(withEmail: request.email, password: request.password) { authResultData, loginError in
            if let _ = loginError {
                completion(nil, loginError)
            }else {
                if let userId = authResultData?.user.uid {
                    self.fetchUserName(userId: userId, completion: completion)
                } else {
                    
                }
            }
        }
    }
    
    func fetchUserName(userId: String, completion: @escaping (_ name: String?,_ errorProduced: Error?) -> Void) {
        
        firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).getDocument { documentSnapshot, error in
            if let _ = error {
                completion(nil, error)
            } else {
                if let snapshot = documentSnapshot {
                    if  let data =  snapshot.data() {
                        print("----------data: \(data)")
                        let name = data[Constants.FirestoreKeys.userName] as! String
                        completion(name, nil) } else {
                            
                        }
                }else {}
            }
        }
    }
}
