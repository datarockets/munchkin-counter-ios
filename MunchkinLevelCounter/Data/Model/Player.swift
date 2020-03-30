//
//  Player.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 12.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

final class Player: Hashable {
    var playerId: String
    var playerName: String?
    var playerLevel: Int = 1
    var playerStrength: Int = 1
    var playerPosition: Int = 0
    var playerColor: String?
    var isPlaying: Bool = false
    
    init(playerId: String) {
        self.playerId = playerId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.playerId)
    }
    
    func getTotalScore() -> Int {
        return playerLevel + playerStrength
    }
    
}

func == (lhs: Player, rhs: Player) -> Bool {
    return lhs.playerId == rhs.playerId
}
