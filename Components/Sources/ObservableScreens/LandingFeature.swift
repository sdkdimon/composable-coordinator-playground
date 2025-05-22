import SwiftUI
import ComposableArchitecture
import Helpers

@Reducer
public struct LandingFeature {
  @ObservableState
  public struct State {
    var title = "Landing ObservableState"
    var value = 0
    
    public init() {}
    
  }
  
  public enum Action {
    case nextStepTapped
    case incrementTapped
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .nextStepTapped:
        return .none
      case .incrementTapped:
        state.value += 1
        return .none
      }
    }
  }
}

public struct LandingFeatureView: View {
  public let store: StoreOf<LandingFeature>
  
  public init(store: StoreOf<LandingFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      let _ = Self._printChanges()
      VStack(spacing: 20) {
        IntView(value: store.value)
        Button("Increment") {
          store.send(.incrementTapped)
        }
        Button("Next step") {
          store.send(.nextStepTapped)
        }
      }
      .navigationTitle(store.title)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.random())
    }
  }
  
}

