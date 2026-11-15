import Foundation

struct Plant: Identifiable, Codable {
    var id = UUID()
    var name: String
    var room: String
    var light: PlantLight
    var wateringDays: String
    var water: String
    var isWatered = false
}
enum PlantLight: String, CaseIterable, Codable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case lowLight = "Low Light"

    var icon: String {
        switch self {
        case .fullSun:
            return "sun.max"
        case .partialSun:
            return "sun.haze"
        case .lowLight:
            return "moon"
        }
    }
}
