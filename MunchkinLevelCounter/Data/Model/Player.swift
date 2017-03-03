//
//  Player.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 12.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

class Player {
    var playerId: String?
    var playerName: String?
    var playerLevel: Int = 1
    var playerStrength: Int = 1
    var playerColor: String?
    var isPlaying: Bool = false
    
    init() {}
    
    init(playerId: String,
         playerName: String,
         playerLevel: Int,
         playerStrength: Int,
         playerColor: String,
         isPlaying: Bool) {
        self.playerName = playerName
        self.playerLevel = playerLevel
        self.playerStrength = playerStrength
        self.playerColor = playerColor
        self.isPlaying = isPlaying
    }
    
    func getTotalScore() -> Int {
        return playerLevel + playerStrength
    }
    
}
