import UIKit

protocol RegisterPresentationLogic
{
    func presentRegistrationComplete(_: String?, _: Error?) -> Void
}

class RegisterPresenter: RegisterPresentationLogic
{
    func presentRegistrationComplete(_ name: String?, _ error: Error?) {
        if let errorProduced = error {
            let viewModelFailure = Register.SignUp.ViewModelError(error: errorProduced)
            viewController?.failedToRegister(viewModelError: viewModelFailure)
        }else {
            let viewModelSuccess = Register.SignUp.ViewModelSuccess(name: name!)
            viewController?.successfullyRegistered(viewModelSuccess: viewModelSuccess)
        }
    }
    
    
    
    weak var viewController: RegisterDisplayLogic?
    
}
