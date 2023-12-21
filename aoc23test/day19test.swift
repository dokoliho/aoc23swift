//
//  day19test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 19.12.23.
//

import XCTest

final class day19test: XCTestCase {

    let testPuzzle = [
        "px{a<2006:qkq,m>2090:A,rfg}",
        "pv{a>1716:R,A}",
        "lnx{m>1548:A,A}",
        "rfg{s<537:gd,x>2440:R,A}",
        "qs{s>3448:A,lnx}",
        "qkq{x<1416:A,crn}",
        "crn{x>2662:A,R}",
        "in{s<1351:px,qqz}",
        "qqz{s>2770:qs,m<1801:hdj,R}",
        "gd{a>3333:R,R}",
        "hdj{m>838:A,pv}",
        "",
        "{x=787,m=2655,a=1222,s=2876}",
        "{x=1679,m=44,a=2067,s=496}",
        "{x=2036,m=264,a=79,s=2244}",
        "{x=2461,m=1339,a=466,s=291}",
        "{x=2127,m=1623,a=2188,s=1013}",
        "",
    ]
    
    let solution = Day19Solution()
    
    func testParse() throws {
        let (automata, parts) = solution.parse(lines: testPuzzle)
        XCTAssertEqual(11, automata.rules.count)
        XCTAssertEqual(5, parts.count)
    }
    
    func testMultirange() throws {
        let (automata, _) = solution.parse(lines: ["in{a>1716:R,A}", ""])
        let result = automata.reduce(arriving: Day19Solution.PartRange.startPartRange)
        XCTAssertEqual(4000*4000*1716*4000, Day19Solution.PartRange.combinations(ranges: result))
    }

    func testSolvePart1() throws {
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("19114", result)
    }
    
    func testSolvePart2() throws {
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("167409079868000", result)
    }
}
