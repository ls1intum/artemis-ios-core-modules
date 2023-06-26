//
//  ArtemisHintBox.swift
//  
//
//  Created by Tarlan Ismayilsoy on 24.06.23.
//

import SwiftUI

public struct ArtemisHintBox: View {
    private var text: String
    private var hintType: ArtemisHintType
    private let cornerRadius = 3.0

    public init(text: String,
                hintType: ArtemisHintType = .info) {
        self.text = text
        self.hintType = hintType
    }

    public var body: some View {
        Group {
            Text(hintType.icon)
            +
            Text(" " + text)
                .font(.body)
        }
        .foregroundColor(hintType.textColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(cornerRadius)
        .padding()
        .background(hintType.backgroundColor)
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(hintType.borderColor)
        }
        .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
    }
}

public enum ArtemisHintType {
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
            return Color.Artemis.hintBoxInfoText
        case .warning:
            return Color.Artemis.hintBoxWarningText
        }
    }

    public var borderColor: Color {
        switch self {
        case .info:
            return Color.Artemis.hintBoxInfoBorder
        case .warning:
            return Color.Artemis.hintBoxWarningBorder
        }
    }

    public var backgroundColor: Color {
        switch self {
        case .info:
            return Color.Artemis.hintBoxInfoBackground
        case .warning:
            return Color.Artemis.hintBoxWarningBackground
        }
    }
}

public struct ArtemisHintBox_Previews: PreviewProvider {
    public static var previews: some View {
        ArtemisHintBox(text: "This is a warning!")
    }
}
