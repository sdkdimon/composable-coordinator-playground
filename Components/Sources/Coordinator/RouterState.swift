import Foundation
import ComposableArchitecture

@ObservableState
public struct RouterState<Screen> {
  @ObservationStateIgnored
  var routes: StackState<Screen>
  var routeStyles: IdentifiedArrayOf<IdentifiedRouteStyle<StackElementID>>
  
  public init(root: Screen) {
    self.routes = .init()
    self.routeStyles = []
    self.append(screen: root, routeStyle: .root)
  }
  
//  func next(after elemId: StackElementID) -> StackElementID? {
//    return routes.next(after: elemId)
//  }
  
  mutating func append(screen: Screen, routeStyle: RouteStyle) {
    routes.append(screen)
    guard let id = routes.ids.last else {
      reportIssue("Somethig goes wrong id must be presented in the routes stack")
      return
    }
    routeStyles[id: id] = .init(style: routeStyle, id: id)
  }
  
  public mutating func push(screen: Screen) {
    self.append(screen: screen, routeStyle: .push)
  }
  
  //TODO: Split internal pop from public - public pop must poping both routeStyles and routes
  public mutating func pop(from id: StackElementID) {
    self.routeStyles[id: id] = nil
  }
}

//extension StackState {
//  func next(after elemId: StackElementID) -> StackElementID? {
//    if let index = self.ids.firstIndex(of: elemId) {
//      if let nextElem = self.ids[safe: index + 1] {
//        return nextElem
//      }
//    }
//    return nil
//  }
//}
