//
//  ArtemisWarning.swift
//  
//
//  Created by Tarlan Ismayilsoy on 24.06.23.
//

import SwiftUI

public struct ArtemisWarning: View {
    private var text: String
    private var textColor: Color
    private var borderColor: Color
    private var backgroundColor: Color

    private let cornerRadius = 3.0

    public init(text: String,
                textColor: Color = Color.Artemis.warningText,
                borderColor: Color = Color.Artemis.warningBorder,
                backgroundColor: Color = Color.Artemis.warningBackground) {
        self.text = text
        self.textColor = textColor
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        Group {
            Text(Image(systemName: "exclamationmark.triangle.fill"))
            +
            Text(" " + text)
                .font(.body)
        }
        .foregroundColor(textColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(cornerRadius)
        .padding()
        .background(backgroundColor)
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor)
        }
        .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
    }
}

public struct ArtemisWarning_Previews: PreviewProvider {
    public static var previews: some View {
        ArtemisWarning(text: "This is a warning!")
    }
}
