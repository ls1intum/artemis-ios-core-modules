//
//  ArtemisAlertView.swift
//  
//
//  Created by Tarlan Ismayilsoy on 24.06.23.
//

import SwiftUI

public struct ArtemisAlertView: View {
    private var text: String
    private var level: ArtemisAlertLevel
    private let cornerRadius = 3.0

    public init(text: String,
                level: ArtemisAlertLevel = .info) {
        self.text = text
        self.level = level
    }

    public var body: some View {
        Group {
            Text(level.icon)
            +
            Text(" " + text)
                .font(.body)
        }
        .foregroundColor(level.textColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(cornerRadius)
        .padding()
        .background(level.backgroundColor)
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(level.borderColor)
        }
        .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
    }
}

public enum ArtemisAlertLevel {
    case info, warning

    public var icon: Image {
        switch self {
        case .info:
            return Image(systemName: "info")
        case .warning:
            return Image(systemName: "exclamationmark.triangle.fill")
        }
    }

    public var textColor: Color {
        switch self {
        case .info:
            return Color.Artemis.alertInfoText
        case .warning:
            return Color.Artemis.alertWarningText
        }
    }

    public var borderColor: Color {
        switch self {
        case .info:
            return Color.Artemis.alertInfoBorder
        case .warning:
            return Color.Artemis.alertWarningBorder
        }
    }

    public var backgroundColor: Color {
        switch self {
        case .info:
            return Color.Artemis.alertInfoBackground
        case .warning:
            return Color.Artemis.alertWarningBackground
        }
    }
}

public struct ArtemisWarning_Previews: PreviewProvider {
    public static var previews: some View {
        ArtemisAlertView(text: "This is a warning!")
    }
}
