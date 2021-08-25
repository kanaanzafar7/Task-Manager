import UIKit

enum Home
{
    // MARK: Use cases
    enum FetchTasksList {
        struct Request {}
        struct Response {
            let tasksList : [Task]?
            let error : Error?
        }
        struct TasksFetchedSuccessfully {
            let tasksList : [Task]
        }
        struct TasksFetchingFailed {
            let error : Error
        }
        struct NotaskFound {
        }
    }
    
    
    enum SignOutUser {
        struct Request {}
        struct Response {
            let error : Error?
        }
        struct ErrorSigningOut {
            let error : Error
        }
        struct  SuccessfullySignedOut {
            
        }
    }
    
    
    enum DeleteTask {
        struct Request {
            let taskId : String
        }
        struct Response {
            let error : Error?
        }
        struct ErrorDeletingTask {
            let error: Error
        }
        struct TaskDeletedSuccessfully{}
    }
}
