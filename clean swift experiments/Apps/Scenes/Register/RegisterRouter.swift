import UIKit

@objc protocol RegisterRoutingLogic
{

        func fetchEmail() -> String
    func routeToHome(segue: UIStoryboardSegue?, name: String)
    
}

protocol RegisterDataPassing
{
    var dataStore: RegisterDataStore? { get }
}

class RegisterRouter: NSObject, RegisterRoutingLogic, RegisterDataPassing
{
    func fetchEmail() -> String {
        let email = dataStore?.email
        return email ?? ""
    }
    
    weak var viewController: RegisterViewController?
    var dataStore: RegisterDataStore?
    
    // MARK: Routing
    
    
    func routeToHome(segue: UIStoryboardSegue?, name: String)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! HomeViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToHome(name: name, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: Constants.homeScreenId) as! HomeViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToHome(name: name, destination: &destinationDS)
            navigateToHome(source: viewController!, destination: destinationVC)
        }
    }
    
    
    // MARK: Navigation
    func navigateToHome(source: RegisterViewController, destination: HomeViewController)
    {
        source.show(destination, sender: nil)
    }
    
    
    // MARK: Passing data
    func passDataToHome(name : String, destination: inout HomeDataStore)
    {
        destination.name = name
    }
    
}
