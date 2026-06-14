//
//  AiExperienceSettingsViewModel.swift
//  ArtemisCore
//
//  Created by Senan Aslan on 13.06.26.
//

import Common
import Foundation
import SharedModels
import SharedServices
import UserStore

@MainActor
@Observable
class AiExperienceSettingsViewModel {
    private let accountService: AccountService = AccountServiceFactory.shared

    /// The user's current AI choice, or `nil` if they have not chosen yet.
    var selection: AiSelectionDecision?
    var selectionTimestamp: Date?
    var error: UserFacingError?
    var isLoading = false

    init() {
        let user = UserSessionFactory.shared.user
        selection = user?.selectedLLMUsage
        selectionTimestamp = user?.selectedLLMUsageTimestamp
    }

    /// Refreshes the account from the server so a change made elsewhere (e.g. the web client)
    /// is reflected instead of the possibly stale cached value.
    func load() async {
        let response = await accountService.getAccount()
        if case .done(let account) = response {
            selection = account.selectedLLMUsage
            selectionTimestamp = account.selectedLLMUsageTimestamp
        }
    }

    func select(_ newSelection: AiSelectionDecision) async {
        guard newSelection != selection, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        let response = await accountService.updateLLMSelection(newSelection)
        switch response {
        case .success:
            // updateLLMSelection refreshes the cached account; read the authoritative values back.
            let user = UserSessionFactory.shared.user
            selection = user?.selectedLLMUsage ?? newSelection
            selectionTimestamp = user?.selectedLLMUsageTimestamp
        case .failure(let error):
            self.error = .init(title: error.localizedDescription)
        default:
            break
        }
    }
}
