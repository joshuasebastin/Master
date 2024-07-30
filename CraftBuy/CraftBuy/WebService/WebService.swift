//
//  WebService.swift
//  CraftBuy
//
//  Created by Joshua on 29/07/24.
//

import Foundation

final class WebService {
    
    static func getUsersData() async throws -> [ProductModel] {
        let urlString = "https://64bfc2a60d8e251fd111630f.mockapi.io/api/Todo"
        guard let url = URL(string: urlString) else {
            throw UserError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
            throw UserError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([ProductModel].self, from: data)
        } catch {
            throw UserError.invalidData
        }
    }
}
