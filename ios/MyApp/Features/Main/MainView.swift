import SwiftUI

struct MainView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel = MainViewModel()

    var body: some View {
        TabView {
            Group {
                if let userID = viewModel.users.first?.id {
                    HomeView(userId: userID)
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("No user found")
                }
            }
            .tabItem { Label("Home", systemImage: "house") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .task {
            do {
                try await viewModel.fetchUsers()
            } catch {
                AppLogger.app.error("Failed to load users: \(error.localizedDescription)")
            }
        }
        .navigationTitle("MyApp")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    guard let userID = viewModel.users.first?.id else { return }
                    router.navigate(to: .profile(userID: userID))
                } label: {
                    Image(systemName: "person.crop.circle")
                }
                .disabled(viewModel.users.first == nil)
            }
        }
    }
}
