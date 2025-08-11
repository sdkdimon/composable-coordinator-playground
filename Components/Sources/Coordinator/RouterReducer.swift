import Foundation
import ComposableArchitecture

//public struct _RouterReducer<Base: Reducer, Destination: Reducer>: Reducer {
//  let base: Base
//  let toStackState: WritableKeyPath<Base.State, RouterState<Destination.State>>
//  let toStackAction: AnyCasePath<Base.Action, StackAction<Destination.State, Destination.Action>>
//  let destination: Destination
//  
//  
//  init(
//    base: Base,
//    toStackState: WritableKeyPath<Base.State, RouterState<Destination.State>>,
//    toStackAction: AnyCasePath<Base.Action, StackAction<Destination.State, Destination.Action>>,
//    destination: Destination
//  ) {
//    self.base = base
//    self.toStackState = toStackState
//    self.toStackAction = toStackAction
//    self.destination = destination
//  }
//  
//  public func reduce(into state: inout Base.State, action: Base.Action) -> Effect<Base.Action> {
//    return .none
//  }
//}

extension Reducer {
  public func routerReducer<DestinationState: CaseReducerState, DestinationAction>
  (_ toStackState: WritableKeyPath<State, RouterState<DestinationState>>,
    action toStackAction: CaseKeyPath<Action, RouterAction<DestinationState, DestinationAction>>,
  ) -> some ReducerOf<Self> where DestinationState.StateReducer.Action == DestinationAction {
    Reduce { state, action in
      switch AnyCasePath(toStackAction).extract(from: action) {
      case let .stackAction(.popFrom(id: id)):
        state[keyPath: toStackState].pop(from: id)
      case let .onDisapear(id):
        state[keyPath: toStackState].onDisappear(id: id)
      default:
        break
      }
      return self.reduce(into: &state, action: action)
    }
    .forEach(toStackState.appending(path: \.routes), action: toStackAction.appending(path: \.stackAction))
  }
}
