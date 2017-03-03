//
//  DashboardView.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation

protocol DashboardView: BaseView {
    func finishGame()
    func setPlayers(players: [Player])
    func showConfirmFinishGameDialog()
    func showRollDiceDialog()
    func updatePlayerInformation(player: Player, position: Int)
}
