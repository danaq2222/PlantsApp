import SwiftUI

struct ContentView: View {
    @State private var showReminder = false

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

                    Text("""
                    Now all your plants will be in one place and
                    we will help you take care of them :) 🪴
                    """)
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
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                Color(
                                    red: 51.0 / 255,
                                    green: 128.0 / 255,
                                    blue: 105.0 / 255
                                )
                            )
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 40)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .sheet(isPresented: $showReminder) {
            Text("Set Reminder")
                .font(.headline)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
