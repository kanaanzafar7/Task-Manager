import UIKit

protocol TaskDetailsBusinessLogic
{
    func doSomething(request: TaskDetails.Something.Request)
    func deleteTask(taskId: String)
    func updateTask(task: Task)
}

protocol TaskDetailsDataStore
{
    //var name: String { get set }
    var task : Task? { get set}
}

class TaskDetailsInteractor: TaskDetailsBusinessLogic, TaskDetailsDataStore
{
    var presenter: TaskDetailsPresentationLogic?
    var worker: TaskDetailsWorker?
    //var name: String = ""
    var task: Task?
    // MARK: - Methods
    
    func doSomething(request: TaskDetails.Something.Request)
    {
        worker = TaskDetailsWorker()
        worker?.doSomeWork()
        
        let response = TaskDetails.Something.Response()
        presenter?.presentSomething(response: response)
    }
    func deleteTask(taskId: String) {
        worker = TaskDetailsWorker()
        let request = TaskDetails.DeleteTask.Request(taskId: taskId)
        worker?.removeTask(request: request, completion: { errorProduced in
            print("----task deletion Interaction")
            let response = TaskDetails.DeleteTask.Response(error: errorProduced)
            self.presenter?.taskDeletionComplete(response: response)
        })
    }
    func updateTask(task: Task) {
        let request = TaskDetails.UpdateTask.Request(task: task)
        worker?.updateTask(request: request, completion: { task, error in
            let response = TaskDetails.UpdateTask.Response(error: error)
            self.presenter?.taskUpdationComplete(response: response)
        })
    }
}
