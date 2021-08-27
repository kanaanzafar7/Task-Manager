import UIKit
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }


    @NSManaged public var taskId: String?
    @NSManaged public var taskTitle: String?
    @NSManaged public var taskDesc: String?
    @NSManaged public var notificationTime: Date?
    @NSManaged public var isCompleted: Bool
   
    
}

extension TaskEntity : Identifiable {

}
