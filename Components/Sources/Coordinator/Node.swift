import Foundation
import SwiftUI
import IdentifiedCollections

struct Node<V: View, ID: Hashable>: View {
  let state: IdentifiedArrayOf<IdentifiedRouteStyle<ID>>
  let pop: (ID) -> Void
  let buildView: (ID) -> V
  let style: IdentifiedRouteStyle<ID>
  @State var isAppeared = false
  
  var nextStyle: IdentifiedRouteStyle<ID>? {
    guard let index = state.index(id: self.style.id) else { return nil }
    return state[safe: state.index(after: index)]
  }
  
  init(
    state: IdentifiedArrayOf<IdentifiedRouteStyle<ID>>,
    pop: @escaping (ID) -> Void,
    style: IdentifiedRouteStyle<ID>,
    @ViewBuilder
    buildView: @escaping (ID) -> V) {
      self.state = state
      self.pop = pop
      self.style = style
      self.buildView = buildView
    }
  
  private var isActiveBinding: Binding<Bool> {
    return Binding(
      get: { nextStyle != nil },
      set: { isShowing in
        guard !isShowing else { return }
        guard isAppeared else { return }
        guard let nextStyle = nextStyle else { return }
        pop(nextStyle.id)
        //TODO: Called twice so needs somehow to stop calling pop function twice
        //For now just set isAppeared to false to prevent duplicate call of pop function
        isAppeared = false
      }
    )
  }
  
  @ViewBuilder
  var next: some View {
    if let nextStyle = nextStyle {
      Node(
        state: state,
        pop: pop,
        style: nextStyle,
        buildView: buildView
      )
    }
  }
  
  @ViewBuilder
  var content: some View {
    buildView(style.id)
      .pushing(
        isActive: nextStyle?.style == .push ? isActiveBinding : .constant(false),
        destination: next
      )
    //TODO: Add sheet and cover
      .onAppear { isAppeared = true }
      .onDisappear { isAppeared = false }
  }
  
  var body: some View {
    // TODO: Add option to embed or not to embed in NavigationView
    if style.style == .root {
      NavigationView {
        content
      }
      .navigationViewStyle(.stack)
    } else {
      content
    }
  }
}
