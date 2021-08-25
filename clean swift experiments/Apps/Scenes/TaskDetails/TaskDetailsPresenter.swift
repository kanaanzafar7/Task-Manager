
import UIKit

protocol TaskDetailsPresentationLogic
{
  func taskDeletionComplete(response: TaskDetails.DeleteTask.Response)
  func taskUpdationComplete(response: TaskDetails.UpdateTask.Response)
}

class TaskDetailsPresenter: TaskDetailsPresentationLogic
{
  weak var viewController: TaskDetailsDisplayLogic?
  
  // MARK: - Methods
  
    func taskDeletionComplete(response: TaskDetails.DeleteTask.Response) {
        if let error = response.error {
            let viewModel = TaskDetails.DeleteTask.TaskDeletionFailed(error: error)
            viewController?.displayTaskDeletionFailed(viewModel: viewModel)
        } else {
            let viewModel = TaskDetails.DeleteTask.TaskDeletedSuccessfully()
            viewController?.displayTaskDeletedSuccessfully(viewModel: viewModel)
        }
    }
    func taskUpdationComplete(response: TaskDetails.UpdateTask.Response) {
        if let errorProduced  =  response.error {
            let viewModel = TaskDetails.UpdateTask.TaskUpdationFailed(error: errorProduced)
            viewController?.displayTaskUpdationFailed(viewModel: viewModel)
        } else {
            let viewModel = TaskDetails.UpdateTask.TaskUpdatedSuccessfully()
            viewController?.displayTaskUpdatedSuccessfully(viewModel: viewModel)
        }
    }
}
