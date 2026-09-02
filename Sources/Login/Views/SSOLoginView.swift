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
    @State private var viewModel: SSOLoginViewModel
    init(ssoType: SSOType) {
        let vm: SSOLoginViewModel = (ssoType == .saml2) ? SAML2LoginViewModel() : OIDCLoginViewModel()
        _viewModel = State(wrappedValue: vm)
    }
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
