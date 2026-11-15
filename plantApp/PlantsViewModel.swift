import Foundation
import Observation

@Observable
final class PlantsViewModel {
    private(set) var plants: [Plant] = []
    private let storageKey = "savedPlants"

    init() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }

        do {
            plants = try JSONDecoder().decode([Plant].self, from: data)
        } catch {
            print("Could not load plants: \(error)")
        }
    }

    var completedCount: Int {
        plants.filter { $0.isWatered }.count
    }

    var progress: Double {
        guard !plants.isEmpty else { return 0 }
        return Double(completedCount) / Double(plants.count)
    }

    func addPlant(_ plant: Plant) {
        plants.append(plant)
        savePlants()
        scheduleReminder(for: plant.id)
    }

    func updatePlant(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else {
            return
        }

        plants[index] = plant
        savePlants()
        scheduleReminder(for: plant.id)
    }

    func deletePlant(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        savePlants()
        WateringNotifications.cancel(for: plant.id)
    }

    func toggleWatering(for plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else {
            return
        }

        plants[index].isWatered.toggle()
        savePlants()
    }

    private func scheduleReminder(for id: UUID) {
        Task { @MainActor in
            guard await WateringNotifications.requestPermission(),
                  let plant = plants.first(where: { $0.id == id }) else {
                return
            }

            await WateringNotifications.schedule(for: plant)

            if !plants.contains(where: { $0.id == id }) {
                WateringNotifications.cancel(for: id)
            }
        }
    }

    private func savePlants() {
        do {
            let data = try JSONEncoder().encode(plants)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Could not save plants: \(error)")
        }
    }
}
