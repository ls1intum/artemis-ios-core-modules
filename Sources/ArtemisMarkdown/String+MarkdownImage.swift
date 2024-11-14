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
        let referencePattern = #"(^>.*(?:\n|$))+"#
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
        var withoutCodeBlocks = self

        var range = NSRange(withoutCodeBlocks.startIndex..<withoutCodeBlocks.endIndex, in: withoutCodeBlocks)
        codeBlockRegex.enumerateMatches(in: withoutCodeBlocks, options: [], range: range) { match, _, _ in
            if let matchRange = match?.range, let range = Range(matchRange, in: withoutCodeBlocks) {
                let codeBlock = String(withoutCodeBlocks[range])
                codeBlocks.append(codeBlock)
                withoutCodeBlocks.replaceSubrange(range, with: codePlaceholder)
            }
        }
        range = NSRange(withoutCodeBlocks.startIndex..<withoutCodeBlocks.endIndex, in: withoutCodeBlocks)
        referenceRegex.enumerateMatches(in: withoutCodeBlocks, options: [], range: range) { match, _, _ in
            if let matchRange = match?.range, let range = Range(matchRange, in: withoutCodeBlocks) {
                let reference = String(withoutCodeBlocks[range])
                references.append(reference)
                withoutCodeBlocks.replaceSubrange(range, with: referencePlaceholder)
            }
        }

        // Surround images with newlines or replace them
        range = NSRange(withoutCodeBlocks.startIndex..<withoutCodeBlocks.endIndex, in: withoutCodeBlocks)
        let replacementPattern = replaceWith ?? "\n\n$1\n\n"
        withoutCodeBlocks = imageRegex.stringByReplacingMatches(in: withoutCodeBlocks, options: [], range: range, withTemplate: replacementPattern)

        // Restore the code blocks in the processed text
        var result = withoutCodeBlocks
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
