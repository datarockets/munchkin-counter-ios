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
            player.playerId = entity.id
            player.playerName = entity.name!
            player.playerLevel = Int(entity.level)
            player.playerStrength = Int(entity.strength)
            player.playerColor = entity.color
            player.isPlaying = entity.playing
        }
        
        class func map(from player: Player, to entity: PlayerEntity) {
            entity.id = player.playerId
            entity.name = player.playerName
            entity.level = Int16(player.playerLevel)
            entity.strength = Int16(player.playerStrength)
            entity.color = player.playerColor
            entity.playing = player.isPlaying
        }
        
        class func player(from entity: PlayerEntity) -> Player {
            let player = Player()
            map(from: entity, to: player)
            return player
        }
        
    }
    
    class GameTable {
        
        class func map(from entity: GameStepEntity, to step: GameStep) {
            step.playerId = entity.playerId
            step.playerLevel = Int(entity.playerLevel)
            step.playerStrength = Int(entity.playerStrength)
        }
        
        class func map(from step: GameStep, to entity: GameStepEntity) {
            entity.playerId = step.playerId
            entity.playerLevel = Int16(step.playerLevel!)
            entity.playerStrength = Int16(step.playerStrength!)
        }
        
        class func step(from entity: GameStepEntity) -> GameStep {
            let gameStep = GameStep()
            map(from: entity, to: gameStep)
            return gameStep
        }
        
    }
    
}
