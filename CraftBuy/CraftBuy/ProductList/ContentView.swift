//
//  ContentView.swift
//  CraftBuy
//
//  Created by Joshua on 29/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @ObservedObject var viewModel = ProductListViewModel()

    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        setupNavigationBarAppearance()
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HorizontalView(viewModel: viewModel)
                    ProductView(viewModel: viewModel,headingLabel: viewModel.getMostPopularProductTitle())
                    AdvertiseBanner(urlString: viewModel.getAdvertiseImageUrl())
                    CategoriesView(viewModel: viewModel)
                    ProductView(viewModel: viewModel, headingLabel: viewModel.getSecondProductTitle())
                    
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CardButton()
                }
                
                ToolbarItem(placement: .principal) {
                    SearchBar(text: $searchText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NotificationButton()
                }
            }
        }
    }

    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.57, green: 0.78, blue: 0.28, alpha: 1.00)
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
struct CustomView1: View {
    var body: some View {
        Text("Custom View 1")
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
    }
}
struct CardButton: View {
    var body: some View {
        Button(action: {
            // Action for the card button
        }) {
            Image("Image")
                .resizable()
                .frame(width: 26, height: 25)
            
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .frame(maxWidth: .infinity)
    }
}

struct NotificationButton: View {
    var body: some View {
        Button(action: {
            // Action for the notification button
        }) {
            Image(systemName: "bell")
                .foregroundStyle(.white)
        }
    }
}
