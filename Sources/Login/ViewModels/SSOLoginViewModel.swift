//
//  SSOLoginViewModel.swift
//  ArtemisCore
//
//  Created by Viktor Lynok on 02.09.26.
//
// An abstraction used for strategy pattern for different authentication flows in SSOLoginView

import Common
import Observation
import WebKit

@Observable
@MainActor
@available(iOS 26, *)
open class SSOLoginViewModel {
    let page: WebPage
    let config: WebPage.Configuration
    var error: UserFacingError?

    init(page: WebPage, config: WebPage.Configuration) {
        self.page = page
        self.config = config
    }
}
