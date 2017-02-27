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

class PlayersEditorViewController: UIViewController, UITableViewDelegate,
    UITableViewDataSource,
    OnPlayerStatusChanged,
    PlayersEditorView {
    
    var presenter: PlayersEditorPresenter?
    
    private var players: [Player] = []
    
    @IBOutlet weak var playersListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playersListTableView.delegate = self
        playersListTableView.dataSource = self
        presenter?.attachView(self)
        presenter?.getPlayers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.checkIsGameStarted()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersListTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlayersEditorTableViewCell
        let player = players[indexPath.row]
        cell.playerStatus = self
        cell.swIsPlaying.isOn = player.isPlaying
        cell.tvPlayerName.text = player.playerName
        cell.ivPlayerImage?.setImageWith(player.playerName, color: UIColor.colorHash(name: player.playerName), circular: true)
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                presenter?.deletePlayer(playerId: players[indexPath.row].playerId!)
                players.remove(at: indexPath.row)
                playersListTableView.deleteRows(at: [indexPath], with: .automatic)
                break
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func addPlayerToList(player: Player) {
        players.append(player)
        playersListTableView.reloadData()
    }
    
    func setPlayersList(players: Array<Player>) {
        self.players = players
        playersListTableView.reloadData()
    }
    
    func showAddNewPlayerAlertDialog() {
        let addNewPlayerAlert = UIAlertController(title: "dialog.add_player.title".localized,
                                                  message: "dialog.add_player.message".localized, preferredStyle: .alert)
        addNewPlayerAlert.addTextField { textField in
            textField.placeholder = "text.player_name".localized
        }
        let addPlayerAction = UIAlertAction(title: "button.add_new_player".localized, style: .default) { action in
            let enteredText = ((addNewPlayerAlert.textFields?.first)! as UITextField).text
            self.presenter?.addPlayer(playerName: enteredText!)
        }
        let cancelAction = UIAlertAction(title: "button.cancel".localized, style: .cancel, handler: nil)
        addNewPlayerAlert.addAction(addPlayerAction)
        addNewPlayerAlert.addAction(cancelAction)
        present(addNewPlayerAlert, animated: true, completion: nil)
    }
    
    func launchDashboard() {
        let dashboardViewController = storyboard?.instantiateViewController(withIdentifier: "dashboard") as! DashboardViewController
        presenter?.setGameStarted()
        present(dashboardViewController, animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func showStartContinueDialog() {
        let startContinueAlert = UIAlertController(title: "dialog.start_continue_game.title".localized,
                                                   message: "dialog.start_continue_game.message".localized, preferredStyle: .alert)
        let startNewGameAction = UIAlertAction(title: "button.start".localized, style: .destructive) { action in
            self.presenter?.setGameFinished()
        }
        let continueGameAction = UIAlertAction(title: "button.continue".localized, style: .default) { action in
            self.launchDashboard()
        }
        startContinueAlert.addAction(startNewGameAction)
        startContinueAlert.addAction(continueGameAction)
        present(startContinueAlert, animated: true, completion: nil)
    }
    
    func showWarning() {
        let warningAlert = UIAlertController(title: "Warning", message:
            "text.player_add_warning".localized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        warningAlert.addAction(cancelAction)
        present(warningAlert, animated: true, completion: nil)
    }
    
    @IBAction func onAddPlayerClick(_ sender: Any) {
        showAddNewPlayerAlertDialog()
    }
    
    @IBAction func onStartGameClick(_ sender: Any) {
        presenter?.checkIsEnoughPlayers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onPlayerStatus(position: Int, playing: Bool) {
        let playerId = players[position].playerId
        players[position].isPlaying = playing
        presenter?.markPlayerAsPlaying(withObjectId: playerId!, isPlaying: playing)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
}
