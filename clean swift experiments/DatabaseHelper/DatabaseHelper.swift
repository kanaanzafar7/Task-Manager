import UIKit
import FirebaseFirestore
import CoreData
struct DatabaseHelper {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllTasks(completion: @escaping (_ tasksList: [TaskEntity]?, _ errorProduced: Error?)->Void) {
        do {
            //            let predicate = NSPredicate(
            
            let tasksList: [TaskEntity] = try context.fetch(TaskEntity.fetchRequest())
            completion(tasksList, nil)
        } catch {
            completion(nil,error)
        }
    }
    func AddNewTasks(documentsList : [DocumentSnapshot], isFirstPage : Bool? = false, completion: @escaping (_ tasksList : [TaskEntity]?, _ errorProduced: Error?)->Void){
        do {try context.save()}catch {}
        var entities : [TaskEntity] = []
        for document in  documentsList {
            let data : [String: Any]? = document.data()
            if let id : String = data?[Constants.Task.taskId] as? String,
               let title : String = data?[Constants.Task.taskTitle] as? String,
               let description: String = data?[Constants.Task.taskDesc] as? String,
               let notificationtime : TimeInterval = data?[Constants.Task.notificationTime] as? TimeInterval{
                let isCompleted = data?[Constants.Task.isCompleted] as? Bool ?? false
                let newTaskEntity = TaskEntity(context: context)
                newTaskEntity.taskId = id
                newTaskEntity.taskTitle = title
                newTaskEntity.taskDesc = description
                newTaskEntity.isCompleted = isCompleted
                newTaskEntity.notificationTime = NSDate(timeIntervalSince1970: notificationtime) as Date
                entities.append(newTaskEntity)
            }
        }
        do {
            try context.save()
            //            getAllTasks(completion: completion)
            //    completion(
           /* if let _ = isFirstPage {
                getAllTasks(completion: completion)
            } else { */
                
                completion(entities,nil) //}
        } catch {
            completion(nil, error)
        }
    }
    //    func fetchFirstPage() {}
    //    func test(param: Int? = nil)
    func deleteAllInstances(completion: @escaping (_ errorProduced : Error?) -> Void) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        getAllTasks { tasksList, error in
            if let err = error {
                print("-----errorDeletingInstances: \(err.localizedDescription)")
            }
            else {
                print("-----count in deleteAllInstances: \(tasksList?.count)")
            }
        }
        do {
            try context.execute(deleteRequest)
            completion(nil)
        } catch {
            print("------errorDeletingInstances: \(error.localizedDescription)")
            completion(error)
        }
    }
    
}

