//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by mike_chen on 2022/11/6.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    
    var calculator: Calculator = CalculatorViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func input(val: String) throws {
        for (_, c) in val.enumerated() {
            if c.isNumber {
                try calculator.input(number: c)
            } else {
                calculator.dot()
            }
        }
    }
    
    private func cal(_ a: String, _ b: String, _ wantedVal: Double, _ mode: CalculateMode) throws {
        try self.input(val: a)
        calculator.set(mode: mode)
        try self.input(val: b)
        let res = try calculator.equal()
        debugPrint(res, wantedVal)
        XCTAssertEqual(res, wantedVal)
        calculator.clear()
    }

    func testAdd() throws {
        var a: String = "88"
        var b: String = "44"
        try self.cal(a, b, (88+44), .add)
        a = "0.3"
        b = "1"
        try self.cal(a, b, (0.3+1), .add)
    }
    
    func testSub() throws {
        var a: String = "88"
        var b: String = "44"
        try self.cal(a, b, (88-44), .subtract)
        a = "0.3"
        b = "1"
        try self.cal(a, b, (0.3-1), .subtract)
    }

    func testMul() throws {
        var a: String = "33"
        var b: String = "44"
        try self.cal(a, b, (33*44), .multiply)
        a = "0.3"
        b = "8"
        try self.cal(a, b, (0.3*8), .multiply)
    }

    func testDiv() throws {
        var a: String = "100"
        var b: String = "6"
        try self.cal(a, b, (100/6), .divide)
        a = "0.4"
        b = "2"
        try self.cal(a, b, (0.4/2), .divide)
    }
    
    func testFormula() throws {
        try self.input(val: "88")
        calculator.set(mode: .add)
        try self.input(val: "12")
        calculator.set(mode: .subtract)
        try self.input(val: "50")
        calculator.set(mode: .multiply)
        try self.input(val: "3")
        calculator.set(mode: .divide)
        try self.input(val: "8")
        let res = try self.calculator.equal()
        XCTAssertEqual(res, (((88+12)-50)*3) / 8)
    }
}
