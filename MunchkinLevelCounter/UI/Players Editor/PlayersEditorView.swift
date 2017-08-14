//
//  PlayersEditorView.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation

protocol PlayersEditorView: BaseView {
    
    func addPlayerToList(player: Player)
    func updatePlayerList()
    func setPlayersList(players: [Player])
    func showAddNewPlayerAlertDialog()
    func launchDashboard()
    func showStartContinueDialog()
    func showNotEnoughPlayersWarning()
    
}
