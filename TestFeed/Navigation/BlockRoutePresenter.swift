//
//  BlockRoutePresenter.swift
//  TestFeed
//
//  Created by Artem Amaev on 13.11.25.
//

import SwiftUI

struct BlockRoutePresenter: ViewModifier {
    @Binding var route: BlockRoute?

    private var pushBinding: Binding<NavigationBlock?> {
        Binding<NavigationBlock?>(
            get: {
                if case .push(let b) = route { return b }
                return nil
            },
            set: { newValue in
                route = newValue.map { .push($0) }
            }
        )
    }

    private var modalBinding: Binding<NavigationBlock?> {
        Binding<NavigationBlock?>(
            get: {
                if case .modal(let b) = route { return b }
                return nil
            },
            set: { newValue in
                route = newValue.map { .modal($0) }
            }
        )
    }

    private var fullBinding: Binding<NavigationBlock?> {
        Binding<NavigationBlock?>(
            get: {
                if case .fullScreen(let b) = route { return b }
                return nil
            },
            set: { newValue in
                route = newValue.map { .fullScreen($0) }
            }
        )
    }

    func body(content: Content) -> some View {
        content
            .navigationDestination(item: pushBinding) {
                NavigationBlockDestinationView(block: $0)
            }
            .sheet(item: modalBinding) {
                NavigationBlockDestinationView(block: $0)
            }
            .fullScreenCover(item: fullBinding) {
                NavigationBlockDestinationView(block: $0)
            }
    }
}
