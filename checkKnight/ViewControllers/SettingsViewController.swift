//
//  SettingsViewController.swift
//  checkKnight
//
//  Created by Teodoro Gomes on 4/7/20.
//  Copyright © 2020 Teodoro Gomes. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func saveSettings(newSettings:SettingsModel)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var showNumbersSwitch: UISwitch!
    @IBOutlet private weak var showlLinesSwitch: UISwitch!
    @IBOutlet private weak var colorSquaresSwitch: UISwitch!
    @IBOutlet private weak var maxMovesTextField: UITextField!
    @IBOutlet private weak var numOfSquaresTextfield: UITextField!
    var delegate:SettingsViewControllerDelegate?
    var currentSettings = SettingsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        numOfSquaresTextfield.text = String(currentSettings.squares)
        maxMovesTextField.text = String(currentSettings.maxMoves)
        showlLinesSwitch.isOn = currentSettings.showLines
        showNumbersSwitch.isOn = currentSettings.showNumbers
        colorSquaresSwitch.isOn = currentSettings.colorSquares 
    }
    
    
    //MARK: IBActions
    
    @IBAction func doneButton(_ sender: Any) {
        
        guard let squares = Int(numOfSquaresTextfield?.text ?? "") else {
            showAlert(title: NSLocalizedString("attentionTitle", comment: ""), message: NSLocalizedString("notValidSquaresError", comment: ""), buttonTitle: "OK")
            return
        }
        
        guard squares >= 6 && squares <= 16 else {
            showAlert(title: NSLocalizedString("attentionTitle", comment: ""), message: NSLocalizedString("notValidSquaresError", comment: ""), buttonTitle: "OK")
            return
        }
        
        guard  let maxMoves = Int(maxMovesTextField?.text ?? "") else {
            showAlert(title: NSLocalizedString("attentionTitle", comment: ""), message: NSLocalizedString("notValidMaxMovesError", comment: ""), buttonTitle: "OK")
            return
        }
        
        currentSettings.squares = squares
        currentSettings.maxMoves = maxMoves
        currentSettings.colorSquares = colorSquaresSwitch.isOn
        currentSettings.showLines = showlLinesSwitch.isOn
        currentSettings.showNumbers = showNumbersSwitch.isOn
        delegate?.saveSettings(newSettings: currentSettings)
        
        dismiss(animated: true, completion: nil)
    }
}
