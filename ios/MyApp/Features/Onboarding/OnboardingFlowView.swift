import SwiftUI

struct OnboardingFlowView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var viewModel = OnboardingViewModel()

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
			TextField("Your name", text: $viewModel.name)
				.textFieldStyle(.roundedBorder)
				.textContentType(.name)
			PillButton(title: "Continue") {
				viewModel.finish()
			}
			.disabled(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
			Spacer()
		}
		.padding(Theme.Spacing.large)
		.navigationBarBackButtonHidden()
		.onAppear {
			viewModel.start(using: modelContext)
		}
	}
}
