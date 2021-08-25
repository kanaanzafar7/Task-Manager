import UIKit

protocol HomeBusinessLogic
{
    func fetchTasksList()
    func signOutUser()
    func askPermission()
    func deleteTask(taskId : String)
}

protocol HomeDataStore
{
    var name: String { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore
{
    func fetchTasksList() {
        worker = HomeWorker()
        worker?.fetchTasksList(completion: { tasksList, error in
            let response = Home.FetchTasksList.Response(tasksList: tasksList, error: error)
            self.presenter?.tasksFetchingComplete(response: response)
            
        })
    }
    
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?
    var name: String = ""
    func signOutUser() {
        worker = HomeWorker()
        worker?.signOutUser(completion: { error in
          
            let response = Home.SignOutUser.Response(error: error)
            self.presenter?.signOutRequestCompleted(response: response)
        })
    }
    func askPermission() {
        worker = HomeWorker()
        worker?.permissionForNotifications()
    }
    func deleteTask(taskId: String) {
        worker = HomeWorker()
        let request = Home.DeleteTask.Request(taskId: taskId)
        worker?.deleteTask(request: request, completion: { deletionError in
            let response = Home.DeleteTask.Response(error: deletionError)
            self.presenter?.taskDeletionComplete(response: response)
        })
    }
}
