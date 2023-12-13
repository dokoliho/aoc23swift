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
    
    
    func testGrouping() throws {
        let solution = Day12Solution()
        XCTAssertEqual([1, 1, 3], solution.grouping("#.#.###"))
        XCTAssertEqual([1, 1, 3], solution.grouping(".#...#....###."))
        XCTAssertEqual([1, 3, 1, 6], solution.grouping(".#.###.#.######"))
        XCTAssertEqual([4, 1, 1], solution.grouping("####.#...#..."))
        XCTAssertEqual([1, 6, 5], solution.grouping("#....######..#####"))
        XCTAssertEqual([3, 2, 1], solution.grouping(".###.##....#"))
    }

    func testValidSolutiond() throws {
        let solution = Day12Solution()
        XCTAssertEqual("#.#.###", solution.validSolutions(pattern: "???.###", group: [1, 1, 3]).first!)
        XCTAssertEqual(".#.###.#.######", solution.validSolutions(pattern: "?#?#?#?#?#?#?#?", group: [1, 3, 1, 6]).first!)
        XCTAssertEqual(10, solution.validSolutions(pattern: "?###????????", group: [3, 2, 1]).count)
    }
    
    
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
