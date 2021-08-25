import UIKit
import FirebaseAuth
import FirebaseFirestore
class AddTaskSceneWorker
{
    let firestoreDB = Firestore.firestore()
    func doSomeWork()
    {
    }
    func uploadTask(request : AddTaskScene.TaskUpload.Request, completion: @escaping (_ task: Task?,_ errorProduced: Error?) -> Void){
                    let uniqueID : String = UUID().uuidString //?? UUID().uuidString
        let task = Task(taskId: uniqueID, taskTitle: request.title, taskDescription: request.description, isCompleted: false, notificationTime: request.notificationTime.timeIntervalSince1970)
        HelperFunctions().uploadTask(task: task, completion: completion)
        
        /* if let userId = Auth.auth().currentUser?.uid {
            let uniqueID : String = UUID().uuidString
            let task = Task(taskId: uniqueID, taskTitle: request.title, taskDescription: request.description, isCompleted: false, notificationTime: request.notificationTime.timeIntervalSince1970)
            firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).collection(Constants.FirestoreKeys.tasksList).document(uniqueID).setData([Constants.Task.taskId : task.taskId,Constants.Task.taskTitle : task.taskTitle,
                                                                                                                                                             Constants.Task.taskDesc : task.taskDescription,
                                                                                                                                                             Constants.Task.notificationTime : task.notificationTime
            ]) { uploadError in
                if let error = uploadError {
                    completion(nil, error)
                } else {
                    let notificationsManager = NotificationsManager()
                    
                    notificationsManager.scheduleNotification(title: task.taskTitle, message: task.taskDescription, date: NSDate(timeIntervalSince1970: task.notificationTime) as Date, identifier: task.taskId)
                    completion(task, nil)
                }
            }
        } else {} */
    }
}
