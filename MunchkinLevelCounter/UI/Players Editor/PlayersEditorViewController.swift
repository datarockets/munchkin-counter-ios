//
//  PlayersEditorViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit
import Swinject
import UIImageView_Letters

class PlayersEditorViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, OnPlayerStatusChanged, PlayersEditorView {
    
    var presenter: PlayersEditorPresenter?
    
    private var players: [Player] = []
    
    @IBOutlet weak var playersListTableView: UITableView!
    @IBOutlet weak var btnLeftStart: UIBarButtonItem!
    @IBOutlet weak var btnRightAdd: UIBarButtonItem!
    @IBOutlet weak var btnRightReorder: UIBarButtonItem!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        playersListTableView.delegate = self
        playersListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.attachView(self)
        presenter?.getPlayers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.checkIsGameStarted()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = playersListTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PlayersEditorTableViewCell else { fatalError("Dequeuing reusable cell failed") }
        let player = players[indexPath.row]
        cell.playerStatus = self
        cell.swIsPlaying.isOn = player.isPlaying
        cell.tvPlayerName.text = player.playerName
        cell.ivPlayerImage?.setImageWith(player.playerName,
                                         color: UIColor.colorHash(hexString: player.playerName),
                                         circular: true)
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let playerId = players[indexPath.row].playerId
            players.remove(at: indexPath.row)
            presenter?.deletePlayer(playerId: playerId)
            playersListTableView.deleteRows(at: [indexPath], with: .automatic)
            refreshPositions()
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if playersListTableView.isEditing {
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let playerToMove = players[fromIndexPath.row]
        players.remove(at: fromIndexPath.row)
        players.insert(playerToMove, at: toIndexPath.row)
    }
    
    @IBAction func didTapStartButton(_ sender: Any) {
        presenter?.clearGameSteps()
        presenter?.checkIsEnoughPlayers()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        showAddNewPlayerAlertDialog()
    }
    
    @IBAction func didTapReorderButton(_ sender: Any) {
        if (!playersListTableView.isEditing) {
            playersListTableView.setEditing(true, animated: true)
            btnLeftStart.isEnabled = false
            btnRightAdd.isEnabled = false
        } else {
            refreshPositions()
            playersListTableView.setEditing(false, animated: true)
            btnLeftStart.isEnabled = true
            btnRightAdd.isEnabled = true
        }
    }
    
    func addPlayerToList(player: Player) {
        players.append(player)
        playersListTableView.reloadData()
    }
    
    func setPlayersList(players: [Player]) {
        self.players = players
        for (index, player) in self.players.enumerated() {
            loggingPrint("Player \(String(describing: player.playerName)) with position \(index)")
        }
        playersListTableView.reloadData()
    }
    
    func showAddNewPlayerAlertDialog() {
        let addNewPlayerAlert = UIAlertController(title: "button.add_new_player".localized,
                                                  message: "text.player_add_warning".localized, preferredStyle: .alert)
        addNewPlayerAlert.addTextField { textField in
            textField.placeholder = "text.player_name".localized
        }
        let addPlayerAction = UIAlertAction(title: "button.add_new_player".localized,
                                            style: .default) { _ in
            let enteredText = ((addNewPlayerAlert.textFields?.first)! as UITextField).text
            let playersCount = self.players.count
            self.presenter?.addPlayer(playerName: enteredText!,
                                      position: playersCount)
        }
        let cancelAction = UIAlertAction(title: "button.no".localized,
                                         style: .cancel,
                                         handler: nil)
        addNewPlayerAlert.addAction(addPlayerAction)
        addNewPlayerAlert.addAction(cancelAction)
        present(addNewPlayerAlert, animated: true, completion: nil)
    }
    
    func launchDashboard() {
        loggingPrint("launch dashboard")
        let dashboardViewController = storyboard?.instantiateViewController(withIdentifier: "dashboard") as? DashboardViewController
        presenter?.setGameStarted()
        self.navigationController?.pushViewController(dashboardViewController!, animated: true)
    }
    
    func showStartContinueDialog() {
        let startContinueAlert = UIAlertController(title: "dialog.start_continue_game.title".localized,
                                                   message: "dialog.start_continue_game.message".localized,
                                                   preferredStyle: .alert)
        let startNewGameAction = UIAlertAction(title: "button.start".localized,
                                               style: .destructive) { _ in
            self.presenter?.clearGameSteps()
            self.presenter?.setGameFinished()
        }
        let continueGameAction = UIAlertAction(title: "button.continue".localized,
                                               style: .default) { _ in
            self.launchDashboard()
        }
        startContinueAlert.addAction(startNewGameAction)
        startContinueAlert.addAction(continueGameAction)
        present(startContinueAlert, animated: true, completion: nil)
    }
    
    func showWarning() {
        let warningAlert = UIAlertController(title: "title.players_editor".localized,
                                             message: "text.player_add_warning".localized,
                                             preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
        warningAlert.addAction(cancelAction)
        present(warningAlert, animated: true, completion: nil)
    }

    func onPlayerStatus(position: Int, playing: Bool) {
        let playerId = players[position].playerId
        players[position].isPlaying = playing
        presenter?.markPlayerAsPlaying(withObjectId: playerId, isPlaying: playing)
    }
    
    func refreshPositions() {
        for (index, player) in players.enumerated() {
            loggingPrint("Player \(String(describing: player.playerName)) with position \(index)")
            presenter?.updatesPosition(playerId: player.playerId, position: index)
        }
    }
    
}
