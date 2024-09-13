//
//  ProfileView.swift
//  
//
//  Created by Sven Andabaka on 19.05.23.
//

import DesignLibrary
import SwiftUI
import SharedModels

struct ProfileView: View {

    @Environment(\.dismiss) var dismiss

    let account: Account

    var body: some View {
        NavigationView {
            List {
                if let pictureUrl = account.imagePath {
                    Section {
                        ArtemisAsyncImage(imageURL: pictureUrl) {}
                            .frame(width: 100, height: 100)
                            .clipShape(.rect(cornerRadius: .m))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .listRowBackground(Color.clear)
                    } footer: {
                        Text(R.string.localizable.changeProfilePicture())
                    }
                }
                Section(R.string.localizable.fullNameLabel()) {
                    Text(account.name)
                }
                Section(R.string.localizable.loginLabel()) {
                    Text(account.login)
                }
                Section(R.string.localizable.emailLabel()) {
                    Text(account.email)
                }
                if let visibleRegistrationNumber = account.visibleRegistrationNumber {
                    Section(R.string.localizable.registrationNumberLabel()) {
                        Text(visibleRegistrationNumber)
                    }
                }
                if let createdDate = account.createdDate {
                    Section(R.string.localizable.joinedLabel()) {
                        Text(createdDate.mediumDateShortTime)
                    }
                }
            }
            .navigationTitle(R.string.localizable.accountInformationNavigationTitle())
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(R.string.localizable.close()) {
                            dismiss()
                        }
                    }
                }
        }
    }
}
