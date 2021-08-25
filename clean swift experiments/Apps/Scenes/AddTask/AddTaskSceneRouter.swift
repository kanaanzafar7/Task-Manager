import UIKit

@objc protocol AddTaskSceneRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
    func routeBackToHomeScreen()
}

protocol AddTaskSceneDataPassing
{
  var dataStore: AddTaskSceneDataStore? { get }
}

class AddTaskSceneRouter: NSObject, AddTaskSceneRoutingLogic, AddTaskSceneDataPassing
{
    
  weak var viewController: AddTaskSceneViewController?
  var dataStore: AddTaskSceneDataStore?
  
  // MARK: Routing
    func routeBackToHomeScreen() {
        viewController?.navigationController?.popViewController(animated: true)
  }

  // MARK: Navigation
  // MARK: Passing data
}
