//
//  NavigationBlockDestinationView.swift
//  TestFeed
//
//  Created by Artem Amaev on 13.11.25.
//

import SwiftUI

struct NavigationBlockDestinationView: View {
    let block: NavigationBlock
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if block.kind != .push {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.primaryBlue)
                    }
                    
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
            }
            
            Spacer(minLength: 0)
            
            if let symbol = block.titleSymbol {
                CircleIconView(systemName: symbol)
            }

            if block.kind != .push {
                Text(block.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.primaryDark)
                    .multilineTextAlignment(.center)
            }

            if let subtitle = block.subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.secondaryBlue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundLight.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(block.kind == .push ? block.title : "")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primaryDark)
            }
        }
        .tint(Color.blue)
        .navigationBarTitleDisplayMode(.inline)
    }
}
