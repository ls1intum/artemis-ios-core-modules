//
//  ArtemisImageProvider.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 25.10.24.
//

import MarkdownUI
import NetworkImage
import SwiftUI

struct ArtemisImageProvider: ImageProvider {
    static let assetProvider = AssetImageProvider(bundle: .module)
    static let networkProvider = DefaultImageProvider()

    @ViewBuilder
    func makeImage(url: URL?) -> some View {
        if url?.absoluteString.contains("/") == true {
            Self.networkProvider.makeImage(url: url)
        } else {
            Self.assetProvider.makeImage(url: url)
        }
    }
}

struct ArtemisInlineImageProvider: InlineImageProvider {
    static let assetProvider = AssetInlineImageProvider(bundle: .module)

    func image(with url: URL, label: String) async throws -> Image {
        if url.absoluteString.contains("/") {
            // Load image manually here so that we can scale it down to a max width
            let image = try await DefaultNetworkImageLoader.shared.image(from: url)
            let desiredWidth = Double(min(image.width, 220))
            let actualWidth = Double(image.width)
            let scale = actualWidth / desiredWidth
            return Image(image, scale: scale, label: Text(label))
        } else {
            return try await Self.assetProvider.image(with: url, label: label)
        }
    }
}
