import UIKit
import FirebaseAuth
import FirebaseFirestore
class AddTaskSceneWorker
{
    let firestoreDB = Firestore.firestore()
    func uploadTask(request : AddTaskScene.TaskUpload.Request, completion: @escaping (_ task: Task?,_ errorProduced: Error?) -> Void){
                    let uniqueID : String = UUID().uuidString
        let task = Task(taskId: uniqueID, taskTitle: request.title, taskDescription: request.description, isCompleted: false, notificationTime: request.notificationTime.timeIntervalSince1970)
        HelperFunctions().uploadTask(task: task, completion: completion)
//        HelperFunctions().uploadHundredTasks()
    }
    func uploadHundredTasks() {
        
    }
}
