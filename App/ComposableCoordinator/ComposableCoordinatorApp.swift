import SwiftUI
import AppCoordinator
import ComposableArchitecture

@main
struct ComposableCoordinatorApp: App {
  static let store = StoreOf<AppCoordinator>(initialState: .init()) {
      AppCoordinator()
  }
    var body: some Scene {
        WindowGroup {
          WithPerceptionTracking {
            AppCoordinatorView(store: Self.store)
          }
        }
    }
}
