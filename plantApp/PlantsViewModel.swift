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
    }

    func toggleWatering(for plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else {
            return
        }

        plants[index].isWatered.toggle()
        savePlants()
    }

    func deletePlant(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        savePlants()
    }

    func updatePlant(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else {
            return
        }

        plants[index] = plant
        savePlants()
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
