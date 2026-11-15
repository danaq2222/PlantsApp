import SwiftUI

struct ContentView: View {
    @State private var showReminder = false
    @State private var plantToEdit: Plant?
    @State private var viewModel = PlantsViewModel()

    private let green = Color(
        red: 51.0 / 255,
        green: 128.0 / 255,
        blue: 105.0 / 255
    )

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("My Plants 🌱")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, 16)

                Divider()
                    .overlay(Color.gray.opacity(0.4))

                if viewModel.plants.isEmpty {
                    welcomeView
                } else {
                    plantList
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showReminder) {
            SetReminderView { newPlant in
                viewModel.addPlant(newPlant)
            }
        }
        .sheet(item: $plantToEdit) { plant in
            SetReminderView(existingPlant: plant) { updatedPlant in
                viewModel.updatePlant(updatedPlant)
            }
        }
    }

    private var welcomeView: some View {
        VStack(spacing: 0) {
            Spacer()

            Image("plant")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 220)

            Text("Start your plant journey!")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .padding(.top, 24)

            Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 16)

            Spacer()
                .frame(height: 90)

            Button {
                showReminder = true
            } label: {
                Text("Set Plant Reminder")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .contentShape(Capsule())
                    .glassEffect(.regular.tint(green).interactive(), in: Capsule())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var plantList: some View {
        VStack(spacing: 0) {
            progressHeader

            List {
                ForEach(viewModel.plants) { plant in
                    plantRow(plant)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.black)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                viewModel.deletePlant(plant)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)

            HStack {
                Spacer()

                Button {
                    showReminder = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .contentShape(Circle())
                        .glassEffect(.regular.tint(green).interactive(), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Add Plant")
            }
            .padding(.vertical, 16)
        }
    }

    private var progressHeader: some View {
        VStack(spacing: 12) {
            if viewModel.completedCount == 0 {
                Text("Your plants are waiting for a sip 💦")
            } else {
                Text("\(viewModel.completedCount) of your plants feel loved today ✨")
            }

            ProgressView(value: viewModel.progress)
                .tint(green)
                .animation(.easeInOut, value: viewModel.progress)
                .accessibilityLabel("Watering progress")
        }
        .font(.subheadline)
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 16)
        .padding(.top, 32)
        .padding(.bottom, 36)
    }

    private func plantRow(_ plant: Plant) -> some View {
        HStack(spacing: 8) {
            Button {
                viewModel.toggleWatering(for: plant)
            } label: {
                Image(
                    systemName: plant.isWatered
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.title3)
                .foregroundStyle(plant.isWatered ? Color.mint : Color.gray)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                plant.isWatered
                    ? "Mark \(plant.name) as not watered"
                    : "Mark \(plant.name) as watered"
            )

            VStack(alignment: .leading, spacing: 6) {
                Label("in \(plant.room)", systemImage: "location")
                    .font(.caption)
                    .foregroundStyle(.gray)

                Button {
                    plantToEdit = plant
                } label: {
                    Text(plant.name)
                        .font(.title3)
                        .foregroundStyle(plant.isWatered ? Color.gray : Color.white)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Opens the reminder for editing")

                HStack(spacing: 8) {
                    Label(plant.light.rawValue, systemImage: plant.light.icon)
                        .foregroundStyle(.yellow)

                    Label(plant.water, systemImage: "drop")
                        .foregroundStyle(.cyan)
                }
                .font(.caption2)
            }

            Spacer()
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    ContentView()
}
