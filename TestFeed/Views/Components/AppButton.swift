//
//  AppButton.swift
//  TestFeed
//
//  Created by Artem Amaev on 13.11.25.
//

import SwiftUI

struct AppButton: View {
    var text: String
    var symbol: String? = nil
    var onAction: () -> Void
    
    var body: some View {
        Button(action: onAction) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.primaryBlue)
                .frame(maxWidth: .infinity, maxHeight: 44)
                .overlay(
                    Text(text)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white),
                    alignment: .center
                )
                .overlay(alignment: .trailing) {
                    if let symbol = symbol {
                        Image(systemName: symbol)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.trailing, 12)
                    }
                }
        }
    }
}
