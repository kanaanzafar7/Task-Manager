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
            if let taskEntities = response.taskEntities {
                //                let tasksList: [Task] = extractTasksFromDocuments(documentsList: documents)
                let tasksList : [Task] = extractTasksFromTaskEntities(taskEntities: taskEntities)
                if tasksList.isEmpty {
                    let viewModel = Home.FetchTasksList.NotaskFound()
                    viewController?.displayNoTaskFound(viewModel: viewModel)
                } else {
                    //                    let viewModel = Home.FetchTasksList.TasksFetchedSuccessfully(tasksList: tasksList, lastDoucment: documents.last!)
                    let viewModel = Home.FetchTasksList.TasksFetchedSuccessfully(tasksList: tasksList, lastDoucment: response.lastDoc, isFirstPage: response.isFirstPage)
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
            viewController?.displayTaskDeletedSuccessfully(viewModel: Home.DeleteTask.TaskDeletedSuccessfully(deletedTaskId: response.deletedTaskId))
        }
    }
    /* func extractTasksFromDocuments(documentsList: [DocumentSnapshot])-> [Task]{
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
     } */
    func extractTasksFromTaskEntities (taskEntities: [TaskEntity]) -> [Task]{
        var tasksList : [Task] = []
        for taskEntity in taskEntities {
            if let taskId : String = taskEntity.taskId,
               let taskTitle : String = taskEntity.taskTitle,
               let taskDesc : String = taskEntity.taskDesc,
               let taskDateTime : Date = taskEntity.notificationTime
            {
                let isCompleted  = taskEntity.isCompleted
                let task = Task(taskId: taskId, taskTitle: taskTitle, taskDescription: taskDesc, isCompleted: isCompleted, notificationTime: taskDateTime.timeIntervalSince1970)
                tasksList.append(task)
            } else {}
            
        }
        return tasksList
    }
}
