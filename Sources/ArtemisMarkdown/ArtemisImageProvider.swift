//
//  ArtemisImageProvider.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 25.10.24.
//

import DesignLibrary
import MarkdownUI
import NetworkImage
import SwiftUI

struct ArtemisImageProvider: ImageProvider {
    static let assetProvider = AssetImageProvider(name: {
        $0.host(percentEncoded: false) ?? ""
    }, bundle: .module)

    @ViewBuilder
    func makeImage(url: URL?) -> some View {
        if url?.absoluteString.contains("local://") == true {
            Self.assetProvider.makeImage(url: url)
        } else {
            if #available(iOS 18.0, *) {
                ImagePreview(url: url)
            } else {
                ArtemisAsyncImage(imageURL: url) {}
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 400, alignment: .leading)
            }
        }
    }
}

@available(iOS 18.0, *)
private struct ImagePreview: View {
    @Namespace private var namespace
    @Environment(\.imagePreviewsEnabled) private var enabled
    let url: URL?
    private let id = UUID()
    @State private var showPreview = false

    var body: some View {
        ArtemisAsyncImage(imageURL: url) {}
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 400, alignment: .leading)
            .matchedTransitionSource(id: id, in: namespace)
            .modifier(ConditionalTapModifier(enabled: enabled) {
                showPreview = true
            })
            .navigationDestination(isPresented: $showPreview) {
                ArtemisAsyncImage(imageURL: url) {}
                    .navigationTransition(.zoom(sourceID: id, in: namespace))
                    .scaledToFit()
            }
    }

    // Only add the gesture if needed, otherwise this may override other tap gestures
    private struct ConditionalTapModifier: ViewModifier {
        let enabled: Bool
        let action: () -> Void

        func body(content: Content) -> some View {
            if enabled {
                content
                    .onTapGesture(perform: action)
            } else {
                content
            }
        }
    }
}

private enum ImagePreviewEnvironmentKey: EnvironmentKey {
    static let defaultValue = false
}

public extension EnvironmentValues {
    var imagePreviewsEnabled: Bool {
        get {
            self[ImagePreviewEnvironmentKey.self]
        }
        set {
            self[ImagePreviewEnvironmentKey.self] = newValue
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
