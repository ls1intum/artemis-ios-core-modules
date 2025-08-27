//
//  PasskeySettingsView.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 03.05.25.
//

import AuthenticationServices
import DesignLibrary
import SwiftUI

struct PasskeySettingsView: View {
    @State private var viewModel = PasskeySettingsViewModel()
    @Environment(\.authorizationController) var authorizationController
    @Environment(\.dismiss) var dismiss
    var parentDismiss: (() -> Void)?

    var body: some View {
        Form {
            DataStateView(data: $viewModel.passkeys) {
                await viewModel.loadPasskeys()
            } content: { passkeys in
                ForEach(passkeys, id: \Passkey.credentialId) { passkey in
                    VStack(alignment: .leading) {
                        Text(passkey.label)
                            .font(.headline)

                        Group {
                            Text("Created at ") + Text(passkey.created, style: .date)
                        }
                        .font(.footnote)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Delete", systemImage: "minus.circle", role: .destructive) {
                            Task {
                                await viewModel.deletePasskey(passkey)
                            }
                        }
                    }
                }

                if passkeys.isEmpty {
                    ContentUnavailableView(R.string.localizable.noPasskeys(),
                                           systemImage: "key.fill",
                                           description: Text(R.string.localizable.noPasskeysDescription))
                }

                Section {
                    Button("Add new key", systemImage: "key.fill") {
                        Task {
                            await viewModel.registerPasskey(controller: authorizationController)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadPasskeys()
            }
        }
        .navigationTitle(R.string.localizable.passkeys())
        .loadingIndicator(isLoading: $viewModel.isLoading)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(R.string.localizable.close()) {
                    if let parentDismiss {
                        parentDismiss()
                    } else {
                        dismiss()
                    }
                }
            }
        }
    }
}
