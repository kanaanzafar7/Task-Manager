import UIKit

protocol LoginDisplayLogic: AnyObject
{
    func successfullyLoggedIn(successViewModel: Login.Login.LoginSuccess)
    func failedToLogin(failureViewModel: Login.Login.LoginFailure)
}

class LoginViewController: UIViewController, LoginDisplayLogic
{
    //MARK: - Properties
    let activityIndicator = UIActivityIndicatorView()
    //MARK: IBOutlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {   if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK: - Methods
    func successfullyLoggedIn(successViewModel: Login.Login.LoginSuccess) {
        hideLoading()
        router?.routeToHome(segue: nil, name: successViewModel.name)
    }
    func failedToLogin(failureViewModel: Login.Login.LoginFailure) {
        hideLoading()
        showDialog(title: "Failed To Login", message: failureViewModel.loginError.localizedDescription)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func onSignUpPressed(_ sender: UIButton) {
        
//        let segue = UIStoryboardSegue(identifier: Constants.loginToSignUpSegue, source: self, destination: RegisterViewController())
        
        router?.routeToRegister(segue: nil, email: emailField.text)
    }
    
    @IBAction func onLoginPressed(_ sender: UIButton) {
        login()
    }
    
    
    //MARK: - Methods
    func login() {
        if let email = emailField.text, let password = passwordField.text{
            if email.isEmpty || password.isEmpty {
                showDialog(title: "Error!", message: "Do not leave any field empty")
            } else {
                let request = Login.Login.Request(email: email, password: password)
                interactor?.doLogin(request: request)
                showLoading()
                
            }
        }else {}
    }
    func showLoading(){
        self.loginButton.showLoading(activityIndicatorView: activityIndicator)
    }
    func hideLoading(){
        self.loginButton.hideLoading(activityIndicatorView: activityIndicator, label: "Login")
    }
}
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
