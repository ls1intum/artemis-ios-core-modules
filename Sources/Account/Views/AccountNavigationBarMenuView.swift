//
//  SwiftUIView.swift
//
//
//  Created by Sven Andabaka on 10.02.23.
//

import SwiftUI
import DesignLibrary
import Common
import PushNotifications

struct AccountNavigationBarMenuView: View {
    @StateObject private var viewModel = AccountNavigationBarMenuViewModel()

    @Binding var error: UserFacingError?

    @State private var showNotificationSettings = false
    @State private var showProfile = false

    let notificationsVisible: Bool

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
            if notificationsVisible {
                Button(action: {
                    showNotificationSettings = true
                }, label: {
                    HStack {
                        Image(systemName: "gearshape.fill")
                        Text(R.string.localizable.notificationSettingsLabel())
                        Spacer()
                    }
                })
            }
            Button(R.string.localizable.logoutLabel()) {
                viewModel.logout()
            }
        }, label: {
            HStack(alignment: .center, spacing: .s) {
                Spacer()
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
            }.frame(width: 150)
        })
        .onChange(of: viewModel.error) { _, error in
            self.error = error
        }
        .sheet(isPresented: $showNotificationSettings) {
            PushNotificationSettingsView()
        }
        .sheet(isPresented: $showProfile) {
            if let account = viewModel.account.value {
                ProfileView(account: account)
            } else {
                Text(R.string.localizable.loading())
            }
        }
    }
}

struct AccountMenu: ViewModifier {

    @Binding var error: UserFacingError?

    let notificationsVisible: Bool

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AccountNavigationBarMenuView(error: $error, notificationsVisible: notificationsVisible)
                }
            }
    }
}

public extension View {
    func accountMenu(error: Binding<UserFacingError?>, notificationsVisible: Bool = true) -> some View {
        modifier(AccountMenu(error: error, notificationsVisible: notificationsVisible))
    }
}
