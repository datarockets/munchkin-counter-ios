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
    func deletePlayerFromList(playerId: String)
    func setPlayersList(players: Array<Player>)
    func showAddNewPlayerAlertDialog()
    func launchDashboard()
    func showStartContinueDialog()
    func showWarning()
}
