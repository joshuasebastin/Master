//
//  AdvertiseBanner.swift
//  CraftBuy
//
//  Created by Joshua on 30/07/24.
//

import SwiftUI
import Combine

struct AdvertiseBanner: View {
    @StateObject private var viewModel = URLImageViewModel()
    let urlString: String

    var body: some View {
        VStack {
            if let image = viewModel.imageModel.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(height: 150)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            } else {
                ProgressView()
                    .frame(height: 150)
            }
        }
        .padding(.leading)
        .padding(.trailing)
        .onAppear {
            viewModel.loadImage(from: urlString)
        }
    }
}

struct URLImageModel {
    var image: UIImage?
}

class URLSessionDelegateHandler: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

class URLImageViewModel: ObservableObject {
    @Published var imageModel = URLImageModel()
    private var cancellable: AnyCancellable?
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default, delegate: URLSessionDelegateHandler(), delegateQueue: nil)
        
        cancellable = session.dataTaskPublisher(for: url)
            .map { URLImageModel(image: UIImage(data: $0.data)) }
            .replaceError(with: URLImageModel(image: nil))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error loading image: \(error)")
                }
            }, receiveValue: { [weak self] imageModel in
                self?.imageModel = imageModel
            })
    }
}

