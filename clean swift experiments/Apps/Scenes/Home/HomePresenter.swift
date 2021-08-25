import UIKit

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
            let tasks : [Task] = response.tasksList ?? []
            if tasks.isEmpty {
                let noTaskFoundModel = Home.FetchTasksList.NotaskFound()
                viewController?.displayNoTaskFound(viewModel: noTaskFoundModel)
            } else {
                let successModel = Home.FetchTasksList.TasksFetchedSuccessfully(tasksList: tasks)
                viewController?.displayTasksFetched(viewModel: successModel)
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
}
