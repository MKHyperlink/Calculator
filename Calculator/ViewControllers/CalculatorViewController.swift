//
//  CalculatorViewController.swift
//  MKSamples
//
//  Created by mike_chen on 2022/1/14.
//  Copyright © 2022 Mike. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "CalculatorViewController" }
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var percentageButton: UIButton!
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var equalityButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var doubleZeroButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    private var viewModel: Calculator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
    }
    
    private func dataInit() {
        self.viewModel = CalculatorViewModel()
        self.viewModel?.uiBehavior = self
    }
    
    @IBAction func pressClear(_ sender: Any) {
        self.viewModel?.clear()
    }
    
    @IBAction func pressBack(_ sender: Any) {
        self.viewModel?.backSpace()
    }
    
    @IBAction func pressPercentage(_ sender: Any) {
        self.viewModel?.percentage()
    }
    
    @IBAction func pressDivide(_ sender: Any) {
        self.viewModel?.set(mode: .divide)
    }
    
    @IBAction func pressMultiply(_ sender: Any) {
        self.viewModel?.set(mode: .multiply)
    }
    
    @IBAction func pressSubtract(_ sender: Any) {
        self.viewModel?.set(mode: .subtract)
    }
    
    @IBAction func pressAdd(_ sender: Any) {
        self.viewModel?.set(mode: .add)
    }
    
    @IBAction func pressEquality(_ sender: Any) {
        _ = try? self.viewModel?.equal()
    }
    
    @IBAction func pressDot(_ sender: Any) {
        self.viewModel?.dot()
    }
    
    @IBAction func pressDoubleZero(_ sender: Any) {
        self.viewModel?.doubleZero()
    }
    
    @IBAction func pressNumber(_ sender: UIButton) {
        let num = Character(String(sender.tag))
        try? self.viewModel?.input(number: num)
    }
}



extension CalculatorViewController: CalculatorUIBehavior {
    func update(value: String) {
        self.inputTextField.text = value
    }
}
