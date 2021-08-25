
import UIKit

protocol HomeDisplayLogic: AnyObject
{
    func displaySomething(viewModel: Home.Something.ViewModel)
    func displayTasksFetched(viewModel: Home.FetchTasksList.TasksFetchedSuccessfully)
    func displayNoTaskFound(viewModel: Home.FetchTasksList.NotaskFound)
    func displayErrorFetchingInTask(viewModel: Home.FetchTasksList.TasksFetchingFailed)
    func displayErrorSigningOut(viewModel: Home.SignOutUser.ErrorSigningOut)
    func displaySuccessfullySignedOut(viewModel: Home.SignOutUser.SuccessfullySignedOut)
    func displayTaskDeletedSuccessfully(viewModel: Home.DeleteTask.TaskDeletedSuccessfully)
    func displayTaskDeletionFailed(viewModel: Home.DeleteTask.ErrorDeletingTask)
}

class HomeViewController: UIViewController, HomeDisplayLogic
{
    
    
    //MARK: -IBOutlets
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: - Properties
    var tasks : [Task] = []
    var signOutButton : UIBarButtonItem?
    var titleLabel = UILabel()
    @IBOutlet weak var tasksTableView: UITableView!
    
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        //        buildNavigationBarButton()
        
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
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = true
        navigationItem.title = "Tasks List"
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        buildNavigationBarButton()
        updateAddButton()
        registerTaskCellWithTableView()
        //        NotificationsManager().askPermissionForNotifications()
        interactor?.askPermission()
        if let name =  router?.getName() {
            print("----name found: \(name)")
            //            fetchTasks()
            
        } else {
            //            print("-----name not found")
            
        }
        
        fetchTasks()
        
        doSomething()
    }
    
    
    
    //MARK: - IBActions
    @IBAction func onAddButtonPressed(_ sender: UIButton) {
        router?.routeToAddTaskScene(segue: nil)
    }
    
    //MARK: - Methods
    func doSomething()
    {
        let request = Home.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Home.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    func fetchTasks(){
        if tasks.isEmpty {
            showLoadingState() }
        interactor?.fetchTasksList()
    }
    
    @objc func onSignOutpressed() {
        
        interactor?.signOutUser()
        //        router?.routeToLoginScene(segue: nil)
        //        print("------pressed")
        /*        var alertView = UIAlertView()
         alertView.addButtonWithTitle("Ok")
         alertView.title = "title"
         alertView.message = "message"
         alertView.show() */
    }
    func buildNavigationBarButton() {
        //        signOutButton.titleLabel?.text = "Sign out"
        //        signOutButton.setTitleColor(UIColor.systemBlue, for: .normal)
        signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(onSignOutpressed))
        self.navigationItem.rightBarButtonItem = signOutButton
    }
    func updateAddButton (){
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
        addButton.clipsToBounds = true
    }
    func registerTaskCellWithTableView (){
        tasksTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: Constants.taskCellNib)
        
    }
    func displayTasksFetched(viewModel: Home.FetchTasksList.TasksFetchedSuccessfully) {
        tasks = viewModel.tasksList
        tasksTableView.isHidden = false
        if !self.titleLabel.isHidden
        { self.titleLabel.isHidden = true
        }
        self.hideLoadingState()
      
        DispatchQueue.main.async {
            self.tasksTableView.reloadData()
        }
     
    
    }
    func displayNoTaskFound(viewModel: Home.FetchTasksList.NotaskFound) {

        hideLoadingState()
        tasksTableView.isHidden = true
        titleLabel.text = "No Task Found"
        titleLabel.frame = self.view.bounds
        titleLabel.center = CGPoint(x: self.view.bounds.size.width / 2.0, y:self.view.bounds.size.height / 2.0)
        self.view.addSubview(titleLabel)
        
    }
    func displayErrorFetchingInTask(viewModel: Home.FetchTasksList.TasksFetchingFailed) {
        print("-----------displayErrorFetchingInTask")

        hideLoadingState()
    }
    func displayErrorSigningOut(viewModel: Home.SignOutUser.ErrorSigningOut) {
        showDialog(title: "Error Signing out", message: viewModel.error.localizedDescription)
    }
    func displaySuccessfullySignedOut(viewModel: Home.SignOutUser.SuccessfullySignedOut) {
//        print()
        router?.routeToLoginScene(segue: nil)
    }
    func displayTaskDeletedSuccessfully(viewModel: Home.DeleteTask.TaskDeletedSuccessfully) {
        print("---++++task deleted successfully")
    }
    func displayTaskDeletionFailed(viewModel: Home.DeleteTask.ErrorDeletingTask) {
        showDialog(title: "Error Deleting Task!", message: viewModel.error.localizedDescription)
    }

}
extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let tableCell : UITableViewCell = UITableViewCell()
        let tableCell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCellNib, for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        tableCell.taskTitleLabel.text = task.taskTitle
        tableCell.taskStatusLabel.text = task.isCompleted ? "Completed" : "Pending"
        tableCell.taskStatusLabel.textColor = task.isCompleted ? UIColor.green : UIColor.red
        return tableCell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        showWarningDialog(title: "Are you sure?", message: "Do you really want to delete task?", okayHandler: { action in
            self.interactor?.deleteTask(taskId: self.tasks[indexPath.row].taskId)
        })
    }
}

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        taskSelected = indexPath.row
        print("------+++++++ \(indexPath.row)")
        router?.routeToTaskDetail(segue: nil, task: tasks[indexPath.row])
    }
    
}