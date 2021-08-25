import UIKit

protocol HomeRoutingLogic
{
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    func routeToAddTaskScene(segue: UIStoryboardSegue?)
    func getName() -> String?
    func routeToLoginScene (segue: UIStoryboardSegue?)
    func routeToTaskDetail(segue: UIStoryboardSegue?, task : Task)
}

protocol HomeDataPassing
{
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing
{
    
    
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    // MARK: - GetName
    func getName() -> String? {
        let name = dataStore?.name
        return name
    }
    // MARK: Routing
    
    func routeToAddTaskScene(segue: UIStoryboardSegue?) {
        if let _ = segue {}else {
            let storyboard = UIStoryboard(name: "AddTask", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(identifier: Constants.addTaskSceneID) as! AddTaskSceneViewController
            //            var destinationDS = destinationVC.router?.dataStore!
            navigateToAddTaskScene(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToLoginScene (segue: UIStoryboardSegue?) {
        if let _ = segue {} else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: Constants.loginScreenId) as! LoginViewController
            navigateToLoginScene(source: viewController!, destination: destinationVC)
        }
    }
    func routeToTaskDetail(segue: UIStoryboardSegue?, task: Task) {
        if let _ = segue {} else {
            let storyboard = UIStoryboard(name: "TaskDetails", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(identifier: Constants.taskDetailScreenId) as! TaskDetailsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToTaskDetailsScene(task: task, destination: &destinationDS)
            navigateToTaskDetailsScene(source: viewController!, destination: destinationVC)
        }
        
    }
    // MARK: Navigation
    func navigateToAddTaskScene(source: HomeViewController, destination: AddTaskSceneViewController) {
        source.show(destination, sender: nil)
    }
    func navigateToLoginScene (source: HomeViewController, destination: LoginViewController){
        source.show(destination, sender: nil)
        guard let navigationController = viewController?.navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        navigationArray.removeAll() // To remove previous UIViewController
        viewController?.navigationController?.viewControllers = [destination]
    }
    func navigateToTaskDetailsScene (source: HomeViewController, destination: TaskDetailsViewController){
        source.show(destination, sender: nil)
    }
    //func navigateToSomewhere(source: HomeViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    func passDataToTaskDetailsScene(task: Task, destination: inout TaskDetailsDataStore){
        destination.task = task
    }
    
    //func passDataToSomewhere(source: HomeDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
