
import UIKit
import FirebaseFirestore
import FirebaseAuth
class HomeWorker
{
    let firestoreDB = Firestore.firestore()
    
    func fetchTasksList(completion: @escaping (_ tasksList: [Task]?,_ errorProduced: Error?) -> Void){
        
        if let userId = Auth.auth().currentUser?.uid{
            firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).collection(Constants.FirestoreKeys.tasksList).addSnapshotListener { querySnapshot, error in
                if let _ = error {
                    completion(nil, error)
                }else {
                    
                    if let documentsList = querySnapshot?.documents {
                        var tasksList : [Task] = []
                        for document in documentsList {
                            let data : [String: Any] = document.data()
                            if let id : String = data[Constants.Task.taskId] as? String,
                               let title : String = data[Constants.Task.taskTitle] as? String,
                               let description: String = data[Constants.Task.taskDesc] as? String,
                               let notificationtime : TimeInterval = data[Constants.Task.notificationTime] as? TimeInterval{
                                let isCompleted = data[Constants.Task.isCompleted] as? Bool ?? false
                                let task = Task(taskId: id, taskTitle: title, taskDescription: description, isCompleted: isCompleted, notificationTime: notificationtime)
                                tasksList.append(task)
                            }
                        }
                        completion(tasksList, nil)
                    }else {
                        completion([], error)
                    }
                    
                    
                }
            }
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
