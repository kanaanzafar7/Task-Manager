import UIKit

protocol LoginPresentationLogic
{
    func presentSomething(response: Login.Something.Response)
    func loginCompleted (response: Login.Login.Response)
}

class LoginPresenter: LoginPresentationLogic
{
    func loginCompleted(response: Login.Login.Response) {
        if let error = response.error {
            //failure state
            let failureViewModel = Login.Login.LoginFailure(loginError: error)
            viewController?.failedToLogin(failureViewModel: failureViewModel)
        } else {
            // success state
            let name = response.name ?? ""
            let successViewModel = Login.Login.LoginSuccess(name: name)
            viewController?.successfullyLoggedIn(successViewModel: successViewModel)
        }
    }
    
    weak var viewController: LoginDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Login.Something.Response)
    {
        let viewModel = Login.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
