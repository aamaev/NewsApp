//
//  NavigationBlockView.swift
//  TestFeed
//
//  Created by Artem Amaev on 12.11.25.
//

import SwiftUI

struct NavigationBlockView: View {
    let navigationBlock: NavigationBlock
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 8) {
                if navigationBlock.subtitle == nil {                    
                    CircleIconView(
                        systemName: "star.fill",
                        iconSize: 14,
                        circleSize: 24
                    )
                }
                
                Text(navigationBlock.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.primaryDark)
                
                if let subtitle = navigationBlock.subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.secondaryBlue)
                        .lineLimit(2)
                }
                
                AppButton(
                    text: navigationBlock.buttonTitle,
                    symbol: navigationBlock.buttonSymbol
                ) {
                    onTap?()
                }
                .padding(.top, 8)

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 144)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
