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
            }, completion: { _ in
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
    
    func getPlayersByPosition() -> Observable<Player> {
        return Observable.create { subscriber in
            let context = NSManagedObjectContext.mr_default()
            let playersRequest = PlayerEntity.mr_requestAllSorted(by: "position",
                                                                  ascending: true,
                                                                  in: context)
            if let players = PlayerEntity.mr_executeFetchRequest(playersRequest) as? [PlayerEntity] {
                players.forEach { entity in
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
            let playingPlayersRequest = PlayerEntity.mr_requestAll(with: predicate, in: context)
            let descriptor = NSSortDescriptor(key: "position", ascending: true)
            playingPlayersRequest.sortDescriptors = [descriptor]
            if let players = PlayerEntity.mr_executeFetchRequest(playingPlayersRequest) as? [PlayerEntity] {
                for entity in players {
                    let player = Db.PlayerTable.player(from: entity)
                    subscriber.onNext(player)
                }
            }
            subscriber.onCompleted()
            return Disposables.create()
        }
    }
    
    func getPlayedPlayersByLevel() -> Observable<Player> {
        return Observable.create { subscriber in
            let context = NSManagedObjectContext.mr_default()
            let predicate = NSPredicate(format: "playing = \(true)")
            let playedPlayersRequest = PlayerEntity.mr_requestAll(with: predicate, in: context)
            let descriptor = NSSortDescriptor(key: "level", ascending: false)
            playedPlayersRequest.sortDescriptors = [descriptor]
            if let players = PlayerEntity.mr_executeFetchRequest(playedPlayersRequest) as? [PlayerEntity] {
                for entity in players {
                    let player = Db.PlayerTable.player(from: entity)
                    subscriber.onNext(player)
                }
            }
            subscriber.onCompleted()
            return Disposables.create()
        }
    }
    
    func getPlayedPlayersByStrength() -> Observable<Player> {
        return Observable.create { subscriber in
            let context = NSManagedObjectContext.mr_()
            let predicate = NSPredicate(format: "playing = \(true)")
            let playedPlayersRequest = PlayerEntity.mr_requestAll(with: predicate, in: context)
            let descriptor = NSSortDescriptor(key: "strength", ascending: false)
            playedPlayersRequest.sortDescriptors = [descriptor]
            if let players = PlayerEntity.mr_executeFetchRequest(playedPlayersRequest) as? [PlayerEntity] {
                for entity in players {
                    let player = Db.PlayerTable.player(from: entity)
                    subscriber.onNext(player)
                }
            }
            subscriber.onCompleted()
            return Disposables.create()
        }
    }
    
    func getPlayedPlayersByTotal() -> Observable<Player> {
        return Observable.create { subscriber in
            let context = NSManagedObjectContext.mr_()
            let predicate = NSPredicate(format: "playing = \(true)")
            let playedPlayersRequest = PlayerEntity.mr_requestAll(with: predicate, in: context)
            let levelSortDescriptor = NSSortDescriptor(key: "level", ascending: false)
            let strengthSortDescription = NSSortDescriptor(key: "strength", ascending: false)
            playedPlayersRequest.sortDescriptors = [levelSortDescriptor, strengthSortDescription]
            if let players = PlayerEntity.mr_executeFetchRequest(playedPlayersRequest) as? [PlayerEntity] {
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
            }, completion: { _ in
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
            }, completion: { _ in
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
            }, completion: { _ in
                subscriber.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func updatePlayerPosition(with id: String, position: Int) -> Observable<Void> {
        return Observable.create { subscriber in
            MagicalRecord.save({ (context) in
                let predicate = NSPredicate(format: "id = '\(id)'")
                if let entity = PlayerEntity.mr_findFirst(with: predicate, in: context) {
                    entity.position = Int16(position)
                } else {
                    subscriber.onCompleted()
                }
            }, completion: { _ in
                subscriber.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func setGameStep(gameStep: GameStep) -> Observable<Void> {
        return Observable.create { subscriber in
            MagicalRecord.save({ (context) in
                if let entity = GameStepEntity.mr_createEntity(in: context) {
                    Db.GameTable.map(from: gameStep, to: entity)
                } else {
                    subscriber.onCompleted()
                }
            }, completion: { _ in
                subscriber.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func getGameSteps() -> Observable<GameStep> {
        return Observable.create { subscriber in
            let context = NSManagedObjectContext.mr_default()
            if let gameSteps = GameStepEntity.mr_findAll(in: context) as? [GameStepEntity] {
                for entity in gameSteps {
                    let step = Db.GameTable.step(from: entity)
                    subscriber.onNext(step)
                }
            }
            subscriber.onCompleted()
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
                GameStepEntity.mr_truncateAll(in: context)
            }, completion: { _ in
                subscriber.onCompleted()
            })
            return Disposables.create()
        }
    }
    
}
