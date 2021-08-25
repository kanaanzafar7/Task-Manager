
import UIKit

protocol AddTaskScenePresentationLogic
{
    func uploadTaskComplete(response: AddTaskScene.TaskUpload.Response)
}

class AddTaskScenePresenter: AddTaskScenePresentationLogic
{
    
    weak var viewController: AddTaskSceneDisplayLogic?
    func uploadTaskComplete(response: AddTaskScene.TaskUpload.Response) {
        if let uploadError = response.error {
            //            viewController
            let failureViewModel = AddTaskScene.TaskUpload.TaskUploadFailedModel(error: uploadError)
            viewController?.taskUploadFailed(failureViewModel: failureViewModel)
        } else {
            let successViewModel = AddTaskScene.TaskUpload.TaskUploadSuccessModel(task: response.task!)
            viewController?.taskUploadedSuccessfully(successViewModel: successViewModel)
        }
    }
    
}
