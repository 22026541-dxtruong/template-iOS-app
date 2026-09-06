import SwiftUI

struct NetworkErrorDialog: View {
    @Environment(AppRouter.self) var router
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Network Error")
                .font(.headline)
            Text("Please check your internet connection.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Button("Close") {
                router.dismissDialog()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 20)
        .padding(40)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()
        NetworkErrorDialog()
            .environment(AppRouter())
    }
}
