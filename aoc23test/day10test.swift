//
//  day10test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 10.12.23.
//

import XCTest

final class day10test: XCTestCase {

    let testPuzzle1 = [
        "..F7.",
        ".FJ|.",
        "SJ.L7",
        "|F--J",
        "LJ...",
        "",
    ]
    
    let testPuzzle2 = [
        "FF7FSF7F7F7F7F7F---7",
        "L|LJ||||||||||||F--J",
        "FL-7LJLJ||||||LJL-77",
        "F--JF--7||LJLJ7F7FJ-",
        "L---JF-JLJ.||-FJLJJ7",
        "|F|F-JF---7F7-L7L|7|",
        "|FFJF7L7F-JF7|JL---7",
        "7-L-JL7||F7|L7F-7F7|",
        "L.L7LFJ|||||FJL7||LJ",
        "L7JLJL-JLJLJL--JLJ.L",
        "",
    ]
    
    
    
    
    func testSolvePart1() throws {
        let solution = Day10Solution()
        let result = solution.solvePart1(puzzle: testPuzzle1)
        XCTAssertEqual("8", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day10Solution()
        let result = solution.solvePart2(puzzle: testPuzzle2)
        XCTAssertEqual("10", result)
    }
    
    func testParse() throws {
        let solution = Day10Solution()
        let nodes = solution.parse(testPuzzle1)
        XCTAssertEqual("F", nodes[Day10Solution.Position(row:0, col: 2)])
    }
    
    func testEdges() throws {
        let solution = Day10Solution()
        let nodes = solution.parse(testPuzzle1)
        let edges = solution.findEdges(nodes)
        XCTAssertEqual(2, edges[Day10Solution.Position(row:0, col: 2)]?.count ?? 0)
    }

    func testStart() throws {
        let solution = Day10Solution()
        let nodes = solution.parse(testPuzzle1)
        let start = solution.startPosition(nodes)
        XCTAssertEqual(Day10Solution.Position(row:2, col: 0), start!)
    }
    
    func testCountInnerTiles() throws {
        let solution = Day10Solution()
        XCTAssertEqual(4, solution.countInnerTiles(line: ".|..||..|."))
        XCTAssertEqual(0, solution.countInnerTiles(line: ".L--JL--J."))
        XCTAssertEqual(0, solution.countInnerTiles(line: ".||....||."))
        XCTAssertEqual(1, solution.countInnerTiles(line: "F--JF--7||LJLJ.F7FJ."))
        XCTAssertEqual(4, solution.countInnerTiles(line: "L---JF-JLJ....FJLJ.."))
        XCTAssertEqual(3, solution.countInnerTiles(line: "...F-JF---7...L7...."))
        XCTAssertEqual(2, solution.countInnerTiles(line: "..FJF7L7F-JF7..L---7"))
    }

    

}
