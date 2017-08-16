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

class PlayersEditorViewController: BaseViewController {
    
    var presenter: PlayersEditorPresenter?
    fileprivate var players: [Player] = []
    private var editingPlayerName: String?
    
    @IBOutlet weak fileprivate var playersListTableView: UITableView!
    @IBOutlet weak fileprivate var btnLeftStart: UIBarButtonItem!
    @IBOutlet weak fileprivate var btnRightAdd: UIBarButtonItem!
    @IBOutlet weak fileprivate var btnRightReorder: UIBarButtonItem!
    
    // MARK: Lifecycle
    
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
    
    // MARK: Actions
    
    @IBAction func didTapStartButton(_ sender: Any) {
        presenter?.clearGameSteps()
        presenter?.checkIsEnoughPlayers()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        presenter?.addNewPlayer()
    }
    
    @IBAction func didTapReorderButton(_ sender: Any) {
        presenter?.toggleReorder()
    }
    
    // MARK: Helpers
    
    fileprivate func isValidName(name: String?) -> Bool {
        return name != "" && !players.filter { $0.playerName != editingPlayerName }.contains(where: { player in player.playerName == name })
    }
    
    @objc fileprivate func validate(_ textField: UITextField) {
        var responder: UIResponder! = textField
        while !(responder is UIAlertController) {
            responder = responder.next
        }
        guard let alert = responder as? UIAlertController else {
            return
        }
        alert.actions[0].isEnabled = self.isValidName(name: textField.text)
    }
    
    fileprivate func showAddNewPlayerDialog() {
        let alert = UIAlertController(title: "button.add_new_player".localized, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "text.player_name".localized
            textField.addTarget(self, action: #selector(self.validate(_:)), for: .editingChanged)
        }
        let addPlayerAction = UIAlertAction(title: "button.add_new_player".localized,
                                            style: .default) { _ in
                                                alert.textFields?[0].removeTarget(nil, action: nil, for: .allEvents)
                                                let enteredText = ((alert.textFields?.first)! as UITextField).text
                                                let playersCount = self.players.count
                                                self.presenter?.addPlayer(playerName: enteredText!,
                                                                          position: playersCount)
        }
        let cancelAction = UIAlertAction(title: "button.cancel".localized,
                                         style: .cancel) { _ in
                                            alert.textFields?[0].removeTarget(nil, action: nil, for: .allEvents)
        }
        alert.addAction(addPlayerAction)
        alert.addAction(cancelAction)
        alert.actions[0].isEnabled = false
        
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showEditPlayerDialog(indexPath: IndexPath) {
        let alert = UIAlertController(title: "dialog.player_actions.edit_player".localized, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            self.editingPlayerName = self.players[indexPath.row].playerName
            textField.text = self.editingPlayerName
            textField.addTarget(self, action: #selector(self.validate(_:)), for: .editingChanged)
        }
        let confirmEditPlayerAction = UIAlertAction(title: "button.edit".localized,
                                                    style: .default) { _ in
                                                        alert.textFields?[0].removeTarget(nil, action: nil, for: .allEvents)
                                                        let player = self.players[indexPath.row]
                                                        player.playerName = ((alert.textFields?.first)! as UITextField).text
                                                        self.presenter?.updatePlayer(player: player)
        }
        let cancelEditPlayerAction = UIAlertAction(title: "button.cancel".localized,
                                                   style: .cancel) { _ in
                                                    alert.textFields?[0].removeTarget(nil, action: nil, for: .allEvents)
                                                    self.playersListTableView.setEditing(false, animated: true)
        }
        alert.addAction(confirmEditPlayerAction)
        alert.addAction(cancelEditPlayerAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showStartContinueGameDialog() {
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
    
    fileprivate func showNotEnoughPlayersAlert() {
        let warningAlert = UIAlertController(title: "text.not_enough_players.title".localized,
                                             message: "text.player_add_warning".localized,
                                             preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
        warningAlert.addAction(cancelAction)
        
        present(warningAlert, animated: true, completion: nil)
    }
    
    fileprivate func showPlayerDeleteAlert(indexPath: IndexPath) {
        let deleteAlert = UIAlertController(title: "dialog.player_delete.title".localized,
                                            message: String(format: "dialog.player_delete.message".localized,
                                                            players[indexPath.row].playerName ?? ""),
                                            preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "button.cancel".localized,
                                         style: .cancel) { _ in
                                            self.playersListTableView.setEditing(false, animated: true)
        }
        let deleteAction = UIAlertAction(title: "button.delete".localized,
                                         style: .destructive) {_ in
                                            self.deletePlayer(indexPath: indexPath)
        }
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(deleteAction)
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    fileprivate func refreshPositions() {
        for (index, player) in players.enumerated() {
            loggingPrint("Player \(String(describing: player.playerName)) with position \(index)")
            presenter?.updatesPosition(playerId: player.playerId, position: index)
        }
    }
    
    fileprivate func deletePlayer(indexPath: IndexPath) {
        let playerId = players[indexPath.row].playerId
        players.remove(at: indexPath.row)
        presenter?.deletePlayer(playerId: playerId)
        playersListTableView.deleteRows(at: [indexPath], with: .automatic)
        refreshPositions()
    }
    
}

// MARK: PlayersEditorView

extension PlayersEditorViewController: PlayersEditorView {
    
    func addPlayerToList(player: Player) {
        players.append(player)
    }
    
    func updatePlayerList() {
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
        showAddNewPlayerDialog()
    }
    
    func launchDashboard() {
        loggingPrint("launch dashboard")
        let dashboardViewController = storyboard?.instantiateViewController(withIdentifier: "dashboard") as? DashboardViewController
        presenter?.setGameStarted()
        self.navigationController?.pushViewController(dashboardViewController!, animated: true)
    }
    
    func showStartContinueDialog() {
        showStartContinueGameDialog()
    }
    
    func showNotEnoughPlayersWarning() {
        showNotEnoughPlayersAlert()
    }
    
    func toggleReorder() {
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
    
}

// MARK: UITableViewDelegate & UITableViewDataSource

extension PlayersEditorViewController : UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "button.edit".localized) {_, _ in
            self.showEditPlayerDialog(indexPath: indexPath)
        }
        edit.backgroundColor = Colors.green
        let delete = UITableViewRowAction(style: .normal, title: "button.delete".localized) {_, _ in
            self.showPlayerDeleteAlert(indexPath: indexPath)
        }
        delete.backgroundColor = Colors.red
        
        return [delete, edit]
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
    
}

// MARK: UITextFieldDelegate

extension PlayersEditorViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        loggingPrint(textField.text)
    }
    
}

// MARK: OnPlayerStatusChangedDelegate

extension PlayersEditorViewController: OnPlayerStatusChangedDelegate {
    
    func onPlayerStatus(position: Int, playing: Bool) {
        let playerId = players[position].playerId
        players[position].isPlaying = playing
        presenter?.markPlayerAsPlaying(withObjectId: playerId, isPlaying: playing)
    }
    
}
