//
//  File.swift
//
//
//  Created by Sven Andabaka on 01.03.23.
//

import DesignLibrary
import ProfileInfo
import SwiftUI
import UserStore

public struct InstitutionSelectionView: View {
    @Binding var institution: InstitutionIdentifier

    var handleProfileInfoCompletion: @MainActor (ProfileInfo?) -> Void

    public init(
        institution: Binding<InstitutionIdentifier>,
        handleProfileInfoCompletion: @escaping @MainActor (ProfileInfo?) -> Void
    ) {
        self._institution = institution
        self.handleProfileInfoCompletion = handleProfileInfoCompletion
    }

    public var body: some View {
        List {
            Text(R.string.localizable.account_select_artemis_instance_select_text())
                .font(.headline)
            ForEach(InstitutionIdentifier.allCases) { institutionIdentifier in
                Group {
                    if case .custom = institutionIdentifier {
                        CustomInstanceCell(
                            currentInstitution: $institution,
                            institution: institutionIdentifier,
                            handleProfileInfoCompletion: handleProfileInfoCompletion)
                    } else {
                        InstanceCell(
                            currentInstitution: $institution,
                            institution: institutionIdentifier,
                            handleProfileInfoCompletion: handleProfileInfoCompletion)
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

private struct CustomInstanceCell: View {
    @Environment(\.dismiss) var dismiss

    @Binding var currentInstitution: InstitutionIdentifier

    @State private var customUrl = ""
    @State private var showErrorAlert = false
    @State private var isLoading = false

    var institution: InstitutionIdentifier
    var handleProfileInfoCompletion: @MainActor (ProfileInfo?) -> Void

    var body: some View {
        VStack {
            HStack {
                InstitutionLogo(institution: institution)
                    .frame(width: .mediumImage)
                Text(institution.name)
                Spacer()
                if currentInstitution == institution {
                    Image(systemName: "checkmark.circle.fill")
                        .frame(width: .smallImage)
                        .foregroundColor(Color.Artemis.artemisBlue)
                }
            }

            TextField(R.string.localizable.account_select_artemis_instance_custom_instance(), text: $customUrl)
                .textFieldStyle(ArtemisTextField())
                .keyboardType(.URL)
                .background(Color.gray.opacity(0.2))
            Button(R.string.localizable.select(), action: select)
                .buttonStyle(ArtemisButton())
                .loadingIndicator(isLoading: $isLoading)
                .alert(R.string.localizable.account_select_artemis_instance_error(), isPresented: $showErrorAlert, actions: { })
        }
        .frame(maxWidth: .infinity)
        .padding(.l)
        .cardModifier()
        .onChange(of: currentInstitution) {
            if case .custom(let url) = institution {
                customUrl = url?.absoluteString ?? ""
            }
        }
        .onAppear {
            if case .custom(let url) = currentInstitution {
                customUrl = url?.absoluteString ?? ""
            }
        }
    }

    @MainActor
    func select() {
        guard let url = URL(string: customUrl) else {
            showErrorAlert = true
            return
        }
        UserSession.shared.saveInstitution(identifier: .custom(url))

        isLoading = true

        Task {
            let result = await ProfileInfoServiceFactory.shared.getProfileInfo()
            isLoading = false
            switch result {
            case .loading:
                isLoading = true
            case .failure:
                showErrorAlert = true
                UserSession.shared.saveInstitution(identifier: .tum)
            case .done(let response):
                handleProfileInfoCompletion(response)
                dismiss()
            }
        }
    }
}

private struct InstanceCell: View {
    @Environment(\.dismiss) var dismiss

    @Binding var currentInstitution: InstitutionIdentifier

    @State private var showErrorAlert = false
    @State private var isLoading = false

    var institution: InstitutionIdentifier
    var handleProfileInfoCompletion: @MainActor (ProfileInfo?) -> Void

    var body: some View {
        HStack {
            InstitutionLogo(institution: institution)
                .frame(width: .mediumImage)
            Text(institution.name)
            Spacer()
            if currentInstitution == institution {
                Image(systemName: "checkmark.circle.fill")
                    .frame(width: .smallImage)
                    .foregroundColor(Color.Artemis.artemisBlue)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.l)
        .cardModifier()
        .loadingIndicator(isLoading: $isLoading)
        .alert(R.string.localizable.account_select_artemis_instance_error(), isPresented: $showErrorAlert, actions: { })
        .onTapGesture(perform: select)
    }

    @MainActor
    func select() {
        UserSession.shared.saveInstitution(identifier: institution)
        Task {
            let result = await ProfileInfoServiceFactory.shared.getProfileInfo()
            isLoading = false
            switch result {
            case .loading:
                isLoading = true
            case .failure:
                showErrorAlert = true
                UserSession.shared.saveInstitution(identifier: .tum)
            case .done(let response):
                handleProfileInfoCompletion(response)
                dismiss()
            }
        }
    }
}

private struct InstitutionLogo: View {
    var institution: InstitutionIdentifier

    var body: some View {
        if institution.logo == nil {
            Image("Artemis-Logo", bundle: .module)
                .resizable()
                .scaledToFit()
        } else {
            AsyncImage(url: institution.logo) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image("Artemis-Logo", bundle: .module)
                        .resizable()
                        .scaledToFit()
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}

// MARK: - InstitutionIdentifier+Logo

extension InstitutionIdentifier {
    var logo: URL? {
        URL(string: "public/images/logo.png", relativeTo: self.baseURL)
    }
}
