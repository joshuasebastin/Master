//
//  CategoriesView.swift
//  CraftBuy
//
//  Created by Joshua on 29/07/24.
//

import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel = ProductListViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Categories")
                    .font(.headline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("View All")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding([.leading, .trailing])
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    if let productDetails = viewModel.getCategoriesProductList() {
                        ForEach(productDetails) { product in
                            CategoryCard(product: product)
                        }
                    } else {
                        ProgressView("Loading categories...")
                    }
                }
                .padding(.leading, 10)
            }
        }
        .padding(.leading, 10)
    }
}

struct CategoryCard: View {
    let product: Content
    @StateObject private var asyncImageViewModel = URLImageViewModel()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            VStack(alignment: .leading) {
                // Product Image
                if let image = asyncImageViewModel.imageModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } else {
                    Image(systemName: "no-image") // Placeholder image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .onAppear {
                            if let imageUrl = product.imageURL {
                                asyncImageViewModel.loadImage(from: imageUrl)
                            }
                        }
                }
                
                Text(product.title ?? "")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .fontWeight(.regular)
            }
            .padding(.leading, 10)
        }
    }
}
