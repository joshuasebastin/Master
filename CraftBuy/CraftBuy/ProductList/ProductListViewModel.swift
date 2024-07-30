//
//  ProductListViewModel.swift
//  CraftBuy
//
//  Created by Joshua on 29/07/24.
//

import Foundation
import SwiftUI

@MainActor
final class ProductListViewModel: ObservableObject {
    
    @Published var products: [ProductModel]?
    @Published var userError: UserError?
    @Published var shouldShowAlert = false
    @Published var isLoading = false
    
    func fetchProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            self.products = try await WebService.getUsersData()
        } catch {
            userError = UserError.custom(error: error)
            shouldShowAlert = true
        }
    }
    
    private func filterProducts(by type: String) -> [Content]? {
        guard let products = products, !products.isEmpty else { return nil }
        return products.first { $0.type == type }?.contents
    }
    
    func getCategoriesProductList() -> [Content]? {
        return filterProducts(by: "catagories")
    }
    
    func getMostPopularProductList() -> [Content]? {
        return filterProducts(by: "products")
    }
    
    func getMostPopularProductTitle() -> String {
        return products?.first { $0.type == "products" }?.title ?? ""
    }
    
    func getSecondProductTitle() -> String {
        let mostPopularTitle = getMostPopularProductTitle()
        return products?.first { $0.type == "products" && $0.title != mostPopularTitle }?.title ?? ""
    }
    
    func getBannerSlideDetails() -> [Content]? {
        return filterProducts(by: "banner_slider")
    }
    func getBanneraddBanner() -> [ProductModel]? {
        guard let products = products, !products.isEmpty else { return nil }
        return products.filter {$0.type == "banner_single"}
        
    }
    
    func getAdvertiseImageUrl() -> String {
        return getBanneraddBanner()?.first?.imageURL ?? ""
    }
}

