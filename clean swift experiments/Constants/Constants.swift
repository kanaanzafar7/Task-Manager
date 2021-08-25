//
//  Constants.swift
//  clean swift experiments
//
//  Created by Kanaan Zafar on 20/08/2021.
//

import Foundation
struct Constants {
    static let loginToSignUpSegue = "loginToSignUpSegue"
    static let loginScreenId = "LoginId"
    static let registerScreenId = "RegisterScreenId"
    static let homeScreenId = "homeScreenId"
    static let addTaskSceneID = "addTaskSceneID"
    static let taskCellNib = "taskCell"
    static let taskDetailScreenId = "taskDetailScreenId"
    struct FirestoreKeys {
        static let users = "users"
        static let userName = "userName"
        static let tasksList = "tasksList"
    }
    struct Task {
        static let taskTitle = "taskTitle"
        static let taskDesc = "taskDesc"
        static let notificationTime = "notificationTime"
        static let taskId = "taskId"
        static let isCompleted = "isCompleted"
    }
    
}
