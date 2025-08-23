//
//  NotificationSettingsView.swift
//  
//
//  Created by Anian Schleyer on 05.05.25.
//

import DesignLibrary
import SwiftUI

public struct NotificationSettingsView: View {
    @State private var viewModel: NotificationSettingsViewModel

    public init(courseId: Int) {
        _viewModel = State(initialValue: NotificationSettingsViewModel(courseId: courseId))
    }

    public var body: some View {
        DataStateView(data: $viewModel.info) {
            await viewModel.loadInfo()
        } content: { _ in
            DataStateView(data: $viewModel.settings) {
                await viewModel.loadSettings()
            } content: { _ in
                let settings = viewModel.currentSettings
                Form {
                    presetPicker

                    Section {
                        ArtemisHintBox(text: R.string.localizable.settingsDisclaimer(), hintType: .info)
                            .listRowInsets(EdgeInsets(top: -1, leading: -1, bottom: -1, trailing: -1))
                    }

                    ForEach(settings, id: \.0.hashValue) { type, setting in
                        NotificationSettingView(viewModel: viewModel,
                                                settingType: type,
                                                setting: setting)
                    }
                }
                .listRowSpacing(.m)
            }
        }
        .navigationTitle(R.string.localizable.notificationSettingsTitle())
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: Binding(get: {
            viewModel.error != nil
        }, set: { newValue in
            if !newValue {
                viewModel.error = nil
            }
        }), error: viewModel.error, actions: {})
        .toolbar {
            if viewModel.isLoading {
                ToolbarItem(placement: .topBarTrailing) {
                    ProgressView()
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadInfo()
            }
            Task {
                await viewModel.loadSettings()
            }
        }
    }

    var presetBinding: Binding<NotificationSettingsPresetIdentifier> {
        .init {
            viewModel.currentPreset
        } set: { newValue in
            Task {
                await viewModel.selectPreset(with: newValue)
            }
        }
    }

    var presetPicker: some View {
        Section {
            Picker("Setting", selection: presetBinding) {
                ForEach(NotificationSettingsPresetIdentifier.allCases, id: \.self) { preset in
                    if preset != .unknown {
                        Button {
                            // No action needed
                            // Button is neccessary to display a subtitle in a picker
                        } label: {
                            Text(preset.title)
                            Text(preset.description)
                        }
                    }
                }
            }
        } footer: {
            Text(viewModel.currentPreset.description)
        }
    }
}

struct NotificationSettingView: View {
    var viewModel: NotificationSettingsViewModel

    let settingType: CourseNotificationType
    let setting: [NotificationChannel: Bool]

    var binding: Binding<Bool> {
        .init {
            setting[.push] ?? false
        } set: { newValue in
            Task {
                await viewModel.update(type: settingType, enabled: newValue)
            }
        }
    }

    var body: some View {
        if let setting = self.setting[.push] {
            Toggle(isOn: binding) {
                Text(settingType.settingsTitle)
                    .font(.headline)
                if let subtitle = settingType.settingsSubtitle {
                    Text(subtitle)
                }
            }
        }
    }
}
