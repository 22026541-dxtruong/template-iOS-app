import SwiftUI
import Observation

@Observable
@MainActor
class MainViewModel {
    var isLoading = false
    var items: [Item] = []
    
    func loadItems() {
        isLoading = true
        // Simulate a network or database call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.items = [Item(name: "Item 1"), Item(name: "Item 2"), Item(name: "Item 3")]
            self.isLoading = false
        }
    }
}

struct Item: Identifiable {
    let id = UUID()
    let name: String
}