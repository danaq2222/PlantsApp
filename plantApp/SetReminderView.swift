import SwiftUI

struct SetReminderView: View {
    @Environment(\.dismiss) private var dismiss

    var onSave: (Plant) -> Void

    @State private var plantName = ""
    @State private var room = "Bedroom"
    @State private var light = PlantLight.fullSun
    @State private var wateringDays = "Every day"
    @State private var water = "20-50 ml"

    private let rooms = [
        "Bedroom", "Living Room", "Kitchen",
        "Balcony", "Bathroom"
    ]

    private let wateringOptions = [
        "Every day", "Every 2 days", "Every 3 days",
        "Once a week", "Every 10 days", "Every 2 weeks"
    ]

    private let waterAmounts = [
        "20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"
    ]

    private let green = Color(
        red: 51.0 / 255,
        green: 128.0 / 255,
        blue: 105.0 / 255
    )

    private var trimmedName: String {
        plantName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.12), in: Circle())
                }
                .accessibilityLabel("Cancel")

                Spacer()

                Text("Set Reminder")
                    .font(.headline)
                    .foregroundStyle(.white)

                Spacer()

                Button {
                    let plant = Plant(
                        name: trimmedName,
                        room: room,
                        light: light,
                        wateringDays: wateringDays,
                        water: water
                    )

                    onSave(plant)
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(green, in: Circle())
                        .opacity(trimmedName.isEmpty ? 0.4 : 1)
                }
                .disabled(trimmedName.isEmpty)
                .accessibilityLabel("Save Reminder")
            }
            .padding(16)

            ScrollView {
                VStack(spacing: 32) {
                    HStack {
                        Text("Plant Name")
                            .foregroundStyle(.white)

                        TextField("Pothos", text: $plantName)
                            .foregroundStyle(.white)
                            .tint(green)
                    }
                    .padding(16)
                    .background(Color(white: 0.17), in: RoundedRectangle(cornerRadius: 24))

                    VStack(spacing: 0) {
                        optionRow(
                            title: "Room",
                            icon: "location",
                            selection: $room,
                            options: rooms
                        )

                        Divider()
                            .padding(.leading, 16)

                        optionRow(
                            title: "Light",
                            icon: "sun.max",
                            selection: $light,
                            options: PlantLight.allCases,
                            optionLabel: { $0.rawValue }
                        )
                    }
                    .background(Color(white: 0.17), in: RoundedRectangle(cornerRadius: 24))

                    VStack(spacing: 0) {
                        optionRow(
                            title: "Watering Days",
                            icon: "drop",
                            selection: $wateringDays,
                            options: wateringOptions
                        )

                        Divider()
                            .padding(.leading, 16)

                        optionRow(
                            title: "Water",
                            icon: "drop",
                            selection: $water,
                            options: waterAmounts
                        )
                    }
                    .background(Color(white: 0.17), in: RoundedRectangle(cornerRadius: 24))
                }
                .padding(.horizontal, 16)
                .padding(.top, 36)
            }
        }
        .background(Color(white: 0.12).ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    private func optionRow<Option: Hashable>(
        title: String,
        icon: String,
        selection: Binding<Option>,
        options: [Option],
        optionLabel: @escaping (Option) -> String = { String(describing: $0) }
    ) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(.white)

            Spacer()

            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(optionLabel(option))
                        .tag(option)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .tint(.gray)
        }
        .font(.subheadline)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    SetReminderView { _ in }
}
