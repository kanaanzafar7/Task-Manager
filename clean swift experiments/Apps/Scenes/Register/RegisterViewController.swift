import UIKit

protocol RegisterDisplayLogic: AnyObject



{
    func successfullyRegistered(viewModelSuccess: Register.SignUp.ViewModelSuccess)
    func failedToRegister(viewModelError: Register.SignUp.ViewModelError)
}

class RegisterViewController: UIViewController, RegisterDisplayLogic
{
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    let activityIndicator = UIActivityIndicatorView()
    var interactor: RegisterBusinessLogic?
    var router: (NSObjectProtocol & RegisterRoutingLogic & RegisterDataPassing)?
    
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
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter()
        let router = RegisterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
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
        print("========\(router?.fetchEmail())")
        doSomething()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
//        let _ =   router?.fetchEmail()
        
    }
    
    func displaySomething(viewModel: Register.SignUp.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    func successfullyRegistered(viewModelSuccess: Register.SignUp.ViewModelSuccess) {
        hideLoading()
       // showDialog(title: "Successfully Registered!", message: "name: \(viewModelSuccess.name)")
        router?.routeToHome(segue: nil, name: viewModelSuccess.name)
    }
    
    func failedToRegister(viewModelError: Register.SignUp.ViewModelError){
        hideLoading()
        showDialog(title: "FailedToRegister!", message: viewModelError.error.localizedDescription)
    }
    
    //MARK: - IBActions
    @IBAction func onPressedLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPressedRegister(_ sender: UIButton) {
        if let name = nameField.text, let email = emailField.text, let password = passwordField.text {
            if name.isEmpty || email.isEmpty || password.isEmpty {
                showDialog(title: "Error!", message: "Any Field cannot be empty")
                return
            }
            register()
        }
        
        else {
            showDialog(title: "Error!", message: "Any field cannot be empty")
        }
    }
    
    //MARK: - Methods
    func register() {
        let request = Register.SignUp.Request(username: nameField.text!, email: emailField.text!, password: passwordField.text!)
        showLoading()
        interactor?.signUp(request: request)
    }
    func showLoading(){
        self.registerButton.showLoading(activityIndicatorView: activityIndicator)
    }
    func hideLoading(){
        self.registerButton.hideLoading(activityIndicatorView: activityIndicator, label: "Register")
    }
}
