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
        let l0 = patterns[0].mirrorLine()
        XCTAssertEqual(0, l0.count)

        let l1 = patterns[1].mirrorLine()
        XCTAssertEqual(4, l1[0] )

    }

    
    func testTranspose() throws {
        let patterns = solution.parsePuzzle(testPuzzle)
        let p0 = patterns[0].transpose()
        let p1 = patterns[1].transpose()
        
        let l0 = p0.mirrorLine()
        XCTAssertEqual(5, l0[0] )

        let l1 = p1.mirrorLine()
        XCTAssertEqual(0, l1.count)

    }

    
    func testNewMirrorLine() throws {
        let patterns = solution.parsePuzzle(testPuzzle)
        
        let l0 = patterns[0].findNewMirrorLine()
        XCTAssertEqual(3, l0 ?? -1)
        
        let l1 = patterns[1].findNewMirrorLine()
        XCTAssertEqual(1, l1 ?? -1)

        let p0 = patterns[0].transpose()
        let p1 = patterns[1].transpose()

        let t0 = p0.findNewMirrorLine()
        XCTAssertEqual(nil, t0)
        
        let t1 = p1.findNewMirrorLine()
        XCTAssertEqual(nil, t1)
        
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
