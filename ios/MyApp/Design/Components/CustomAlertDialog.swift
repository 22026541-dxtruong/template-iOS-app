import SwiftUI

struct CustomAlertDialog: View {
    let title: String
    let message: String
    @Environment(AppRouter.self) var router
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
            Text(message)
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
        CustomAlertDialog(title: "Title", message: "Message")
            .environment(AppRouter())
    }
}
