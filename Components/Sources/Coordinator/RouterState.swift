import Foundation
import ComposableArchitecture

@ObservableState
public struct RouterState<Screen> {
  @ObservationStateIgnored
  var routes: StackState<Screen>
  var routeStyles: IdentifiedArrayOf<IdentifiedRouteStyle<StackElementID>>
  @ObservationStateIgnored
  var routesAlignmentRange: PartialRangeFrom<Int>?
  
  public init(root: Screen) {
    self.routes = .init()
    self.routeStyles = []
    self.append(screen: root, routeStyle: .root)
  }
  
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
  
  public mutating func popToRoot() {
    guard let id = self.routes.ids.first else { return }
    self.pop(to: id)
  }
  
  public mutating func pop(to id: StackElementID) {
    guard let index = self.routes.ids.firstIndex(of: id)
    else { return }
    let rangeToRemove = index.advanced(by: 1)...
    self.routesAlignmentRange = rangeToRemove
    self.routeStyles.removeSubrange(rangeToRemove)
  }
  
  public mutating func onDisappear(id: StackElementID) {
    if let routesAlignmentRange = routesAlignmentRange {
      self.routesAlignmentRange = nil
      self.routes.removeSubrange(routesAlignmentRange)
    }
  }
}
