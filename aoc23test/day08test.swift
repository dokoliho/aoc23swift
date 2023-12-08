//
//  day08test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 08.12.23.
//

import XCTest

final class day08test: XCTestCase {

    let testPuzzlePart1 = [
        "LLR",
        "",
        "AAA = (BBB, BBB)",
        "BBB = (AAA, ZZZ)",
        "ZZZ = (ZZZ, ZZZ)",
        "",
    ]
    
    let testPuzzlePart2 = [
        "LR",
        "",
        "11A = (11B, XXX)",
        "11B = (XXX, 11Z)",
        "11Z = (11B, XXX)",
        "22A = (22B, XXX)",
        "22B = (22C, 22C)",
        "22C = (22Z, 22Z)",
        "22Z = (22B, 22B)",
        "XXX = (XXX, XXX)",
        "",
    ]

    
    func testGgt() throws {
        XCTAssertEqual(17, Day08Solution.ggT(v1:544, v2:391))
    }
    

    func testParseAutomata() throws {
        let solution = Day08Solution()
        let automata = solution.parseAutomata(puzzlepart: testPuzzlePart1[2...])
        XCTAssertEqual(3, automata.count)
        XCTAssertEqual("BBB", automata["AAA"]!.left)
        XCTAssertEqual("BBB", automata["AAA"]!.right)
        XCTAssertEqual("ZZZ", automata["BBB"]!.right)
    }

    
    func testStartNodes() throws {
        let solution = Day08Solution()
        let automata = solution.parseAutomata(puzzlepart: testPuzzlePart2[2...])
        let nodes = solution.startNodes(automata: automata)
        XCTAssertEqual(2, nodes.count)
        XCTAssertTrue(nodes.contains("11A"))
        XCTAssertTrue(nodes.contains("22A"))
    }

    
    
    func testSolvePart1() throws {
        let solution = Day08Solution()
        let result = solution.solvePart1(puzzle: testPuzzlePart1)
        XCTAssertEqual("6", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day08Solution()
        let result = solution.solvePart2(puzzle: testPuzzlePart2)
        XCTAssertEqual("6", result)
    }
}
