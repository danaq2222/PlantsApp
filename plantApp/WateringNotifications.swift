import Foundation
import UserNotifications

enum WateringNotifications {
    private static let center = UNUserNotificationCenter.current()

   
    private static let testMode = false

    static func requestPermission() async -> Bool {
        do {
            let allowed = try await center.requestAuthorization(
                options: [.alert, .sound]
            )

            print("Notification permission granted: \(allowed)")
            return allowed
        } catch {
            print("Could not request notification permission: \(error)")
            return false
        }
    }

    static func schedule(for plant: Plant) async {
        let days: Int

        switch plant.wateringDays {
        case "Every day": days = 1
        case "Every 2 days": days = 2
        case "Every 3 days": days = 3
        case "Once a week": days = 7
        case "Every 10 days": days = 10
        case "Every 2 weeks": days = 14
        default:
            print("Unknown watering frequency: \(plant.wateringDays)")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Time to water \(plant.name) 🌱"
        content.body = "Water amount: \(plant.water)."
        content.sound = .default

        let interval: TimeInterval = testMode ? 10 : TimeInterval(days * 86_400)
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(days * 24 * 60 * 60),
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: notificationID(for: plant.id),
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
            print("Scheduled watering notification: \(request.identifier) in \(interval) seconds")
        } catch {
            print("Could not schedule watering reminder: \(error)")
        }
    }

    static func cancel(for id: UUID) {
        let identifier = notificationID(for: id)
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
    }

    private static func notificationID(for id: UUID) -> String {
        "watering-\(id.uuidString)"
    }
}
