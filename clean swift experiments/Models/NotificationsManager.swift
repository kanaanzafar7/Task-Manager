
import UIKit
struct NotificationsManager {
    let notificationCenter = UNUserNotificationCenter.current()
    func askPermissionForNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted)
            {
                print("Permission Denied")
            } else {
                print("Permission granted")
            }
        }
    }
    func scheduleNotification (title : String, message : String, date : Date, identifier: String){
        notificationCenter.getNotificationSettings { (settings) in
            
              
                if(settings.authorizationStatus == .authorized)
                {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    
                    let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request) { (error) in
                        if(error != nil)
                        {
                            print("Error " + error.debugDescription)
                            return
                        } else {
                            print("----++++request: \(request.content)")
                        }
                    }
                  }
            
        }
    }
    func removeScheduledNotification(id: String) {
        UNUserNotificationCenter.current()
        .removePendingNotificationRequests(withIdentifiers: [id])
    }
}
