//
//  SwiftUIView.swift
//
//
//  Created by Sven Andabaka on 26.01.23.
//

import SwiftUI
import Common

public struct DataStateView<T, Content: View>: View {
    @Binding var data: DataState<T>
    var content: (T) -> Content
    var retryHandler: () async -> Void

    public init(data: Binding<DataState<T>>,
                retryHandler: @escaping () async -> Void,
                @ViewBuilder content: @escaping (T) -> Content) {
        self._data = data
        self.retryHandler = retryHandler
        self.content = content
    }

    public var body: some View {
        Group {
            switch data {
            case .loading:
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case .failure(let error):
                ContentUnavailableView {
                    Label(error.title, systemImage: "bolt.horizontal")
                } description: {
                    if let message = error.message {
                        Text(message)
                    }
                    if let detail = error.detail {
                        Text(detail)
                    }
                } actions: {
                    Button("Retry") {
                        data = .loading
                        Task {
                            await retryHandler()
                        }
                    }
                }
            case .done(let result):
                content(result)
            }
        }
    }
}
