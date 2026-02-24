//
//  SAML2LoginView.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 23.02.26.
//

import SwiftUI
import WebKit

@available(iOS 26, *)
struct SAML2LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SAML2LoginViewModel()

    var body: some View {
        NavigationStack {
            WebView(viewModel.page)
                .loadingIndicator(isLoading: Binding {
                    viewModel.page.isLoading
                } set: { _ in
                })
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel) {
                            dismiss()
                        }
                    }
                }
                .alert(viewModel.error?.title ?? "", isPresented:
                    Binding {
                        viewModel.error != nil
                    } set: { newValue in
                        if !newValue {
                            viewModel.error = nil
                        }
                    }
                ) {}
        }
    }
}
