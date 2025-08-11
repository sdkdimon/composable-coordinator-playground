import Foundation
import ComposableArchitecture

@CasePathable
public enum RouterAction<Screen, ScreenAction> {
  case onDisapear(StackElementID)
  case stackAction(StackAction<Screen, ScreenAction>)
}

