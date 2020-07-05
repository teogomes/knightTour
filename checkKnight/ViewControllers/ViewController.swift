//
//  ViewController.swift
//  checkKnight
//
//  Created by Teodoro Gomes on 2/7/20.
//  Copyright © 2020 Teodoro Gomes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var currentPathLabel: UILabel!
    @IBOutlet private weak var chessView: ChessView!
    private var knightPiece:Knight? = nil
    private var target:Cell?
    private var rightPahts:[Set<Cell>] = []
    private var rightPathInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeChess()
        showAlert(title: NSLocalizedString("mainHelpTitle", comment: ""), message: NSLocalizedString("mainHelpMessage", comment: ""), buttonTitle: "OK")
      
    }
    
    private func initializeChess() {
        chessView.delegate = self
        chessView.setNeedsDisplay()
    }
    
    private func showErrorNoPath() {
        rightPathInteger = 0
        currentPathLabel.text = ""
        showAlert(title: NSLocalizedString("attentionTitle", comment: ""), message: NSLocalizedString("noMorePathsText", comment: ""), buttonTitle: "OK")
    }
    
    private func canKnightMoveTo(cell:Cell) -> Bool {
        return (cell.col >= 0 && cell.col <= chessView.currentSettings.squares - 1 && cell.row >= 0 && cell.row <= chessView.currentSettings.squares - 1)
    }
    
    
    private func nextKnightMove(currentPosition:Cell,prevPaths: inout Set<Cell>,maxNumberOfMoves:Int) -> Bool  {
        
        //Base Call
        //Target Reached
        guard prevPaths.count < maxNumberOfMoves else {
            return false
        }
        
        if(target?.col == currentPosition.col && target?.row == currentPosition.row) {
            rightPahts.append(prevPaths)
            return false
        }
        
        //All knight moves
        for i in (0...7) {
            let newCol = currentPosition.col + chessView.currentSettings.colValidMoves[i]
            let newRow = currentPosition.row + chessView.currentSettings.rowValidMoves[i]
            let newCell = Cell(col: newCol, row: newRow,distance: prevPaths.count)
            
            //Inside chess
            if(canKnightMoveTo(cell: newCell)) {
                prevPaths.insert(newCell)
                if( nextKnightMove(currentPosition: newCell, prevPaths: &prevPaths, maxNumberOfMoves: maxNumberOfMoves)) {
                    return true
                }else{
                    prevPaths.remove(newCell)
                }
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let vc = segue.destination as! SettingsViewController
           vc.currentSettings = chessView.currentSettings
           vc.delegate = self
       }
    
    //MARK: IBActions
    
    @IBAction private func nextPathButton(_ sender: Any) {
           
           guard rightPathInteger < rightPahts.count  else {
               showErrorNoPath()
               return
           }
           
           let sortedPaths = rightPahts[rightPathInteger].sorted{$0.distance < $1.distance}
           guard sortedPaths.count > 0 else {
               showErrorNoPath()
               return
           }
           
           chessView.sortedPaths = sortedPaths
           chessView.setNeedsDisplay()
           var text = ""
           sortedPaths.forEach{ text += "(\(String($0.col)),\(String($0.row))) -> " }
           text.removeLast(4)
           currentPathLabel.text = text
           rightPathInteger += 1
       }
}

extension ViewController:ManageChessTouchesDelegate {
    
    func moveKnight(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        knightPiece = Knight(col: toCol, row: toRow, imageName: "Knight")
        rightPahts.removeAll()
        rightPathInteger = 0
        chessView.sortedPaths.removeAll()
        chessView.knight = knightPiece
        chessView.setNeedsDisplay()
    }
    
    func drawTargetSquare(col: Int, row: Int) {
        chessView.targetSquare = Cell(col: col, row: row, distance:0)
        target = chessView.targetSquare
        chessView.setNeedsDisplay()
        var prevPaths = Set<Cell>()
        let _ = nextKnightMove(currentPosition: Cell(col: knightPiece!.col, row: knightPiece!.row, distance: 0),prevPaths: &prevPaths, maxNumberOfMoves:chessView.currentSettings.maxMoves)
    }
}

//MARK: SettingsDelegate

extension ViewController:SettingsViewControllerDelegate {
    func saveSettings(newSettings: SettingsModel) {
        chessView.currentSettings = newSettings
        chessView.setNeedsDisplay()
    }
}
