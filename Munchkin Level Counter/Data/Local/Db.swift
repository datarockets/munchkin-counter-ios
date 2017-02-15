//
//  Db.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 14.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation

class Db {
    
    class PlayerTable {
     
        class func map(from entity: PlayerEntity, to player: Player) {
            player.playerId = entity.objectID
            player.playerName = entity.name!
            player.playerLevel = Int(entity.level)
            player.playerStrength = Int(entity.strength)
        }
        
        class func map(from player: Player, to entity: PlayerEntity) {
            entity.name = player.playerName
            entity.level = Int16(player.playerLevel)
            entity.strength = Int16(player.playerStrength)
        }
        
        class func player(from entity: PlayerEntity) -> Player {
            let player = Player()
            map(from: entity, to: player)
            return player
        }
        
    }
    
    class GameTable {
        
    }
    
}
