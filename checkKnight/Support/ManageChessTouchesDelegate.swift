//
//  MoveKnightDelegate.swift
//  checkKnight
//
//  Created by Teodoro Gomes on 2/7/20.
//  Copyright © 2020 Teodoro Gomes. All rights reserved.
//

import Foundation

protocol ManageChessTouchesDelegate {
    func moveKnight(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int)
    func drawTargetSquare(col: Int , row: Int)
}
