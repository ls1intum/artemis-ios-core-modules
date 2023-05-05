//
//  ArtemisAsyncImage.swift
//  
//
//  Created by Sven Andabaka on 05.05.23.
//

import SwiftUI
import Kingfisher

public struct ArtemisAsyncImage<Content: View>: View {

    private let imageURL: URL?
    private let errorPlaceholder: () -> Content
    private let onFailure: ((KingfisherError) -> Void)?
    private let onProgress: ((Int64, Int64) -> Void)?
    private let onSuccess: ((RetrieveImageResult) -> Void)?

    @State private var imageLoadingError = false

    var requestModifier = AnyModifier { request in
        var newRequest = request
        if let cookies = URLSession.shared.authenticationCookie {
            newRequest.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
        }
        return newRequest
    }

    public init(imageURL: URL?,
                onFailure: ((KingfisherError) -> Void)? = nil,
                onProgress: ((Int64, Int64) -> Void)? = nil,
                onSuccess: ((RetrieveImageResult) -> Void)? = nil,
                @ViewBuilder errorPlaceholder: @escaping () -> Content) {
        self.imageURL = imageURL
        self.errorPlaceholder = errorPlaceholder
        self.onFailure = onFailure
        self.onSuccess = onSuccess
        self.onProgress = onProgress
    }

    public var body: some View {
        if imageLoadingError {
            errorPlaceholder()
        } else {
            KFImage.url(imageURL)
                .requestModifier(requestModifier)
                .placeholder {
                    ProgressView()
                        .frame(width: 200, height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray)
                        )
                }
                .onFailure { error in
                    imageLoadingError = true
                    onFailure?(error)
                }
                .onSuccess { retrieveImageResult in
                    imageLoadingError = false
                    onSuccess?(retrieveImageResult)
                }
                .onProgress { receivedSize, totalSize in
                    onProgress?(receivedSize, totalSize)
                }
                .resizable()
        }
    }
}
