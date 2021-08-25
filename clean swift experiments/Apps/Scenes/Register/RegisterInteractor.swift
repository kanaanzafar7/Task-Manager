import UIKit

protocol RegisterBusinessLogic
{
    //    func doSomething(request: Register.Something.Request)
    func signUp (request: Register.SignUp.Request)
}

protocol RegisterDataStore
{
    //var name: String { get set }
    var email: String {get set}
}

class RegisterInteractor: RegisterBusinessLogic, RegisterDataStore
{
    func signUp(request: Register.SignUp.Request) {
        worker = RegisterWorker()
        worker?.doSignUp(name: request.username, email: request.email, password: request.password, completion: presenter!.presentRegistrationComplete(_:_:))
        
    }
    var presenter: RegisterPresentationLogic?
    var worker: RegisterWorker?
    var email: String = ""
}
