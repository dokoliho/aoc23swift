//
//  day05test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 05.12.23.
//

import XCTest

final class day05test: XCTestCase {
    
    let currentPuzzle = [
        "seeds: 79 14 55 13",
        "",
        "seed-to-soil map:",
        "50 98 2",
        "52 50 48",
        "",
        "soil-to-fertilizer map:",
        "0 15 37",
        "37 52 2",
        "39 0 15",
        "",
        "fertilizer-to-water map:",
        "49 53 8",
        "0 11 42",
        "42 0 7",
        "57 7 4",
        "",
        "water-to-light map:",
        "88 18 7",
        "18 25 70",
        "",
        "light-to-temperature map:",
        "45 77 23",
        "81 45 19",
        "68 64 13",
        "",
        "temperature-to-humidity map:",
        "0 69 1",
        "1 0 69",
        "",
        "humidity-to-location map:",
        "60 56 37",
        "56 93 4",
        "",
    ]
    
    
    func testParser() throws {
        let parser = SeedMapParser(puzzle: currentPuzzle)
        XCTAssertEqual([79, 14, 55, 13], parser.seeds)
        XCTAssertEqual(7, parser.transformers.count)
        XCTAssertEqual(2, parser.transformers[0].mapentry.count)
        XCTAssertEqual(3, parser.transformers[1].mapentry.count)
        XCTAssertEqual(4, parser.transformers[2].mapentry.count)
        XCTAssertEqual(2, parser.transformers[3].mapentry.count)
    }
    
    
    func testTransformer() throws {
        let parser = SeedMapParser(puzzle: currentPuzzle)
        let transformer = parser.transformers[0]
        
        XCTAssertEqual(0, transformer.transform(0))
        XCTAssertEqual(1, transformer.transform(1))
        XCTAssertEqual(48, transformer.transform(48))
        XCTAssertEqual(49, transformer.transform(49))
        XCTAssertEqual(52, transformer.transform(50))
        XCTAssertEqual(53, transformer.transform(51))
        XCTAssertEqual(98, transformer.transform(96))
        XCTAssertEqual(99, transformer.transform(97))
        XCTAssertEqual(50, transformer.transform(98))
        XCTAssertEqual(51, transformer.transform(99))

    }

    
    func testSolvePart1() throws {
        let solution = Day05Solution()
        let result = solution.solvePart1(puzzle: currentPuzzle)
        XCTAssertEqual("35", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day05Solution()
        let result = solution.solvePart2(puzzle: currentPuzzle)
        XCTAssertEqual("46", result)
    }
}
