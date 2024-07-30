//
//  ProductVierw.swift
//  CraftBuy
//
//  Created by Joshua on 29/07/24.
//

import SwiftUI
import Combine

struct ProductView: View {
    @ObservedObject var viewModel = ProductListViewModel()
    let offerTextColor = Color(red: 0.98, green: 0.48, blue: 0.31)
    var headingLabel:String
    
    var body: some View {
        VStack {
            HStack {
                Text(headingLabel)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("View All")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    if let productDetails = viewModel.getMostPopularProductList() {
                        ForEach(productDetails) { product in
                            ProductCard(product: product)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct ProductCard: View {
    let product: Content
    @StateObject private var imageViewModel = URLImageViewModel()
    
    let offerTextColor = Color(red: 0.98, green: 0.48, blue: 0.31)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 150, height: 220)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            VStack(alignment: .leading) {
                // Product Image
                if let image = imageViewModel.imageModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                } else {
                    ProgressView()
                        .onAppear {
                            imageViewModel.loadImage(from: product.productImage ?? "")
                        }
                }
                
                Text("Sale \(product.discount ?? "")")
                    .frame(width: 80, height: 25)
                    .background(offerTextColor)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .fontWeight(.light)
                    .font(Font.system(size: 12))
                
                // Product Description
                Text(product.productName ?? "")
                    .font(.caption)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(width: 130)
                
                // Product Rating
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= product.productRating ?? 5 ? "star.fill" : "star")
                            .foregroundColor(index <= product.productRating ?? 5 ? .orange : .gray)
                            .frame(width: 7, height: 7)
                    }
                }
                
                HStack() {
                    if product.offerPrice != product.actualPrice {
                        Text(product.offerPrice ?? "")
                            .font(.system(size: 13))
                            .fontWeight(.regular)
                        
                        Text(product.actualPrice ?? "")
                            .strikethrough(true)
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
                            .fontWeight(.regular)
                    } else {
                        Text(product.actualPrice ?? "")
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
                            .fontWeight(.regular)
                    }
                        
                }
                .padding(.top,4)
            }
            .padding(.leading)
        }
    }
}
