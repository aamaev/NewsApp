//
//  NewsSegmentedPicker.swift
//  TestFeed
//
//  Created by Artem Amaev on 13.11.25.
//

import SwiftUI
import UIKit

struct NewsSegmentedPicker: UIViewRepresentable {
    @Binding var selection: NewsTab

    func makeUIView(context: Context) -> UISegmentedControl {
        let items = NewsTab.allCases.map { $0.rawValue }

        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = NewsTab.allCases.firstIndex(of: selection) ?? 0

        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        control.backgroundColor = UIColor(Color.backgroundLight)
        control.selectedSegmentTintColor = UIColor.white

        control.setTitleTextAttributes([
            .foregroundColor: UIColor(Color.primaryDark),
            .font: UIFont.systemFont(ofSize: 15, weight: .regular)
        ], for: .normal)

        control.setTitleTextAttributes([
            .foregroundColor: UIColor(Color.primaryDark),
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ], for: .selected)

        control.layer.cornerRadius = 8
        control.clipsToBounds = true

        control.translatesAutoresizingMaskIntoConstraints = false
        control.heightAnchor.constraint(equalToConstant: 40).isActive = true

        return control
    }

    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        let index = NewsTab.allCases.firstIndex(of: selection) ?? 0
        if uiView.selectedSegmentIndex != index {
            uiView.selectedSegmentIndex = index
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject {
        var parent: NewsSegmentedPicker

        init(_ parent: NewsSegmentedPicker) {
            self.parent = parent
        }

        @objc
        func valueChanged(_ sender: UISegmentedControl) {
            let idx = sender.selectedSegmentIndex
            guard idx >= 0 && idx < NewsTab.allCases.count else { return }
            parent.selection = NewsTab.allCases[idx]
        }
    }
}
