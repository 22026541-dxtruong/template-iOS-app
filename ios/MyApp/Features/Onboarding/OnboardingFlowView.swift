import SwiftUI

struct OnboardingFlowView: View {
    @AppStorage(AppStorageKeys.hasCompletedOnboarding) private var hasCompletedOnboarding: Bool = false

    @State private var viewModel = OnboardingViewModel()

    @State private var username: String = ""

    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            Spacer()
            Image(systemName: "hand.wave.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.accentColor)
            Text("Welcome to MyApp")
                .font(.largeTitle.bold())
            Text("Tell us your name to get started.")
                .foregroundStyle(.secondary)
            TextField("Your name", text: $username)
                .textFieldStyle(.roundedBorder)
                .textContentType(.name)
            PillButton(title: "Continue") {
                Task {
                    try await viewModel.saveUser(name: username)
                    
                    hasCompletedOnboarding = true
                }
            }
            .disabled(username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            Spacer()
        }
        .padding(Theme.Spacing.large)
        .navigationBarBackButtonHidden()
    }
}
