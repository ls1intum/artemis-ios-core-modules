//
//  ZoomableImagePreview.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 14.11.24.
//

import PDFKit
import SwiftUI

// Adapted from https://stackoverflow.com/a/67577296
struct ZoomableImagePreview: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument()
        guard let page = PDFPage(image: image) else { return view }
        view.document?.insert(page, at: 0)
        view.autoScales = true
        DispatchQueue.main.async {
            view.minScaleFactor = max(view.scaleFactorForSizeToFit * 0.8, 0)
            view.maxScaleFactor = view.minScaleFactor + 5
        }
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
