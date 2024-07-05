//
//  PushNotificationSettingsView.swift
//  
//
//  Created by Sven Andabaka on 28.03.23.
//

import DesignLibrary
import SwiftUI

public struct PushNotificationSettingsView: View {

    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel = PushNotificationSettingsViewModel()

    public init() { }

    public var body: some View {
        NavigationView {
            if viewModel.didSetupNotifications {
                DataStateView(data: $viewModel.pushNotificationSettingsRequest) {
                    await viewModel.getNotificationSettings()
                } content: { _ in
                    List {
                        ForEach(PushNotificationSettingsSection.allCases) { section in
                            Section(section.title) {
                                ForEach(section.entries, content: self.content)
                            }
                        }
                    }
                }.task {
                    await viewModel.getNotificationSettings()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(R.string.localizable.cancel()) {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(R.string.localizable.save()) {
                            viewModel.pushNotificationSettingsRequest = .loading
                            Task {
                                let isSuccessful = await viewModel.saveNotificationSettings()
                                if isSuccessful {
                                    dismiss()
                                }
                            }
                        }.disabled(viewModel.isSaveDisabled)
                    }
                }
                .navigationTitle(R.string.localizable.notificationSettingsTitle())
                .navigationBarTitleDisplayMode(.inline)
            } else {
                PushNotificationSetupView(shouldCloseOnSkip: true)
            }
        }
        .interactiveDismissDisabled(!viewModel.isSaveDisabled)
    }
}

private extension PushNotificationSettingsView {
    func content(id: PushNotificationSettingId) -> some View {
        let isOn = Binding {
            viewModel.pushNotificationSettings[id]?.push ?? false
        } set: { value in
            viewModel.pushNotificationSettings[id]?.push = value
            viewModel.isSaveDisabled = false
        }

        return (viewModel.pushNotificationSettings[id]?.push).map { _ in
            Toggle(isOn: isOn) {
                Text(id.title)
                Text(id.description)
            }
        }
    }
}

// MARK: - PushNotificationSettingsSection

private enum PushNotificationSettingsSection: String, CaseIterable {

    case courseWideDiscussion
    case exam
    case exercise
    case lecture
    case tutorialGroup
    case tutor
    case userMention

    var title: String {
        switch self {
        case .courseWideDiscussion:
            return R.string.localizable.courseWideDiscussionNotificationsSectionTitle()
        case .exam:
            return R.string.localizable.examNotificationsSectionTitle()
        case .exercise:
            return R.string.localizable.exerciseNotificationsSectionTitle()
        case .lecture:
            return R.string.localizable.lectureNotificationsSectionTitle()
        case .tutorialGroup:
            return R.string.localizable.tutorialGroupNotificationsSectionTitle()
        case .tutor:
            return R.string.localizable.tutorNotificationsSectionTitle()
        case .userMention:
            return R.string.localizable.userMentionSectionTitle()
        }
    }

    var entries: [PushNotificationSettingId] {
        switch self {
        case .courseWideDiscussion:
            return [
                .newCoursePost,
                .newReplyForCoursePost,
                .newAnnouncementPost
            ]
        case .exam:
            return [
                .newExamPost,
                .newReplyForExamPost
            ]
        case .exercise:
            return [
                .exerciseReleased,
                .exercisePractice,
                .exerciseSubmissionAssessed,
                .fileSubmissionSuccessful,
                .newExercisePost,
                .newReplyForExercisePost
            ]
        case .lecture:
            return [
                .attachmentChange,
                .newLecturePost,
                .newReplyForLecturePost
            ]
        case .tutorialGroup:
            return [
                .tutorialGroupRegistrationStudent,
                .tutorialGroupDeleteUpdateStudent
            ]
        case .tutor:
            return [
                .tutorialGroupRegistrationTutor,
                .tutorialGroupAssignUnassignTutor
            ]
        case .userMention:
            return [
                .userMention
            ]
        }
    }
}

extension PushNotificationSettingsSection: Identifiable {
    var id: Self {
        self
    }
}

// MARK: PushNotificationSettingId+Localization

