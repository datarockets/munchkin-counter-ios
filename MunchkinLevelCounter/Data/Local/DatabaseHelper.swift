//
//  DatabaseHelper.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord
import RxSwift

class DatabaseHelper {

    
    func setPlayer(player: Player) -> Observable<Player> {
        return Observable.create { subscriber in
            MagicalRecord.save({ (context) in
                if let entity = PlayerEntity.mr_createEntity(in: context) {
                    Db.PlayerTable.map(from: player, to: entity)
                } else {
                    subscriber.onCompleted()
                }
            }, completion: { success, error in
                subscriber.onNext(player)
                subscriber.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func getPlayer(playerId: String) -> Observable<Player> {
        return Observable.create { subscriber in
            let context = NSManagedObjectContext.mr_()
            let predicate = NSPredicate(format: "id = '\(playerId)'")
            if let entity = PlayerEntity.mr_findFirst(with: predicate, in: context) {
                let player = Db.PlayerTable.player(from: entity)
                subscriber.onNext(player)
            }
            subscriber.onCompleted()
            return Disposables.create()
        }
    }
    
    func getPlayers() -> Observable<Player> {
        return Observable.create { subscriber in
            let context = NSManagedObjectContext.mr_default()
            if let players = PlayerEntity.mr_findAll(in: context) as? [PlayerEntity] {
                for entity in players {
                    let player = Db.PlayerTable.player(from: entity)
                    subscriber.onNext(player)
                }
            }
            subscriber.onCompleted()
            return Disposables.create()
        }
    }
    
    func getPlayingPlayers() -> Observable<Player> {
        return Observable.create { subscriber in
            let context = NSManagedObjectContext.mr_()
            let predicate = NSPredicate(format: "playing = \(true)")
            if let players = PlayerEntity.mr_findAll(with: predicate, in: context) as? [PlayerEntity] {
                for entity in players {
                    let player = Db.PlayerTable.player(from: entity)
                    subscriber.onNext(player)
                }
            }
            subscriber.onCompleted()
            return Disposables.create()
        }
    }
    
    func deletePlayer(withId id: String) -> Observable<Void> {
        return Observable.create { subscriber in
            MagicalRecord.save({ (context) in
                let predicate = NSPredicate(format: "id = '\(id)'")
                PlayerEntity.mr_deleteAll(matching: predicate, in: context)
            }, completion: { success, error in
                subscriber.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func updatePlayerScores(withId id: String, levelScore: Int, strengthScore: Int) -> Observable<Void> {
        return Observable.create { subscriber in
            MagicalRecord.save({ (context) in
                let predicate = NSPredicate(format: "id = '\(id)'")
                if let entity = PlayerEntity.mr_findFirst(with: predicate, in: context) {
                    entity.level = Int16(levelScore)
                    entity.strength = Int16(strengthScore)
                } else {
                    subscriber.onCompleted()
                }
            }, completion: { success, error in
                subscriber.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func markPlayerPlaying(withId id: String, isPlaying: Bool) -> Observable<Void> {
        return Observable.create { subscriber in
            MagicalRecord.save({ (context) in
                let predicate = NSPredicate(format: "id = '\(id)'")
                if let entity = PlayerEntity.mr_findFirst(with: predicate, in: context) {
                    entity.playing = isPlaying
                } else {
                    subscriber.onCompleted()
                }
            }, completion: { success, error in
                subscriber.onCompleted()
            })
            return Disposables.create()
        }
    }

    func clearGameSteps() -> Observable<Void> {
        return Observable.create { subscriber in
            MagicalRecord.save({ (context) in
                if let players = PlayerEntity.mr_findAll(in: context) as? [PlayerEntity] {
                    players.forEach({ (entity) in
                        entity.level = Int16(1)
                        entity.strength = Int16(1)
                    })
                } else {
                    subscriber.onCompleted()
                }
            }, completion: { success, error in
                subscriber.onCompleted()
            })
            return Disposables.create()
        }
    }
    
}
