//
//  PasskeyRecommendationView.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 27.08.25.
//

import SwiftUI

struct PasskeyRecommendationView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                Image(systemName: "key.viewfinder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.blue)
                    .padding(.top)

                Text(R.string.localizable.passkeyRecommendationTitle())
                    .font(.title.bold())

                Text(R.string.localizable.passkeyRecommendationBody())
                    .multilineTextAlignment(.center)
            }
        }
        .contentMargins(.xl, for: .scrollContent)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 20) {
                NavigationLink {
                    PasskeySettingsView()
                } label: {
                    Text(R.string.localizable.setUpPasskeys())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, .m)
                }
                .buttonStyle(.borderedProminent)

                Button(R.string.localizable.notNow()) {
                    dismiss()
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(.bar)
        }
    }
}
