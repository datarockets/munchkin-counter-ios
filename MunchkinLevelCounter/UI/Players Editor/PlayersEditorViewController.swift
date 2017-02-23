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
        cell.playerStatus = self
        cell.swIsPlaying.isOn = players[indexPath.row].isPlaying
        cell.tvPlayerName.text = players[indexPath.row].playerName
        cell.ivPlayerImage?.setImageWith(players[indexPath.row].playerName, color: nil, circular: true)
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
        let addNewPlayerAlert = UIAlertController(title: "Hello", message: "World", preferredStyle: .alert)
        addNewPlayerAlert.addTextField { textField in
            textField.placeholder = "Player Name"
        }
        let addPlayerAction = UIAlertAction(title: "Add Player", style: .default) { action in
            let enteredText = ((addNewPlayerAlert.textFields?.first)! as UITextField).text
            self.presenter?.addPlayer(playerName: enteredText!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addNewPlayerAlert.addAction(addPlayerAction)
        addNewPlayerAlert.addAction(cancelAction)
        present(addNewPlayerAlert, animated: true, completion: nil)
    }
    
    func launchDashboard() {
        let dashboardViewController = storyboard?.instantiateViewController(withIdentifier: "dashboard") as! DashboardViewController
        presenter?.setGameStarted()
        present(dashboardViewController, animated: true, completion: nil)
    }
    
    func showStartContinueDialog() {
        let startContinueAlert = UIAlertController(title: NSLocalizedString("dialog.start_continue_game.title", comment: ""), message: NSLocalizedString("dialog.start_continue_game.message", comment: ""), preferredStyle: .alert)
        let startNewGameAction = UIAlertAction(title: "Start", style: .destructive) { action in
            self.presenter?.setGameFinished()
        }
        let continueGameAction = UIAlertAction(title: "Continue", style: .default) { action in
            self.launchDashboard()
        }
        startContinueAlert.addAction(startNewGameAction)
        startContinueAlert.addAction(continueGameAction)
        present(startContinueAlert, animated: true, completion: nil)
    }
    
    func showWarning() {
        let warningAlert = UIAlertController(title: "Hello", message: NSLocalizedString("text.player_add_warning", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        warningAlert.addAction(cancelAction)
        present(warningAlert, animated: true, completion: nil)
    }
    
    @IBAction func onAddPlayerClick(_ sender: Any) {
        showAddNewPlayerAlertDialog()
    }
    
    @IBAction func onStartGameClick(_ sender: Any) {
        print("Check is enough players")
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
