
import UIKit
import FirebaseFirestore
import FirebaseAuth
class HomeWorker
{
    let firestoreDB = Firestore.firestore()
    let databaseHelper = DatabaseHelper()
    
    func fetchTasksList(lastDocument : DocumentSnapshot?,  completion: @escaping (_ taskEntitiesList: [TaskEntity]?, _ lastDocument: DocumentSnapshot? ,_ errorProduced: Error?) -> Void){
        
        if let userId = Auth.auth().currentUser?.uid{
            if let lastDoc = lastDocument {
                fetchNextTasks(userId: userId, lastDocument: lastDoc, completion: completion)
                
            } else {
                fetchFirstPage(userId: userId, completion: completion) }
        }
        
    }
    func fetchFirstPage(userId : String,  completion: @escaping (_ taskEntitiesList: [TaskEntity]?,_ lastDocument: DocumentSnapshot?,_  errorProduced: Error?) -> Void){
        firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).collection(Constants.FirestoreKeys.tasksList).order(by: Constants.Task.notificationTime, descending: true).limit(to: 25).addSnapshotListener { querySnapshot, error in
            if let errorProduced = error {
                completion(nil, nil, errorProduced)
            } else {
                if let documentsList = querySnapshot?.documents {
                    let lastDoc : DocumentSnapshot?// = documentsList.last
                    if !documentsList.isEmpty {
                        lastDoc = documentsList.last
                    }else {
                        lastDoc = nil
                    }
                    self.cacheFirstPage(documentsList: documentsList) { entities, error in
                        if let err = error {
                            completion(nil, nil, err)
                        } else {
                            if let taskEntities = entities {
                               
                                completion(taskEntities, lastDoc, nil)
                            } else {
                                completion([], lastDoc, nil)
                            }
                        }
                    }
                    
                } else {
                    completion([],nil,nil)
                }
            }
        }
    }
    func fetchNextTasks(userId : String, lastDocument: DocumentSnapshot, completion: @escaping (_ taskEntitiesList: [TaskEntity]?,_ lastDocument: DocumentSnapshot?,_  errorProduced: Error?) -> Void) {

        firestoreDB.collection(Constants.FirestoreKeys.users).document(userId).collection(Constants.FirestoreKeys.tasksList).order(by: Constants.Task.notificationTime, descending: true).start(afterDocument: lastDocument).limit(to: 25).addSnapshotListener { querySnapshot, error in
            if let err = error {
                
                //                completion(nil, error)
                completion(nil, nil, err)
            } else {
                if let documentsList = querySnapshot?.documents {
                    let lastDoc : DocumentSnapshot?
                    if !documentsList.isEmpty {
                        lastDoc = documentsList.last
                    } else {
                        lastDoc = nil
                    }
                    self.cacheData(documentsList: documentsList) { taskEntities, error in
                        if let err = error {
                            completion(nil,nil,err)
                        } else {
                            
                            if let tasks = taskEntities {
                                
                                completion(tasks, lastDoc, nil)
                            } else {
                                completion([], lastDoc, nil)
                            }
                        }
                        
                    }
                }else {
                    completion([],nil,nil)
                    //                    self.cacheData(documentsList: [], completion: completion)
                } }
        }
    }
    func signOutUser(completion: @escaping (_ errorProduced: Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            databaseHelper.deleteAllInstances { errorOpt in
                if let error = errorOpt {
                    completion(error)
                } else {
                    completion(nil)
                }
            }

        } catch {
            completion(error)
        }
    }
    func permissionForNotifications() {
        NotificationsManager().askPermissionForNotifications()
    }
    
    func deleteTask(request : Home.DeleteTask.Request, completion: @escaping (_ errorProduced: Error?)->Void){
        HelperFunctions().deleteTask(id: request.taskId, completion: completion)
    }
    
    /*   func cacheData(documentsList: [DocumentSnapshot],  completion:@escaping (_ tasksList: [TaskEntity]?, _ errorProduced: Error?)->Void){
     //        databaseHelper.refreshTasksList(documentsList: documentsList, completion: completion)
     databaseHelper.refreshTasksList(documentsList: documentsList) { taskEntities, error in
     if let err = error {
     //                completion(nil,nil,err)
     completion(nil,err)
     } else {
     //                completion(taskEntities, lastd)
     if let entities = taskEntities {
     
     } else {
     completion([], nil)
     }
     }
     }
     } */
    func cacheData(documentsList: [DocumentSnapshot], completion:@escaping (_ tasksList: [TaskEntity]?, _ errorProduced: Error?)->Void) {
        databaseHelper.AddNewTasks(documentsList: documentsList) { taskEntities, error in
            if let err = error {
                completion(nil, err)
            } else {
                if let entities = taskEntities {
                    completion(entities, nil)
                }else {
                    completion([], nil)
                }
            }
        }
    }
    
    func cacheFirstPage(documentsList: [DocumentSnapshot], completion:@escaping (_ tasksList: [TaskEntity]?, _ errorProduced: Error?)->Void) {
        /*
        self.databaseHelper.refreshTasksList(documentsList: documentsList) { tasksEntities, errorProduced in
            if let error = errorProduced {
                completion(nil, error)
            } else {
                if let tasks = tasksEntities {
                    completion(tasks, nil)
                }else {
                    completion([], nil)
                }
            }
        }
        */ databaseHelper.deleteAllInstances { error in
            if let err = error {
                //                completion(nil, nil,err)
                completion(nil, err)
            } else {
                self.databaseHelper.AddNewTasks(documentsList: documentsList, isFirstPage: true) { tasksEntities, errorProduced in
                    if let error = errorProduced {
                        completion(nil, error)
                    } else {
                        if let tasks = tasksEntities {
                            completion(tasks, nil)
                        }else {
                            completion([], nil)
                        }
                      /*  self.databaseHelper.getAllTasks { tasksEntitiesList, errorGettingTasks in
                            if let err = errorGettingTasks {
                               completion(nil, err)
                            } else {
                                if let entities = tasksEntitiesList {
                                    completion(entities, nil)
                                } else {
                                    completion([], nil)
                                }
                            }
                        } */
                    }
                }
            }
        } //*/
        
    }
}
