import SwiftUI
import Coordinator
import ComposableArchitecture
import ObservableScreens

@Reducer
public struct AppCoordinator {
  @ObservableState
  public struct State {
    var routerState: RouterState<Screen.State>
    
   public init() {
     self.routerState = .init(root: .landing(.init()))
   }
  }
  
  public enum Action {
    case router(RouterAction<Screen.State, Screen.Action>)
  }
  
  public init() {}
  
  public  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .router(.stackAction(.element(id: _, action: .landing(.nextStepTapped)))):
        state.routerState.push(screen: .step1(.init()))
        return .none
      case .router(.stackAction(.element(id: _, action: .step1(.nextStepTapped)))):
        state.routerState.push(screen: .step2(.init()))
        return .none
      case .router(.stackAction(.element(id: _, action: .step2(.goToRoot)))):
        state.routerState.popToRoot()
        return .none
      
      default:
        return .none
      }
    }
    .routerReducer(\.routerState, action: \.router)
  }
}

public struct AppCoordinatorView: View {
  public let store: StoreOf<AppCoordinator>
  
  public init(store: StoreOf<AppCoordinator>) {
    self.store = store
  }
   
  public var body: some View {
    WithPerceptionTracking {
      TCARouter(store: store.scope(state: \.routerState, action: \.router), buildView: { store in
        WithPerceptionTracking {
          switch store.case {
          case let .landing(store):
            LandingFeatureView(store: store)
          case let .step1(store):
            Step1FeatureView(store: store)
          case let .step2(store):
            Step2FeatureView(store: store)
          }
        }
      })
    }
  }
  
}
