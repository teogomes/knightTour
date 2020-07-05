//
//  ChessView.swift
//  checkKnight
//
//  Created by Teodoro Gomes on 2/7/20.
//  Copyright © 2020 Teodoro Gomes. All rights reserved.
//

import UIKit

class ChessView: UIView {
    
    var dynamicSize:CGFloat = 0
    var knight:Knight? = nil
    var targetSquare:Cell?
    var sortedPaths:[Cell] = []
    var delegate: ManageChessTouchesDelegate?
    var currentSettings = SettingsModel()
    
    override func draw(_ rect: CGRect) {
        dynamicSize = self.frame.size.width / CGFloat(currentSettings.squares)
        drawBoard()
        if (currentSettings.colorSquares) {drawSquaresOfPath()}
        drawPiece()
        if (currentSettings.showLines) {drawLines()}
        drawTargetSquare()
        if(currentSettings.showNumbers){drawNumbers()}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let fingerLocation = touch.location(in: self)
        let fromCol = Int(fingerLocation.x / dynamicSize)
        let fromRow = Int(fingerLocation.y / dynamicSize)
        targetSquare = nil
        delegate?.moveKnight(fromCol: 0, fromRow: 0, toCol: fromCol, toRow: fromRow)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let fingerLocation = touch.location(in: self)
        let toCol = Int(fingerLocation.x / dynamicSize)
        let toRow = Int(fingerLocation.y / dynamicSize)
        delegate?.drawTargetSquare(col: toCol, row: toRow) 
    }
    
    private func drawTargetSquare() {
        guard targetSquare != nil else { return }
        drawSquareAt(x: CGFloat(targetSquare!.col) * dynamicSize, y: CGFloat(targetSquare!.row) * dynamicSize,color:UIColor.red)
    }
    
    
    private func drawLines() {
        guard sortedPaths.count > 0 else { return }
        
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x:(CGFloat(knight?.col ?? 0) * dynamicSize) + dynamicSize / 2 , y:(CGFloat(knight?.row ?? 0 ) * dynamicSize) + dynamicSize / 2))
        
        for cell in sortedPaths {
            aPath.addLine(to: (CGPoint(x:(CGFloat(cell.col) * dynamicSize) + dynamicSize / 2, y:(CGFloat(cell.row) * dynamicSize) + dynamicSize / 2 )))            
        }
        aPath.close()
        UIColor.blue.set()
        aPath.lineWidth = 3.5
        aPath.stroke()
    }
    
    private func drawSquaresOfPath() {
        for cell in sortedPaths {
            drawSquareAt(x: CGFloat(cell.col ) * dynamicSize, y: CGFloat(cell.row ) * dynamicSize, color: UIColor.blue)
        }
    }
    
    private func drawNumbers() {
        var index = 0
        for cell in sortedPaths {
            drawMyText(myText: String(index), x: CGFloat(cell.col ) * dynamicSize, y: CGFloat(cell.row ) * dynamicSize)
            index += 1
        }
    }
    
    private func drawPiece(){
        guard knight != nil else {
            return
        }
        let pieceImage = UIImage(named:knight!.imageName)
        drawSquareAt(x: CGFloat(knight!.col) * dynamicSize, y: CGFloat(knight!.row) * dynamicSize,color:UIColor.yellow)
        pieceImage?.draw(in: CGRect(x: CGFloat(knight!.col) * dynamicSize, y: CGFloat(knight!.row) * dynamicSize, width: dynamicSize, height: dynamicSize))
        
    }
    
    private func drawBoard() {
        var i = 0
        for _ in 0...currentSettings.squares {
            drawTwoRowsAt(y: CGFloat(i) * dynamicSize)
            i += 2
        }
    }
    
    private func drawTwoRowsAt(y: CGFloat) {
        for i in 0...currentSettings.squares {
            if(i % 2 == 0) {
                drawSquareAt(x: CGFloat(i) * dynamicSize, y: y + dynamicSize)
                drawSquareAt(x: CGFloat(i) * dynamicSize, y: y + dynamicSize)
                drawSquareAt(x: CGFloat(i) * dynamicSize, y: y + dynamicSize)
                drawSquareAt(x: CGFloat(i) * dynamicSize, y: y + dynamicSize)
            }else {
                drawSquareAt(x: CGFloat(i) * dynamicSize, y: y)
                drawSquareAt(x: CGFloat(i) * dynamicSize, y: y)
                drawSquareAt(x: CGFloat(i) * dynamicSize, y: y)
                drawSquareAt(x: CGFloat(i) * dynamicSize, y: y)
            }
        }
    }
    
    private func drawSquareAt(x: CGFloat, y: CGFloat,color:UIColor = UIColor.white) {
        let rect = CGRect(x: x, y: y, width: dynamicSize, height: dynamicSize)
        let path = UIBezierPath(rect:rect )
        color.setFill()
        path.fill()
    }
    
    private func drawMyText(myText:String,x: CGFloat, y: CGFloat){
        let inRect = CGRect(x: x, y: y, width: dynamicSize, height: dynamicSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let textFontAttributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 26.0),
            .foregroundColor: UIColor.white
        ]
        myText.draw(in: inRect, withAttributes: textFontAttributes)
    }
    
}
