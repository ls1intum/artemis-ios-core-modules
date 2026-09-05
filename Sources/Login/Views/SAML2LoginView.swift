//
//  SSOLoginView.swift
//  ArtemisCore
//
//  Created by Viktor Lynok on 02.09.26.
//

import SwiftUI
import WebKit
@available(iOS 26, *)
struct SAML2LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SAML2LoginViewModel?
    let rememberMe: Bool

    init(rememberMe: Bool) {
        self.rememberMe = rememberMe
    }

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    WebView(viewModel.page)
                        .loadingIndicator(isLoading: Binding {
                            viewModel.page.isLoading
                        } set: { _ in
                        })
                        .alert(viewModel.error?.title ?? "", isPresented: Binding {
                            viewModel.error != nil
                        } set: { newValue in
                            if !newValue { viewModel.error = nil }
                        }) {}
                } else {
                    ProgressView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
        .task {
            if viewModel == nil {
                self.viewModel = SAML2LoginViewModel()
            }
        }
    }
}
