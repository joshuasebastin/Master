//
//  MainTabView.swift
//  CraftBuy
//
//  Created by Joshua on 29/07/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    @ObservedObject var viewModel = ProductListViewModel()
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ContentView(viewModel: viewModel)
                .onAppear {
                    selectedIndex = 0
                }
                .tabItem {
                    VStack {
                        Image("Home")
                        Text("Home")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .tag(0)
            
            Text("Category")
                .onAppear {
                    selectedIndex = 1
                }
                .tabItem {
                    VStack {
                        Image(systemName: "square.grid.2x2.fill")
                        Text("Category")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .tag(1)
            
            Text("Cart")
                .onAppear {
                    selectedIndex = 2
                }
                .tabItem {
                    VStack {
                        Image(systemName: "cart.fill")
                        Text("Cart")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .tag(2)
            
            Text("Offers")
                .onAppear {
                    selectedIndex = 3
                }
                .tabItem {
                    VStack {
                        Image(systemName: "tag.fill")
                        Text("Offers")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .tag(3)
            
            Text("Account")
                .onAppear {
                    selectedIndex = 4
                }
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Profile")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .tag(4)
        }
        .task {
            await viewModel.fetchProducts()
        }
        .alert(isPresented: $viewModel.shouldShowAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.userError?.errorDescription ?? "")
            )
        }
    }
}

#Preview {
    MainTabView()
}

