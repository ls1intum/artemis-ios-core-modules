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
    static let assetProvider = AssetImageProvider(name: {
        $0.host(percentEncoded: false) ?? ""
    }, bundle: .module)
    static let networkProvider = DefaultImageProvider()

    @ViewBuilder
    func makeImage(url: URL?) -> some View {
        if url?.absoluteString.contains("local://") == true {
            Self.assetProvider.makeImage(url: url)
        } else {
            Self.networkProvider.makeImage(url: url)
        }
    }
}

struct ArtemisInlineImageProvider: InlineImageProvider {
    static let assetProvider = AssetInlineImageProvider(name: {
        $0.host(percentEncoded: false) ?? ""
    }, bundle: .module)

    func image(with url: URL, label: String) async throws -> Image {
        if url.absoluteString.contains("local://") {
            return try await Self.assetProvider.image(with: url, label: label)
        } else {
            // Load image manually here so that we can scale it down to a max width
            let image = try await DefaultNetworkImageLoader.shared.image(from: url)
            let desiredWidth = Double(min(image.width, 220))
            let actualWidth = Double(image.width)
            let scale = actualWidth / desiredWidth
            return Image(image, scale: scale, label: Text(label))
        }
    }
}
