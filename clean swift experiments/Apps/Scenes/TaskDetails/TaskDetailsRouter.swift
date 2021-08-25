
import UIKit

@objc protocol TaskDetailsRoutingLogic
{
    func routeBackToHomeScene()
}

protocol TaskDetailsDataPassing
{
    var dataStore: TaskDetailsDataStore? { get }
}

class TaskDetailsRouter: NSObject, TaskDetailsRoutingLogic, TaskDetailsDataPassing
{
    weak var viewController: TaskDetailsViewController?
    var dataStore: TaskDetailsDataStore?
    
    // MARK: Routing
    func routeBackToHomeScene() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
