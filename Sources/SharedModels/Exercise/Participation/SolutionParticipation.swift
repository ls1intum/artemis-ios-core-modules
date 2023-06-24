//
//  SolutionParticipation.swift
//  
//
//  Created by Tarlan Ismayilsoy on 15.06.23.
//

import Foundation

// Should ideally extend `BaseParticipation', but since an instance of this struct is contained in `ProgrammingExercise`, it leads to a recursion.
// The problem would be gone if `ProgrammingExercise` contained an array of `SolutionParticipation`s instead.
// Read more here: https://stackoverflow.com/questions/53626802/struct-cannot-have-stored-property-that-references-itself-but-it-can-have-an-arr/63965336#63965336
public struct SolutionParticipation: Codable {
    public var id: Int
}
