import UIKit

class TaskDetailsWorker
{
    
    let helperFunctions = HelperFunctions()
    func doSomeWork()
    {
    }
    func removeTask(request: TaskDetails.DeleteTask.Request, completion: @escaping (_ errorProduced: Error?)->Void) {
        helperFunctions.deleteTask(id: request.taskId, completion: completion)
    }
    func updateTask(request: TaskDetails.UpdateTask.Request, completion: @escaping (_ task: Task?, _ errorProduced:Error?)-> Void){
        NotificationsManager().removeScheduledNotification(id: request.task.taskId)
        helperFunctions.uploadTask(task: request.task, completion: completion)
    }
}
