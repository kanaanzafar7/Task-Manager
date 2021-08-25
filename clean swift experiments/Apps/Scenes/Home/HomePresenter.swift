import UIKit
import FirebaseFirestore
protocol HomePresentationLogic
{
    func tasksFetchingComplete(response : Home.FetchTasksList.Response)
    func signOutRequestCompleted(response: Home.SignOutUser.Response)
    func taskDeletionComplete(response: Home.DeleteTask.Response)
}

class HomePresenter: HomePresentationLogic
{
    weak var viewController: HomeDisplayLogic?
    
    // MARK: - Methods
    func tasksFetchingComplete(response : Home.FetchTasksList.Response) {
        if let error = response.error {
            let failureModel = Home.FetchTasksList.TasksFetchingFailed(error: error)
            viewController?.displayErrorFetchingInTask(viewModel: failureModel)
        } else {
            if let documents = response.documentsList {
                let tasksList: [Task] = extractTasksFromDocuments(documentsList: documents)
                if tasksList.isEmpty {
                    let viewModel = Home.FetchTasksList.NotaskFound()
                    viewController?.displayNoTaskFound(viewModel: viewModel)
                } else {
                    let viewModel = Home.FetchTasksList.TasksFetchedSuccessfully(tasksList: tasksList, lastDoucment: documents.last!)
                    viewController?.displayTasksFetched(viewModel: viewModel)
                }
                
            }
        }
        
    }
    func signOutRequestCompleted(response: Home.SignOutUser.Response) {
        if let error = response.error {
            let failure = Home.SignOutUser.ErrorSigningOut(error: error)
            viewController?.displayErrorSigningOut(viewModel: failure)
        } else {
            let success = Home.SignOutUser.SuccessfullySignedOut()
            viewController?.displaySuccessfullySignedOut(viewModel: success)
        }
    }
    func taskDeletionComplete(response: Home.DeleteTask.Response) {
        if let error = response.error {
            let viewModel = Home.DeleteTask.ErrorDeletingTask(error: error)
            viewController?.displayTaskDeletionFailed(viewModel: viewModel)
        } else {
            viewController?.displayTaskDeletedSuccessfully(viewModel: Home.DeleteTask.TaskDeletedSuccessfully())
        }
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
