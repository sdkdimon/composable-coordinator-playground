import Foundation
import SwiftUI
import ComposableArchitecture

public struct TCARouter<State, Action, V: View>: View {
  let store: Store<RouterState<State>, StackAction<State, Action>>
  let buildView: (Store<State, Action>) -> V
  
 public init(
  store: Store<RouterState<State>, StackAction<State, Action>>,
  @ViewBuilder buildView: @escaping (Store<State, Action>) -> V
 )
  {
    self.store = store
    self.buildView = buildView
  }
  
  public var body: some View {
    WithPerceptionTracking {
      Node(
        state: store.routeStyles,
        pop: { store.send(.popFrom(id: $0) ) },
        style: store.routeStyles.first!,
        buildView: { id in
          WithPerceptionTracking {
            if let store = store.scope(state: \.routes[id: id], action: \.[id: id]) {
              buildView(store)
            }
          }
        }
      )
    }
  }
}
