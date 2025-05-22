import Foundation

public enum RouteStyle {
  case root
  case push
  //TODO: Add more route styles i.e. sheet cover
}


public struct IdentifiedRouteStyle<ID: Hashable>: Identifiable {
  public let style: RouteStyle
  public let id: ID
  
  public init(style: RouteStyle, id: ID) {
    self.style = style
    self.id = id
  }
}
