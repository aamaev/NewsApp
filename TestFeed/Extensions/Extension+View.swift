//
//  Extension+View.swift
//  TestFeed
//
//  Created by Artem Amaev on 13.11.25.
//

import SwiftUI

extension View {
    func presentBlockRoute(_ route: Binding<BlockRoute?>) -> some View {
        modifier(BlockRoutePresenter(route: route))
    }
}
