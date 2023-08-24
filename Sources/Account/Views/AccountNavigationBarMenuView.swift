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
                        Text(account.login)
                        Image(systemName: "person.fill")
                    }
                })
            }
            if notificationsVisible {
                Button(action: {
                    showNotificationSettings = true
                }, label: {
                    HStack {
                        Text(R.string.localizable.notificationSettingsLabel())
                        Image(systemName: "gearshape.fill")
                    }
                })
            }
            Button {
                //
            } label: {
                HStack {
                    Text("Instance Contact")
                    Image(systemName: "info.bubble.fill")
                }
            }
            Button(R.string.localizable.logoutLabel()) {
                viewModel.logout()
            }
        }, label: {
            HStack(alignment: .center, spacing: .s) {
                Spacer()
                Image(systemName: "person.fill")
                Text(viewModel.account.value?.login ?? "xx12xxx")
                    .redacted(reason: viewModel.account.value == nil ? .placeholder : [])
                Image(systemName: "arrowtriangle.down.fill")
                    .scaleEffect(0.5)
            }.frame(width: 150)
        })
        .onChange(of: viewModel.error) { error in
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
