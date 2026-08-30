import SwiftUI

struct SplashView: View {
	var body: some View {
		ZStack {
			Color.accentColor.ignoresSafeArea()
			VStack(spacing: Theme.Spacing.medium) {
				Image(systemName: "sparkles")
					.font(.system(size: 56, weight: .semibold))
				Text("MyApp")
					.font(.largeTitle.bold())
			}
			.foregroundStyle(.white)
		}
	}
}
