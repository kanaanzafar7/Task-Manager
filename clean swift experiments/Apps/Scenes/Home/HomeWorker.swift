
import UIKit
import FirebaseFirestore
import FirebaseAuth
class HomeWorker
{
    let firestoreDB = Firestore.firestore()
    
    func fetchTasksList(lastDocument : DocumentSnapshot?,  completion: @escaping (_ documentsList: [DocumentSnapshot]?,_ errorProduced: Error?) -> Void){
        
        if let userId = Auth.auth().currentUser?.uid{
            if let lastDoc = lastDocument {
                fetchNextTasks(userId: userId, lastDocument: lastDoc, completion: completion)
                
            } else {
                fetchFirstPage(userId: userId, completion: completion) }
        }
        
    }
    func fetchFirstPage(userId : String,  completion: @escaping (_ documentsList: [DocumentSnapshot]?,_ errorProduced: Error?) -> Void){
        firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).collection(Constants.FirestoreKeys.tasksList).order(by: Constants.Task.notificationTime, descending: true).limit(to: 25).addSnapshotListener { querySnapshot, error in
            completion(querySnapshot?.documents, error)
        }
    }
    func fetchNextTasks(userId : String, lastDocument: DocumentSnapshot, completion: @escaping (_ documentsList: [DocumentSnapshot]?,_ errorProduced: Error?) -> Void) {
        firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).collection(Constants.FirestoreKeys.tasksList).order(by: Constants.Task.notificationTime, descending: true).start(afterDocument: lastDocument).limit(to: 25).addSnapshotListener { querySnapshot, error in
            completion(querySnapshot?.documents, error)
        }
    }
    func signOutUser(completion: @escaping (_ errorProduced: Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    func permissionForNotifications() {
        NotificationsManager().askPermissionForNotifications()
    }
    
    func deleteTask(request : Home.DeleteTask.Request, completion: @escaping (_ errorProduced: Error?)->Void){
        HelperFunctions().deleteTask(id: request.taskId, completion: completion)
    }

}
