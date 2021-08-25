//
//  TaskDetailsWorker.swift
//  clean swift experiments
//
//  Created by Kanaan Zafar on 25/08/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class TaskDetailsWorker
{
    
    let helperFunctions = HelperFunctions()
    func doSomeWork()
    {
    }
    func removeTask(request: TaskDetails.DeleteTask.Request, completion: @escaping (_ errorProduced: Error?)->Void) {
        helperFunctions.deleteTask(id: request.taskId, completion: completion)
    }
    func updateTask(request: TaskDetails.UpdateTask.Request, completion: @escaping (_ task: Task?, _ errorProduced:Error?)-> Void){
        NotificationsManager().removeScheduledNotification(id: request.task.taskId)
        helperFunctions.uploadTask(task: request.task, completion: completion)
    }
}
