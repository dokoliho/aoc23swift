//
//  day12test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 12.12.23.
//

import XCTest

final class day12test: XCTestCase {

    let testPuzzle = [
        "???.### 1,1,3",                // 1 arrangement
        ".??..??...?##. 1,1,3",         // 4 arrangements
        "?#?#?#?#?#?#?#? 1,3,1,6",      // 1 arrangement
        "????.#...#... 4,1,1",          // 1 arrangement
        "????.######..#####. 1,6,5",    // 4 arrangements
        "?###???????? 3,2,1",           // 10 arrangements
        "",
    ]
        
    
    func testSolvePart1() throws {
        let solution = Day12Solution()
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("21", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day12Solution()
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }


}
