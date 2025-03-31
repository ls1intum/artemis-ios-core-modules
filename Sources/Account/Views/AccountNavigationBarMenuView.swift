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

    @State private var showProfile = false

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
