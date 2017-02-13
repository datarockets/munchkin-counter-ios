//
//  Player.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 12.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation

class Player {
    var playerId: String?
    var playerName: String?
    var playerLevel: Int?
    var playerStrength: Int?
    
    init() {}
    
    init(playerId: String,
         playerName: String,
         playerLevel: Int,
         playerStrength: Int) {
        self.playerId = playerId
        self.playerName = playerName
        self.playerLevel = playerLevel
        self.playerStrength = playerStrength
    }
    
}
