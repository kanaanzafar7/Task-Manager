import UIKit
import FirebaseFirestore
enum Home
{
    // MARK: Use cases
    enum FetchTasksList {
        struct Request {}
        struct Response {
//            let documentsList : [DocumentSnapshot]?
            let lastDoc: DocumentSnapshot?
            let taskEntities : [TaskEntity]?
            let error : Error?
            let isFirstPage : Bool?
        }
        struct TasksFetchedSuccessfully {
            let tasksList : [Task]
            let lastDoucment : DocumentSnapshot?
            let isFirstPage : Bool?
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
            let deletedTaskId: String
        }
        struct ErrorDeletingTask {
            let error: Error
        }
        struct TaskDeletedSuccessfully{
            let deletedTaskId: String
        }
    }
}
