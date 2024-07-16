//
//  Chip.swift
//  
//
//  Created by Sven Andabaka on 20.03.23.
//

import SwiftUI

public struct Chip: View {

    var text: String
    var backgroundColor: Color
    var horizontalPadding: CGFloat
    var verticalPadding: CGFloat

    public init(text: String, backgroundColor: Color, padding: CGFloat = .m) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.horizontalPadding = padding
        self.verticalPadding = padding
    }

    public init(text: String, backgroundColor: Color, horizontalPadding: CGFloat, verticalPadding: CGFloat) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }

    public var body: some View {
        Text(text)
            .bold()
            .lineLimit(1)
            .foregroundColor(.white)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}
