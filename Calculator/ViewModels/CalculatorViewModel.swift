//
//  CalculatorViewModel.swift
//  MKSamples
//
//  Created by mike_chen on 2022/1/17.
//  Copyright © 2022 Mike. All rights reserved.
//

import Foundation

enum CalculateError: Error {
    case inputValueIsEmpty
    case inputValueNotInRange
    case valueConvertFail
    case unexpected
    
    var message: String {
        switch self {
        case .inputValueIsEmpty:
            return "輸入數值為空"
        case .inputValueNotInRange:
            return "輸入的數值不在處理範圍內"
        case .valueConvertFail:
            return "數位轉換錯誤"
        case .unexpected:
            return "未預期錯誤"
        }
    }
}

enum CalculateMode {
    case add
    case subtract
    case divide
    case multiply
    case none
}

protocol CalculatorUIBehavior: AnyObject {
    func update(value: String)
}

protocol Calculator {
    var uiBehavior: CalculatorUIBehavior? { get set }
    func clear()
    func backSpace()
    
    /// 輸入計算數值
    ///
    /// 不支援輸入負數
    /// 可輸入值範圍：'0'～'9'
    /// - Parameter number: 要計算的數值
    func input(number: Character) throws
    
    func dot()
    func doubleZero()
    
    func set(mode: CalculateMode)
    func percentage()
    
    @discardableResult
    func equal() throws -> Double
}









class CalculatorViewModel {
    weak var uiBehavior: CalculatorUIBehavior?

    private enum State {
        case waitingInput, none
    }
    
    private let defaultValue = "0"
    private let dotSign: String = "."
    private lazy var value: String = defaultValue {
        didSet {
            self.uiBehavior?.update(value: value)
        }
    }
    private var currenMode: CalculateMode = .none {
        willSet {
            if newValue != currenMode {
                do {
                    try self.equal()
                } catch CalculateError.valueConvertFail {
                    self.errorHander(error: .valueConvertFail)
                } catch {
                    self.errorHander(error: .unexpected)
                }
            }
        }
        didSet {
            if currenMode == oldValue, currenMode != .none {
                do {
                    try self.equal()
                } catch CalculateError.valueConvertFail {
                    self.errorHander(error: .valueConvertFail)
                } catch {
                    self.errorHander(error: .unexpected)
                }
            }
            self.state = .waitingInput
        }
    }
    
    private var calQueue = [Double]()
    private var state: State = .none
}


extension CalculatorViewModel: Calculator {
    private func checkValue() -> Bool {
        guard !self.value.isEmpty else { return false }
        
        var isValid = false
        let ary = self.value.components(separatedBy: self.dotSign)
        if ary.count >= 2 {
            isValid = true
        } else if let iVal = Int(self.value), iVal > 0 {
            isValid = true
        }
     
        return isValid
    }
    
    func clear() {
        self.currenMode = .none
        self.value = self.defaultValue
        self.calQueue.removeAll()
        self.state = .none
    }
    
    func backSpace() {
        guard self.checkValue(), self.value.count > 1 else {
            self.clear()
            return
        }
        let eIdx = self.value.index(before: self.value.endIndex)
        self.value = String(self.value[..<eIdx])
    }
    
    func input(number: Character) throws {
        guard number.isNumber else {
            throw CalculateError.inputValueNotInRange
        }
        
        if self.state == .waitingInput {
            self.value = defaultValue
            self.state = .none
        }
        
        if self.value.count == 1, self.value == self.defaultValue {
            self.value = String(number)
        } else {
            self.value += String(number)
        }
    }
    
    func dot() {
        guard !self.value.contains(self.dotSign) else { return }
        self.value += self.dotSign
    }
    
    func doubleZero() {
        guard self.checkValue() else { return }
        self.value += "00"
    }
    
    private func updateValue(res: Double?) {
        guard let res = res else { return }
        
        self.value = String(res)
        self.calQueue[0] = res
        
        // 只保留最後一次計算結果
        if self.calQueue.count > 1 {
            self.calQueue.removeLast()
        }
    }
    
    func set(mode: CalculateMode) {
        self.currenMode = mode
    }
    
    func percentage() {
        guard let val = Double(self.value) else { return }
        self.value = String(val / 100)
    }
    
    @discardableResult
    func equal() throws -> Double {
        guard let val = Double(self.value) else {
            throw CalculateError.valueConvertFail
        }
        
        self.calQueue.append(val)
        let res = try self.calculate(mode: self.currenMode, source: self.calQueue)
        self.updateValue(res: res)
        return res
    }
    
    /// 無先乘除後加減
    private func calculate(mode: CalculateMode, source: [Double]) throws -> Double {
        guard source.count > 0 else {
            throw CalculateError.unexpected
        }
        
        var res = source[0]
        switch mode {
        case .add:
            res = source.reduce(0, +)
        case .subtract:
            res = source[1...].reduce(source[0], -)
        case .divide:
            res = source[1...].reduce(source[0], /)
        case .multiply:
            res = source.reduce(1, *)
        case .none:
            break
        }
        
        return res
    }
    
    func errorHander(error: CalculateError) {
        self.uiBehavior?.update(value: error.message)
    }
}
