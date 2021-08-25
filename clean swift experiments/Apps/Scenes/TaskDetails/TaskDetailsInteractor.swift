import UIKit

protocol TaskDetailsBusinessLogic
{
    func deleteTask(taskId: String)
    func updateTask(task: Task)
}

protocol TaskDetailsDataStore
{
    var task : Task? { get set}
}

class TaskDetailsInteractor: TaskDetailsBusinessLogic, TaskDetailsDataStore
{
    var presenter: TaskDetailsPresentationLogic?
    var worker: TaskDetailsWorker?
    var task: Task?
    // MARK: - Methods
    func deleteTask(taskId: String) {
        worker = TaskDetailsWorker()
        let request = TaskDetails.DeleteTask.Request(taskId: taskId)
        worker?.removeTask(request: request, completion: { errorProduced in
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
