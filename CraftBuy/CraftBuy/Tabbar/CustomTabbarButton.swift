//
//  CustomTabbarButton.swift
//  CraftBuy
//
//  Created by Joshua on 29/07/24.
//

import Foundation
import SwiftUI

struct CustomTabBarButton: View {
    @Binding var isSelected: Bool
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            VStack {
                if isSelected {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 50, height: 50)
                        .offset(y: -20) // Adjust the elevation as needed
                        .shadow(radius: 10)
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                }
                Text("Home")
                    .foregroundColor(isSelected ? .red : .gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
