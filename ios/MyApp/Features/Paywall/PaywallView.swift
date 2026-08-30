import SwiftUI

struct PaywallView: View {
	var body: some View {
		VStack(spacing: Theme.Spacing.large) {
			Image(systemName: "star.circle.fill")
				.font(.system(size: 64))
				.foregroundStyle(.yellow)
			Text("Unlock more")
				.font(.title.bold())
			Text("Premium features will be available here.")
				.multilineTextAlignment(.center)
				.foregroundStyle(.secondary)
			PillButton(title: "Maybe later") {}
		}
		.padding(Theme.Spacing.large)
		.presentationDetents([.medium])
	}
}
