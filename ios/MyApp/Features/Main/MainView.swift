import SwiftUI

struct MainView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel = MainViewModel()

    var body: some View {
        @Bindable var router = router
        
        TabView(selection: $router.selectedTab) {
            Group {
                if let userID = viewModel.users.first?.id {
                    HomeView(userId: userID)
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("No user found")
                }
            }
            .tag(AppTab.home)
            .tabItem { Label(AppTab.home.title, systemImage: AppTab.home.iconName) }
            
            SettingsView()
                .tag(AppTab.settings)
                .tabItem { Label(AppTab.settings.title, systemImage: AppTab.settings.iconName) }
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
