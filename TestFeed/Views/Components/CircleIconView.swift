//
//  CircleIconView.swift
//  TestFeed
//
//  Created by Artem Amaev on 13.11.25.
//

import SwiftUI

struct CircleIconView: View {
    var systemName: String
    var iconSize: CGFloat = 24
    var circleSize: CGFloat = 48
    var iconColor: Color = .white
    var circleColor: Color = .primaryBlue
    var weight: Font.Weight = .bold

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: iconSize, weight: weight))
            .foregroundStyle(iconColor)
            .frame(width: circleSize, height: circleSize)
            .background(
                Circle()
                    .fill(circleColor)
            )
    }
}
