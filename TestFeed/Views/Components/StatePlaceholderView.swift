//
//  StatePlaceholderView.swift
//  TestFeed
//
//  Created by Artem Amaev on 13.11.25.
//

import SwiftUI

struct StatePlaceholderView: View {
    let icon: String
    let title: String
    var buttonTitle: String? = nil
    var onButtonTap: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 12) {
            CircleIconView(systemName: icon)

            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.primaryDark)
                .multilineTextAlignment(.center)

            if let buttonTitle, let onButtonTap {
                AppButton(
                    text: buttonTitle,
                ) {
                    onButtonTap()
                }
                .padding(.top, 4)
            }
        
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
