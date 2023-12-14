//
//  day13test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 13.12.23.
//

import XCTest

final class day13test: XCTestCase {

    let testPuzzle = [
        "#.##..##.",
        "..#.##.#.",
        "##......#",
        "##......#",
        "..#.##.#.",
        "..##..##.",
        "#.#.##.#.",
        "",
        "#...##..#",
        "#....#..#",
        "..##..###",
        "#####.##.",
        "#####.##.",
        "..##..###",
        "#....#..#",
        "",
    ]
    
    let solution = Day13Solution()
    
    
    func testParse() throws {
        let patterns = solution.parsePuzzle(testPuzzle)
        XCTAssertEqual(2, patterns.count)
        XCTAssertEqual(7, patterns[0].lines.count)
    }

    func testMirrorLine() throws {
        let patterns = solution.parsePuzzle(testPuzzle)
        let _ = patterns[0].mirrorLine()
        let _ = patterns[1].mirrorLine()
    }

    
    func testNewMirrorLine() throws {
        let patterns = solution.parsePuzzle(testPuzzle)
        let l1 = patterns[0].findNewMirrorLine()
        print(l1)
        let l2 = patterns[1].findNewMirrorLine()
        print(l2)
        let p0 = patterns[0].transpose()
        let p1 = patterns[1].transpose()
        let t0 = p0.findNewMirrorLine()
        print(t0)
        let t1 = p1.findNewMirrorLine()
        print(t1)
    }

    
    
    
    func testTranspose() throws {
        let patterns = solution.parsePuzzle(testPuzzle)
        let p0 = patterns[0].transpose()
        let p1 = patterns[1].transpose()
        let _ = p0.mirrorLine()
        let _ = p1.mirrorLine()

    }

    
    
    func testSolvePart1() throws {
        let solution = Day13Solution()
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("405", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day13Solution()
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("400", result)
    }
}
