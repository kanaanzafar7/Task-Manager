import UIKit

enum TaskDetails
{
    // MARK: Use cases
   enum DeleteTask {
        struct Request {
            let taskId: String
        }
        struct Response {
            let error: Error?
        }
        struct TaskDeletedSuccessfully {}
        struct TaskDeletionFailed {
            let error: Error
        }
    }
    enum UpdateTask {
        struct Request {
            let task: Task
        }
        struct Response{
            let error: Error?
        }
        struct TaskUpdatedSuccessfully {}
        struct TaskUpdationFailed {
            let  error: Error
        }
    }
}
