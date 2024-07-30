//
//  HorizontalView.swift
//  CraftBuy
//
//  Created by Joshua on 29/07/24.
//

import SwiftUI

struct HorizontalView: View {
    @State private var currentPage = 0
    @ObservedObject var viewModel = ProductListViewModel()
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                if let productDetails = viewModel.getBannerSlideDetails() {
                    ForEach(productDetails.indices, id: \.self) { index in
                        ProductImageView(product: productDetails[index])
                            .tag(index) // Tag each view with its index
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 170)
            
            if let productDetails = viewModel.getBannerSlideDetails() {
                PageControl(numberOfPages: productDetails.count, currentPage: $currentPage)
                    .frame(height: 30)
                    .padding(.top, 10)
            }
        }
    }
}

struct ProductImageView: View {
    let product: Content
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
                    .onAppear {
                        if let imageUrl = product.imageURL {
                            imageLoader.loadImage(from: URL(string: imageUrl)!)
                        }
                    }
            }
        }
    }
}

// MARK: - Page Control
struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.currentPage = currentPage
        control.addTarget(context.coordinator, action: #selector(Coordinator.updateCurrentPage(sender:)), for: .valueChanged)
        return control
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }

    class Coordinator: NSObject {
        var control: PageControl

        init(_ control: PageControl) {
            self.control = control
        }

        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

// ImageLoader class remains unchanged
class SSLIgnoringSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, credential)
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil

    private var session: URLSession

    init() {
        let delegate = SSLIgnoringSessionDelegate()
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }

    func loadImage(from url: URL) {
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let downloadedImage = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }
        task.resume()
    }
}

