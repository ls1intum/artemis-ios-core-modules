//
//  ProfilePictureInitialsView.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 16.03.25.
//

import CryptoKit
import SwiftUI

public struct ProfilePictureInitialsView: View {
    let name: String
    let userId: String
    let size: CGFloat

    public init(name: String, userId: String, size: CGFloat) {
        self.name = name
        self.userId = userId
        self.size = size
    }

    public var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
            Text(initials)
                .font(.system(size: 0.42 * size, weight: .bold, design: .rounded))
                .fontDesign(.rounded)
                .foregroundStyle(.white)
        }
    }

    private var initials: String {
        let nameComponents = name.split(separator: " ")
        let initialFirstName = nameComponents.first?.prefix(1) ?? ""
        let initialLastName = nameComponents.last?.prefix(1) ?? ""
        let initials = initialFirstName + initialLastName
        if initials.isEmpty {
            return "NA"
        } else {
            return String(initials)
        }
    }

    private var backgroundColor: Color {
        // We can't use userId.hashValue because it changes between every program execution
        var sha = SHA256()
        sha.update(data: Data(userId.utf8))
        let hash = abs(sha.finalize().reduce(0) { $0 << 8 | Int($1) }) % 255
        return Color(hue: Double(hash) / 255, saturation: 0.5, brightness: 0.5)
    }
}
