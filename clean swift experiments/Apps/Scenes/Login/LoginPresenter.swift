import UIKit

protocol LoginPresentationLogic
{
    func loginCompleted (response: Login.Login.Response)
}

class LoginPresenter: LoginPresentationLogic
{
    func loginCompleted(response: Login.Login.Response) {
        if let error = response.error {
            let failureViewModel = Login.Login.LoginFailure(loginError: error)
            viewController?.failedToLogin(failureViewModel: failureViewModel)
        } else {
            let name = response.name ?? ""
            let successViewModel = Login.Login.LoginSuccess(name: name)
            viewController?.successfullyLoggedIn(successViewModel: successViewModel)
        }
    }
    
    weak var viewController: LoginDisplayLogic?
    
}
