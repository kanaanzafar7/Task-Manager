import UIKit

protocol TaskDetailsDisplayLogic: AnyObject
{
    func displayTaskDeletedSuccessfully (viewModel: TaskDetails.DeleteTask.TaskDeletedSuccessfully)
    func displayTaskDeletionFailed(viewModel: TaskDetails.DeleteTask.TaskDeletionFailed)
    
    func displayTaskUpdatedSuccessfully(viewModel: TaskDetails.UpdateTask.TaskUpdatedSuccessfully)
    func displayTaskUpdationFailed(viewModel: TaskDetails.UpdateTask.TaskUpdationFailed)
}

class TaskDetailsViewController: UIViewController, TaskDetailsDisplayLogic
{
    var taskId : String?
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var descriptionTaskView: UITextView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var updateTaskButton: UIButton!
    @IBOutlet weak var deleteTaskButton: UIButton!
    
    
    //MARK: - Properties
    var interactor: TaskDetailsBusinessLogic?
    var router: (NSObjectProtocol & TaskDetailsRoutingLogic & TaskDetailsDataPassing)?
    
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
        let interactor = TaskDetailsInteractor()
        let presenter = TaskDetailsPresenter()
        let router = TaskDetailsRouter()
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
        initializeValues()
    }
    
    // MARK: - Methods
   
    func initializeValues (){
        if let task = router?.dataStore?.task {
            taskId = task.taskId
            titleField.text = task.taskTitle
            descriptionTaskView.text = task.taskDescription
            let date = NSDate(timeIntervalSince1970: task.notificationTime) as Date
            datePickerView.date = date
            statusSwitch.isOn = task.isCompleted
        } else {
            print("-----task not found")
        }
    }
    
    func displayTaskDeletedSuccessfully (viewModel: TaskDetails.DeleteTask.TaskDeletedSuccessfully) {
        router?.routeBackToHomeScene()
    }
    func displayTaskDeletionFailed(viewModel: TaskDetails.DeleteTask.TaskDeletionFailed) {
        showDialog(title: "Error deleting \(titleField.text ?? "Task")", message: viewModel.error.localizedDescription)
    }
    
    
    func displayTaskUpdatedSuccessfully(viewModel: TaskDetails.UpdateTask.TaskUpdatedSuccessfully) {
        router?.routeBackToHomeScene()
    }
    func displayTaskUpdationFailed(viewModel: TaskDetails.UpdateTask.TaskUpdationFailed) {
        showDialog(title: "Task updation failed", message: viewModel.error.localizedDescription)
    }
    //MARK: - IBActions
    
    @IBAction func onPressedUpdateTask(_ sender: UIButton) {
        if let title = titleField.text, let descp = descriptionTaskView.text,let dateTime = datePickerView?.date, let isComplete = statusSwitch?.isOn {
            if title.isEmpty || descp.isEmpty {showDialog(title: "Error!", message: "Do not leave any filed empty")} else {
                let task = Task(taskId: taskId!, taskTitle: title, taskDescription: descp, isCompleted: isComplete, notificationTime: dateTime.timeIntervalSince1970)
                interactor?.updateTask(task: task)
                
            }
        }else {
            //            let t
        }
        /*
         let task = Task(taskId: taskId!, taskTitle: titleField.text, taskDescription: descriptionTaskView.text, isCompleted: statusSwitch.isOn, notificationTime: datePickerView.date.timeIntervalSince1970)
         interactor?.updateTask(task: task) */
    }
    @IBAction func onPressedDeleteTask(_ sender: UIButton) {
        showWarningDialog(title: "Are you sure?", message: "Do you really want to delete task?") { action in
            self.interactor?.deleteTask(taskId: self.taskId!)
        }
    }
    
}
