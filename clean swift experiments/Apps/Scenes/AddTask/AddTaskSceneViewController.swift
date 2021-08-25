
import UIKit

protocol AddTaskSceneDisplayLogic: AnyObject
{
    func taskUploadedSuccessfully (successViewModel : AddTaskScene.TaskUpload.TaskUploadSuccessModel)
    func taskUploadFailed(failureViewModel: AddTaskScene.TaskUpload.TaskUploadFailedModel)
}

class AddTaskSceneViewController: UIViewController, AddTaskSceneDisplayLogic
{
    //MARK: - IBOutlets
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var addTaskButton: UIButton!
    
    
    
    //MARK: - Properties
    let activityIndicator = UIActivityIndicatorView()
    var interactor: AddTaskSceneBusinessLogic?
    var router: (NSObjectProtocol & AddTaskSceneRoutingLogic & AddTaskSceneDataPassing)?
    
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
        let interactor = AddTaskSceneInteractor()
        let presenter = AddTaskScenePresenter()
        let router = AddTaskSceneRouter()
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
        titleField.delegate = self
        descriptionTextView.delegate = self
    }
    //MARK: IBActions
    @IBAction func onPressedAddTask(_ sender: UIButton) {
        addTask()
    }
    
    
    
    // MARK: Methods
    func showLoading() {
        addTaskButton.showLoading(activityIndicatorView: activityIndicator)
    }
    func hideLoading () {
        addTaskButton.hideLoading(activityIndicatorView: activityIndicator, label: "Add Task")
    }
    func taskUploadedSuccessfully (successViewModel : AddTaskScene.TaskUpload.TaskUploadSuccessModel) {
        hideLoading()
        router?.routeBackToHomeScreen()
    }
    func taskUploadFailed(failureViewModel: AddTaskScene.TaskUpload.TaskUploadFailedModel) {
        hideLoading()
        showDialog(title: "Task Upload Failed", message: failureViewModel.error.localizedDescription)
    }

    
    
    func addTask () {
        if let title = titleField.text, let desc = descriptionTextView.text, let dateTime = dateTimePicker?.date {
            if title.isEmpty || desc.isEmpty {
                showDialog(title: "Error!", message: "Do not leave any field empty")
            } else {
                showLoading()
                interactor?.addTask(title: title, description: desc, dateTime: dateTime)
            }
        }else {}
    }
    
}
extension AddTaskSceneViewController : UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
extension AddTaskSceneViewController : UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.endEditing(true)
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description here"
            textView.textColor = UIColor.gray
        }
    }
}
