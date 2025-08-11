import Foundation
import SwiftUI
@_spi(Internals) import ComposableArchitecture

public struct TCARouter<State, Action, V: View>: View {
  @Perception.Bindable var store: Store<RouterState<State>, RouterAction<State, Action>>
  let buildView: (Store<State, Action>) -> V
  
 public init(
  store: Store<RouterState<State>, RouterAction<State, Action>>,
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
        pop: { store.send(.stackAction(.popFrom(id: $0))) },
        onDisappear: { store.send(.onDisapear($0))},
        style: store.routeStyles.first!,
        buildView: { id in
          WithPerceptionTracking {
            if let store = store.scope(state: \.routes[id: id], action: \.stackAction[id: id]) {
              buildView(store)
            }
          }
        }
      )
    }
  }
}
