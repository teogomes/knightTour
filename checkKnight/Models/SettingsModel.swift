//
//  SettingsModel.swift
//  checkKnight
//
//  Created by Teodoro Gomes on 5/7/20.
//  Copyright © 2020 Teodoro Gomes. All rights reserved.
//

import Foundation

struct SettingsModel {
    var squares:Int = 8
    var maxMoves:Int = 3
    var showNumbers:Bool = true
    var colorSquares:Bool = true
    var showLines:Bool = true
    let colValidMoves:[Int] = [-2, -1, 1, 2, -2, -1, 1, 2]
    let rowValidMoves:[Int] = [-1, -2, -2, -1, 1, 2, 2, 1]
}
