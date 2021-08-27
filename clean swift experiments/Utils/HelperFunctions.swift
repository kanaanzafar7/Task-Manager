import Foundation
import FirebaseAuth
import FirebaseFirestore
struct HelperFunctions {
    let firestoreDB = Firestore.firestore()
    func deleteTask(id : String, completion: @escaping (_ errorProduced: Error?)->Void){
        
        if let userId = Auth.auth().currentUser?.uid {
            firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).collection(Constants.FirestoreKeys.tasksList).document(id).delete { deletionError in
                if let _ = deletionError {
                    completion(deletionError)
                }else {
                    NotificationsManager().removeScheduledNotification(id: id)
                    completion(nil)
                }
            }
            ///asdasd
        }
    }
    
    func uploadTask(task : Task, completion: @escaping (_ task: Task?,_ errorProduced: Error?) -> Void){
        if let userId = Auth.auth().currentUser?.uid {

            firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).collection(Constants.FirestoreKeys.tasksList).document(task.taskId).setData([Constants.Task.taskId : task.taskId,Constants.Task.taskTitle : task.taskTitle,
                                                                                                                                                             Constants.Task.taskDesc : task.taskDescription,
                                                                                                                                                             Constants.Task.notificationTime : task.notificationTime,
                                                                                                                                                             Constants.Task.isCompleted : task.isCompleted
            ]) { uploadError in
                if let error = uploadError {
                    completion(nil, error)
                } else {
                    let notificationsManager = NotificationsManager()
                    
                    notificationsManager.scheduleNotification(title: task.taskTitle, message: task.taskDescription, date: NSDate(timeIntervalSince1970: task.notificationTime) as Date, identifier: task.taskId)
                    completion(task, nil)
                }
            }
        } else {}
    }
    func uploadHundredTasks(){
        if let userId = Auth.auth().currentUser?.uid {
            for i in 0...100{
                let task = Task(taskId: UUID().uuidString, taskTitle: "Task Number \(i)", taskDescription: "Temp task description", isCompleted: false, notificationTime: Date().timeIntervalSince1970)
                uploadTask(task: task) { taskOpt, errorOpt in
                    if let error = errorOpt {
                        print("-----error: \(error)")
                    } else {

                    }
                }
            }
  
    }
}
}