extension PushNotificationSettingId {
    var title: String {
        switch self {
        case .newCoursePost:
            return R.string.localizable.newCoursePostSettingsName()
        case .newReplyForCoursePost:
            return R.string.localizable.newReplyForCoursePostSettingsName()
        case .newAnnouncementPost:
            return R.string.localizable.newAnnouncementPostSettingsName()
        case .newExamPost:
            return R.string.localizable.newExamMessageSettingsName()
        case .newReplyForExamPost:
            return R.string.localizable.newReplyForExamMessageSettingsName()
        case .exerciseReleased:
            return R.string.localizable.exerciseReleasedSettingsName()
        case .exercisePractice:
            return R.string.localizable.exerciseOpenForPracticeSettingsName()
        case .exerciseSubmissionAssessed:
            return R.string.localizable.exerciseSubmissionAssessedSettingsName()
        case .fileSubmissionSuccessful:
            return R.string.localizable.fileSubmissionSuccessfulSettingsName()
        case .newExercisePost:
            return R.string.localizable.newExercisePostSettingsName()
        case .newReplyForExercisePost:
            return R.string.localizable.newReplyForExercisePostSettingsName()
        case .attachmentChange:
            return R.string.localizable.attachmentChangesSettingsName()
        case .newLecturePost:
            return R.string.localizable.newLecturePostSettingsName()
        case .newReplyForLecturePost:
            return R.string.localizable.newReplyForLecturePostSettingsName()
        case .tutorialGroupRegistrationStudent:
            return R.string.localizable.registrationTutorialGroupSettingsName()
        case .tutorialGroupDeleteUpdateStudent:
            return R.string.localizable.tutorialGroupUpdateDeleteSettingsName()
        case .tutorialGroupRegistrationTutor:
            return R.string.localizable.registrationTutorialGroupSettingsName()
        case .tutorialGroupAssignUnassignTutor:
            return R.string.localizable.assignUnassignTutorialGroupSettingsName()
        case .userMention:
            return R.string.localizable.userMentionSettingsName()
        case .unknown:
            return R.string.localizable.error()
        }
    }

    var description: String {
        switch self {
        case .newCoursePost:
            return R.string.localizable.newCoursePostDescription()
        case .newReplyForCoursePost:
            return R.string.localizable.newReplyForCoursePostDescription()
        case .newAnnouncementPost:
            return R.string.localizable.newAnnouncementPostDescription()
        case .newExamPost:
            return R.string.localizable.newExamMessageSettingsDescription()
        case .newReplyForExamPost:
            return R.string.localizable.newReplyForExamMessageSettingsDescription()
        case .exerciseReleased:
            return R.string.localizable.exerciseReleasedDescription()
        case .exercisePractice:
            return R.string.localizable.exerciseOpenForPracticeDescription()
        case .exerciseSubmissionAssessed:
            return R.string.localizable.exerciseSubmissionAssessedDescription()
        case .fileSubmissionSuccessful:
            return R.string.localizable.fileSubmissionSuccessfulDescription()
        case .newExercisePost:
            return R.string.localizable.newExercisePostDescription()
        case .newReplyForExercisePost:
            return R.string.localizable.newReplyForExercisePostDescription()
        case .attachmentChange:
            return R.string.localizable.attachmentChangesDescription()
        case .newLecturePost:
            return R.string.localizable.newLecturePostDescription()
        case .newReplyForLecturePost:
            return R.string.localizable.newReplyForLecturePostDescription()
        case .tutorialGroupRegistrationStudent:
            return R.string.localizable.registrationTutorialGroupStudentDescription()
        case .tutorialGroupDeleteUpdateStudent:
            return R.string.localizable.tutorialGroupUpdateDeleteDescription()
        case .tutorialGroupRegistrationTutor:
            return R.string.localizable.registrationTutorialGroupTutorDescription()
        case .tutorialGroupAssignUnassignTutor:
            return R.string.localizable.assignUnassignTutorialGroupDescription()
        case .userMention:
            return R.string.localizable.userMentionSettingsDescription()
        case .unknown:
            return R.string.localizable.error()
        }
    }
}
