//
//  String+MarkdownImage.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 13.11.24.
//

import Foundation

public extension String {
    /**
     Surrounds markdown images with newlines to convert inline images into block images.
     */
    public func surroundingMarkdownImagesWithNewlines() -> String {
        modifyingMarkdownImagesOutsideStyledBlocks()
    }

    /**
     Replaces markdown images with a placeholder: [image 🏞️]
     Used for notification previews.
     */
    public func replacingMarkdownImages() -> String {
        modifyingMarkdownImagesOutsideStyledBlocks(replaceWith: "[image 🏞️]")
    }

    /**
     Either replaces images in Markdown text with a given placeholder or surrounds them with newlines if no placeholder is given
     */
    private func modifyingMarkdownImagesOutsideStyledBlocks(replaceWith: String? = nil) -> String {
        // Regex for code blocks, references and images outside styled blocks
        let codeBlockPattern = #"(```[\s\S]*?```|(?: {4}|\t)[^\n]*\n?)"#
        let referencePattern = #"(?m)(^> ?[^\n]+\n*)+"#
        let imagePattern = #"(?<!\*\*|\*|<ins>|`)(\!\[[^\]]*\]\([^)]*\))(?!\*\*|\*|</ins>|`)"#

        guard let codeBlockRegex = try? NSRegularExpression(pattern: codeBlockPattern, options: []),
              let referenceRegex = try? NSRegularExpression(pattern: referencePattern, options: []),
              let imageRegex = try? NSRegularExpression(pattern: imagePattern, options: []) else {
            print("Failed to create regex for image replacements")
            return self
        }

        // Extract and replace code blocks with a placeholder
        let codePlaceholder = UUID().uuidString
        let referencePlaceholder = UUID().uuidString
        var codeBlocks: [String] = []
        var references: [String] = []
        var withoutBlocks = self
        let mutable = NSMutableString(string: withoutBlocks)

        // Extract code blocks
        var range = NSRange(withoutBlocks.startIndex..<withoutBlocks.endIndex, in: withoutBlocks)
        codeBlockRegex.enumerateMatches(in: withoutBlocks, options: [], range: range) { match, _, _ in
            if let matchRange = match?.range, let range = Range(matchRange, in: withoutBlocks) {
                codeBlocks.append(String(withoutBlocks[range]))
            }
        }

        // Replace code blocks with placeholder
        codeBlockRegex.replaceMatches(in: mutable, range: range, withTemplate: codePlaceholder)
        withoutBlocks = String(mutable)

        // Extract references
        range = NSRange(withoutBlocks.startIndex..<withoutBlocks.endIndex, in: withoutBlocks)
        referenceRegex.enumerateMatches(in: withoutBlocks, options: [], range: range) { match, _, _ in
            print(match)
            if let matchRange = match?.range, let range = Range(matchRange, in: withoutBlocks) {
                references.append(String(withoutBlocks[range]))
            }
        }

        // Replace references with placeholder
        referenceRegex.replaceMatches(in: mutable, range: range, withTemplate: referencePlaceholder)
        withoutBlocks = String(mutable)

        // Surround images with newlines or replace them
        range = NSRange(withoutBlocks.startIndex..<withoutBlocks.endIndex, in: withoutBlocks)
        let replacementPattern = replaceWith ?? "\n\n$1\n\n"
        withoutBlocks = imageRegex.stringByReplacingMatches(in: withoutBlocks, options: [], range: range, withTemplate: replacementPattern)

        // Restore the code blocks in the processed text
        var result = withoutBlocks
        for codeBlock in codeBlocks {
            if let range = result.range(of: codePlaceholder) {
                result.replaceSubrange(range, with: codeBlock)
            }
        }
        for reference in references {
            if let range = result.range(of: referencePlaceholder) {
                result.replaceSubrange(range, with: reference)
            }
        }

        return result
    }
}
