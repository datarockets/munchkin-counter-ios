//
//  EntityMapper.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 12.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

class EntityMapper {
    
    class func map(from entity: PlayerEntity, to player: Player) {
        player.playerId = entity.id!
        player.playerName = entity.name!
        player.playerLevel = Int(entity.level)
        player.playerStrength = Int(entity.strength)
    }
    
    class func map(from player: Player, to entity: PlayerEntity) {
        entity.id = player.playerId
        entity.name = player.playerName
        entity.level = Int16(player.playerLevel!)
        entity.strength = Int16(player.playerStrength!)
    }
    
    class func player(from entity: PlayerEntity) -> Player {
        let player = Player()
        map(from: entity, to: player)
        return player
    }
    
}
