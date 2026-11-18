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
    private let waterColor = Color(red: 0.73, green: 0.85, blue: 0.88)

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
                    if viewModel.hasCompletedWelcome {
                        emptyStateView
                    } else {
                        welcomeView
                    }
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
            SetReminderView(
                existingPlant: plant,
                onDelete: {
                    viewModel.deletePlant(plant)
                }
            ) { updatedPlant in
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

    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer()

            Image(systemName: "bell.slash")
                .font(.system(size: 48))
                .foregroundStyle(Color.mint)

            Text("No reminders set yet")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .padding(.top, 24)

            Text("Add a plant to start tracking its care.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 12)

            Spacer()
                .frame(height: 48)

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
            if viewModel.completedCount == viewModel.plants.count {
                allDoneHeader
            } else {
                progressHeader
            }

            List {
                ForEach(viewModel.sortedPlants) { plant in
                    plantRow(plant)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.black)
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                        .alignmentGuide(.listRowSeparatorTrailing) { dimensions in
                            dimensions.width
                        }
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

    private var allDoneHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(Color.mint)

            Text("All Done! 🎉")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)

            Text("All your plants have been watered.")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 28)
    }

    private var progressHeader: some View {
        VStack(spacing: 12) {
            if viewModel.completedCount == 0 {
                Text("Your plants are waiting for a sip 💦")
            } else {
                Text("\(viewModel.completedCount) of your plants feel loved today ✨")
            }

            GeometryReader { geometry in
                Capsule()
                    .fill(Color(white: 0.16))
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(Color(red: 0.36, green: 0.66, blue: 0.59))
                            .frame(width: geometry.size.width * CGFloat(viewModel.progress))
                    }
                    .animation(.easeInOut, value: viewModel.progress)
            }
            .frame(height: 6)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Watering progress")
            .accessibilityValue(
                Text(viewModel.progress, format: .percent.precision(.fractionLength(0)))
            )
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
                Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
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

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 4) {
                    Image(systemName: "location")
                        .font(.system(size: 10))
                        .accessibilityHidden(true)

                    Text("in \(plant.room)")
                        .font(.caption)
                }
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
                    careBadge(
                        plant.light.rawValue,
                        icon: plant.light.icon,
                        color: Color(red: 0.76, green: 0.71, blue: 0.46)
                    )

                    careBadge(plant.water, icon: "drop", color: waterColor)
                        .overlay {
                            if !plant.isWatered {
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(waterColor.opacity(0.55), lineWidth: 1)
                                    .allowsHitTesting(false)
                            }
                        }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 10)
    }

    private func careBadge(
        _ text: String,
        icon: String,
        color: Color
    ) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .accessibilityHidden(true)

            Text(text)
        }
        .font(.caption2)
        .foregroundStyle(color)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(
            Color(red: 0.11, green: 0.11, blue: 0.13),
            in: RoundedRectangle(cornerRadius: 5)
        )
    }
}

#Preview {
    ContentView()
}
