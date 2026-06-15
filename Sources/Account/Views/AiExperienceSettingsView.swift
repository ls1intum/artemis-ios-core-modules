//
//  AiExperienceSettingsView.swift
//  ArtemisCore
//
//  Created by Senan Aslan on 13.06.26.
//

import DesignLibrary
import SafariServices
import SharedModels
import SwiftUI

struct AiExperienceSettingsView: View {
    @State private var viewModel = AiExperienceSettingsViewModel()
    @State private var isLearnMorePresented = false
    @Environment(\.dismiss) var dismiss

    private var errorBinding: Binding<Bool> {
        Binding(get: { viewModel.error != nil }, set: { if !$0 { viewModel.error = nil } })
    }

    private let options: [AiSelectionDecision] = [.cloudAI, .localAI, .noAI]

    var body: some View {
        Form {
            Section {
                ForEach(options, id: \.self) { option in
                    Button {
                        Task { await viewModel.select(option) }
                    } label: {
                        row(for: option)
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isLoading)
                }
            } header: {
                VStack(alignment: .leading, spacing: .s) {
                    Text(R.string.localizable.aiExperienceHeader())
                        .font(.headline)
                    Text(R.string.localizable.aiExperienceSubtitle())
                        .font(.subheadline)
                }
            } footer: {
                VStack(alignment: .leading, spacing: .s) {
                    Text(R.string.localizable.aiExperienceFooter())
                    if viewModel.infoURL != nil {
                        Button(R.string.localizable.aiLearnMoreLink()) {
                            isLearnMorePresented = true
                        }
                        .font(.footnote)
                    }
                    if let timestamp = viewModel.selectionTimestamp {
                        Text(R.string.localizable.aiLastChangedLabel()) + Text(" ") + Text(timestamp, style: .date)
                    }
                }
            }
        }
        .navigationTitle(R.string.localizable.aiExperienceNavigationTitle())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isLearnMorePresented) {
            if let infoURL = viewModel.infoURL {
                SafariView(url: infoURL)
                    .ignoresSafeArea()
            }
        }
        .task { await viewModel.load() }
        .loadingIndicator(isLoading: $viewModel.isLoading)
        .alert(viewModel.error?.title ?? "", isPresented: errorBinding) {
            Button(R.string.localizable.close(), role: .cancel) {}
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(R.string.localizable.close()) {
                    dismiss()
                }
            }
        }
    }

    @ViewBuilder
    private func row(for option: AiSelectionDecision) -> some View {
        HStack(alignment: .top, spacing: .m) {
            Image(systemName: icon(for: option))
                .font(.title3)
                .frame(width: 28)
                .foregroundStyle(option == .noAI ? Color.secondary : Color.accentColor)

            VStack(alignment: .leading, spacing: .xs) {
                HStack(spacing: .s) {
                    Text(title(for: option))
                        .font(.headline)
                    badge(for: option)
                }
                Text(description(for: option))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let features = features(for: option) {
                    featureBox(features)
                }
            }

            // Always reserve space for the checkmark so the text column keeps a
            // constant width and does not reflow when the selection changes.
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .opacity(viewModel.selection == option ? 1 : 0)
        }
        .contentShape(.rect)
    }

    private func icon(for option: AiSelectionDecision) -> String {
        switch option {
        case .cloudAI: "cloud.fill"
        case .localAI: "building.columns.fill"
        case .noAI: "nosign"
        }
    }

    private func title(for option: AiSelectionDecision) -> String {
        switch option {
        case .cloudAI: R.string.localizable.aiCloudTitle()
        case .localAI: R.string.localizable.aiLocalTitle()
        case .noAI: R.string.localizable.aiNoneTitle()
        }
    }

    private func description(for option: AiSelectionDecision) -> String {
        switch option {
        case .cloudAI: R.string.localizable.aiCloudDescription()
        case .localAI: R.string.localizable.aiLocalDescription()
        case .noAI: R.string.localizable.aiNoneDescription()
        }
    }

    @ViewBuilder
    private func badge(for option: AiSelectionDecision) -> some View {
        switch option {
        case .cloudAI:
            badgeLabel(R.string.localizable.aiRecommendedBadge(), color: .accentColor)
        case .localAI:
            badgeLabel(R.string.localizable.aiExperimentalBadge(), color: .orange)
        case .noAI:
            EmptyView()
        }
    }

    private func badgeLabel(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, .s)
            .background(color.opacity(0.15), in: Capsule())
            .foregroundStyle(color)
    }

    private struct AiFeature: Hashable {
        let text: String
        let systemName: String
        let color: Color
    }

    private func features(for option: AiSelectionDecision) -> [AiFeature]? {
        switch option {
        case .cloudAI:
            [
                AiFeature(text: R.string.localizable.aiCloudFeatureLLM(), systemName: "checkmark", color: .green),
                AiFeature(text: R.string.localizable.aiCloudFeatureQuality(), systemName: "checkmark", color: .green),
                AiFeature(text: R.string.localizable.aiCloudFeatureSpeed(), systemName: "checkmark", color: .green),
                AiFeature(text: R.string.localizable.aiCloudFeatureGdpr(), systemName: "checkmark", color: .green),
                AiFeature(text: R.string.localizable.aiCloudFeatureData(), systemName: "checkmark", color: .green)
            ]
        case .localAI:
            [
                AiFeature(text: R.string.localizable.aiLocalFeatureLLM(), systemName: "checkmark", color: .green),
                AiFeature(text: R.string.localizable.aiLocalFeatureQuality(), systemName: "info.circle", color: .secondary),
                AiFeature(text: R.string.localizable.aiLocalFeatureSpeed(), systemName: "info.circle", color: .secondary),
                AiFeature(text: R.string.localizable.aiLocalFeatureProcessing(), systemName: "checkmark", color: .green),
                AiFeature(text: R.string.localizable.aiLocalFeatureData(), systemName: "checkmark", color: .green)
            ]
        case .noAI:
            nil
        }
    }

    private func featureBox(_ features: [AiFeature]) -> some View {
        VStack(alignment: .leading, spacing: .m) {
            ForEach(features, id: \.self) { feature in
                HStack(alignment: .firstTextBaseline, spacing: .m) {
                    Image(systemName: feature.systemName)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(feature.color)
                    Text(feature.text)
                        .font(.subheadline.weight(.medium))
                }
            }
        }
        .padding(.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: .m))
        .padding(.top, .s)
    }
}

/// Presents a URL in an in-app `SFSafariViewController`. Using an embedded web view
/// avoids the host app's universal-link interception, which would otherwise show a
/// "Link not supported by App" alert for `artemis.tum.de` URLs on a real device.
private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
