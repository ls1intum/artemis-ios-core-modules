//
//  SSOLoginView.swift
//  ArtemisCore
//
//  Created by Viktor Lynok on 02.09.26.
//

import SwiftUI
import WebKit
@available(iOS 26, *)
struct SSOLoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SSOLoginViewModel?
    let rememberMe: Bool
    let ssoType: SSOType

    init(ssoType: SSOType, rememberMe: Bool) {
        self.ssoType = ssoType
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
                // choose the authentication strategy
                let vm: SSOLoginViewModel = (ssoType == .saml2) ? SAML2LoginViewModel() : OIDCLoginViewModel(rememberMe: rememberMe)
                if let oidcVM = vm as? OIDCLoginViewModel {
                    oidcVM.onLoginSuccess = {
                        dismiss()
                    }
                }
                self.viewModel = vm
            }
        }
    }
}
