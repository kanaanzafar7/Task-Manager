
import UIKit
import FirebaseFirestore
import FirebaseAuth
class HomeWorker
{
    let firestoreDB = Firestore.firestore()
    
    func fetchTasksList(lastDocument : DocumentSnapshot?,  completion: @escaping (_ tasksList: [Task]?,_ errorProduced: Error?, _ lastDocument : DocumentSnapshot?) -> Void){
        
        if let userId = Auth.auth().currentUser?.uid{
            if let lastDoc = lastDocument {
                fetchNextTasks(userId: userId, lastDocument: lastDoc, completion: completion)
                
            } else {
                fetchFirstPage(userId: userId, completion: completion) }
        }
        
    }
    func fetchFirstPage(userId : String, completion: @escaping (_ tasksList: [Task]?, _ errorProduced : Error?, _ lastDocument: DocumentSnapshot?)-> Void){
        firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).collection(Constants.FirestoreKeys.tasksList).order(by: Constants.Task.notificationTime, descending: true).limit(to: 25).addSnapshotListener { querySnapshot, error in
            if let _ = error {
                completion(nil, error, nil)
            }else {
                if let documentsList = querySnapshot?.documents {
                    let tasksList = self.extractTasksFromDocuments(documentsList: documentsList)
                    let lastDoc =  documentsList.last
                    completion(tasksList, nil, lastDoc)
                }else {
                    completion([], error, nil)
                }
                
                
            }
        }
    }
    func fetchNextTasks(userId : String, lastDocument: DocumentSnapshot, completion: @escaping (_ tasksList: [Task]?, _ errorProduced : Error?, _ lastDocument: DocumentSnapshot?)-> Void) {
        firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).collection(Constants.FirestoreKeys.tasksList).order(by: Constants.Task.notificationTime, descending: true).start(afterDocument: lastDocument).limit(to: 25).addSnapshotListener { querySnapshot, error in
            if let _ = error {
                completion(nil, error, nil)
            }else {
                if let documentsList = querySnapshot?.documents {
                    let tasksList = self.extractTasksFromDocuments(documentsList: documentsList)
                    let lastDoc =  documentsList.last
                    completion(tasksList, nil, lastDoc)
                }else {
                    completion([], error, nil)
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
    func extractTasksFromDocuments(documentsList: [DocumentSnapshot])-> [Task]{
        var tasksList : [Task] = []
        for document in documentsList {
            let data : [String: Any]? = document.data()
            if let id : String = data?[Constants.Task.taskId] as? String,
               let title : String = data?[Constants.Task.taskTitle] as? String,
               let description: String = data?[Constants.Task.taskDesc] as? String,
               let notificationtime : TimeInterval = data?[Constants.Task.notificationTime] as? TimeInterval{
                let isCompleted = data?[Constants.Task.isCompleted] as? Bool ?? false
                let task = Task(taskId: id, taskTitle: title, taskDescription: description, isCompleted: isCompleted, notificationTime: notificationtime)
                tasksList.append(task)
            }
        }
        return tasksList
    }
}
