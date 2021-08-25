import UIKit

@objc protocol LoginRoutingLogic
{   func routeToRegister(segue: UIStoryboardSegue?, email : String?)
    func routeToHome (segue: UIStoryboardSegue?, name: String)
}

protocol LoginDataPassing
{
    var dataStore: LoginDataStore? { get }
}

class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing
{
    
    
    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?
    
    // MARK: Routing
    
    func routeToHome(segue: UIStoryboardSegue?, name: String) {
        if let segueToHome = segue {
            let destinationVC = segueToHome.destination as! HomeViewController
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
    
    func routeToRegister(segue: UIStoryboardSegue?, email : String?)
    {
        dataStore?.email = email ?? ""
        if let segueToRegister = segue {
            let destinationVC = segueToRegister.destination as! RegisterViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToRegister(source: dataStore!, destination: &destinationDS)
            viewController?.performSegue(withIdentifier: segueToRegister.identifier!, sender: nil)
        } else {
            let storyboard = UIStoryboard(name: "Register", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: Constants.registerScreenId) as! RegisterViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToRegister(source: dataStore!, destination: &destinationDS)
            navigateToRegister(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigateToRegister(source: LoginViewController, destination: RegisterViewController) {
        source.show(destination, sender: nil)
    }
    func navigateToHome(source: LoginViewController, destination: HomeViewController) {
         source.show(destination, sender: nil)
         guard let navigationController = viewController?.navigationController else { return }
         var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
         navigationArray.removeAll() // To remove previous UIViewController
         viewController?.navigationController?.viewControllers = [destination]
    }
    // MARK: Passing data
    func passDataToRegister(source: LoginDataStore, destination: inout RegisterDataStore){
        
        destination.email = source.email
    }
    func passDataToHome(name: String, destination: inout HomeDataStore) {
        destination.name = name
        
    }
}
