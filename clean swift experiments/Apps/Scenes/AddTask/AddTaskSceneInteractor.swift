import UIKit

protocol AddTaskSceneBusinessLogic
{
    func addTask(title : String, description : String, dateTime : Date)
}

protocol AddTaskSceneDataStore
{
    
}

class AddTaskSceneInteractor: AddTaskSceneBusinessLogic, AddTaskSceneDataStore
{
    var presenter: AddTaskScenePresentationLogic?
    var worker: AddTaskSceneWorker?
    //MARK: - Add Task
    func addTask(title : String, description : String, dateTime : Date) {
        let request = AddTaskScene.TaskUpload.Request(title: title, description: description, notificationTime: dateTime)
        worker = AddTaskSceneWorker()
        worker?.uploadTask(request: request, completion: { task, error in
            let response = AddTaskScene.TaskUpload.Response(task: task, error: error)
            self.presenter?.uploadTaskComplete(response: response)
        })
        
    }
    
  
}
