//
//  BlockRoute.swift
//  TestFeed
//
//  Created by Artem Amaev on 13.11.25.
//

import Foundation
import SwiftUI

enum BlockRoute {
    case push(NavigationBlock)
    case modal(NavigationBlock)
    case fullScreen(NavigationBlock)
}
