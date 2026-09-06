import Foundation

enum AppDialog: Hashable, Identifiable {
    case networkError
    case loading
    case customAlert(title: String, message: String)
    
    var id: String {
        switch self {
        case .networkError:
            return "dialog-network"
        case .loading:
            return "dialog-loading"
        case .customAlert(let title, _):
            return "dialog-alert-\(title)"
        }
    }
}
