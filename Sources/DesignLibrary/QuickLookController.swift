//
//  SwiftUIView.swift
//  
//
//  Created by Sven Andabaka on 30.04.23.
//

import SwiftUI
import QuickLook

public struct QuickLookController: UIViewControllerRepresentable {

    var url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func updateUIViewController(_ viewController: UINavigationController, context: UIViewControllerRepresentableContext<QuickLookController>) {
        if let controller = viewController.topViewController as? QLPreviewController {
            controller.reloadData()
        }
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        let controller = QLPreviewController()

        controller.dataSource = context.coordinator
        controller.reloadData()
        return UINavigationController(rootViewController: controller)
    }

    public class Coordinator: NSObject, QLPreviewControllerDataSource {
        var parent: QuickLookController

        init(_ qlPreviewController: QuickLookController) {
            self.parent = qlPreviewController
            super.init()
        }
        public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return self.parent.url as QLPreviewItem
        }
    }
}
