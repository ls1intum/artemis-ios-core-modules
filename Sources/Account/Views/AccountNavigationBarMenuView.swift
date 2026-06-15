//
//  SwiftUIView.swift
//
//
//  Created by Sven Andabaka on 10.02.23.
//

import SwiftUI
import DesignLibrary
import Common
import ProfileInfo
import PushNotifications

struct AccountNavigationBarMenuView: View {
    @State private var viewModel = AccountNavigationBarMenuViewModel()

    /// Whether the connected instance has the Iris/AI module enabled. The AI experience settings are only
    /// relevant in that case (e.g. instances set up without any AI experience should not show this).
    @ModuleFeatureAvailability(.iris) private var isIrisAvailable

    @Binding var error: UserFacingError?

    @State private var showProfile = false
    @State private var showPasskeySettings = false
    @State private var showAiSettings = false

    var body: some View {
        Menu(content: {
            DataStateView(data: $viewModel.account, retryHandler: viewModel.getAccount) { account in
                Button(action: {
                    showProfile = true
                }, label: {
                    HStack {
                        Image(systemName: "person.fill")
                        Text(account.login)
                        Spacer()
                    }
                })
            }
            if Bundle.main.bundleIdentifier == "de.tum.cit.ase.artemis" {
                Button("Manage Passkeys", systemImage: "key.fill") {
                    showPasskeySettings = true
                }
            }
            if isIrisAvailable {
                Button(R.string.localizable.aiExperienceNavigationTitle(), systemImage: "sparkles") {
                    showAiSettings = true
                }
            }
            Button(R.string.localizable.logoutLabel()) {
                viewModel.logout()
            }
        }, label: {
            HStack(alignment: .center, spacing: .s) {
                if let pictureUrl = viewModel.profilePicUrl {
                    ArtemisAsyncImage(imageURL: pictureUrl) {
                        Image(systemName: "person.fill")
                    }
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(.circle)
                } else {
                    Image(systemName: "person.fill")
                    Text(viewModel.account.value?.login ?? "xx12xxx")
                        .redacted(reason: viewModel.account.value == nil ? .placeholder : [])
                }
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 10)
            }
        })
        .task {
            await viewModel.checkPasskeyRecommendation()
            await FeatureList.shared.checkAvailability()
        }
        .onChange(of: viewModel.error) { _, error in
            self.error = error
        }
        .sheet(isPresented: $showProfile) {
            if let account = viewModel.account.value {
                ProfileView(account: account)
            } else {
                Text(R.string.localizable.loading())
            }
        }
        .sheet(isPresented: $showPasskeySettings) {
            NavigationStack {
                PasskeySettingsView()
            }
        }
        .sheet(isPresented: $showAiSettings) {
            NavigationStack {
                AiExperienceSettingsView()
            }
        }
        .sheet(isPresented: $viewModel.recommendPasskey) {
            NavigationStack {
                PasskeyRecommendationView()
            }
        }
    }
}

struct AccountMenu: ViewModifier {

    @Binding var error: UserFacingError?

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AccountNavigationBarMenuView(error: $error)
                }
            }
    }
}

public extension View {
    func accountMenu(error: Binding<UserFacingError?>) -> some View {
        modifier(AccountMenu(error: error))
    }
}
