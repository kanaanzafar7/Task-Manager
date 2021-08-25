import UIKit

enum AddTaskScene
{
    // MARK: Use cases
    enum TaskUpload {
        struct Request {
            let title : String
            let description : String
            let notificationTime : Date
        }
        struct Response {
            let task : Task?
            let error : Error?
        }
        struct TaskUploadSuccessModel {
            let task : Task
        }
        struct  TaskUploadFailedModel {
            let error : Error
        }
    }
}
