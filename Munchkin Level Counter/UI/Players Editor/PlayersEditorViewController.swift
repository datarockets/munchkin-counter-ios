//
//  PlayersEditorViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit
import Swinject

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
        presenter?.checkIsGameStarted()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersListTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlayersEditorTableViewCell
        cell.swIsPlaying.isOn = players[indexPath.row].isPlaying
        cell.tvPlayerName.text = players[indexPath.row].playerName
        cell.tag = indexPath.row
        cell.playerStatus = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func addPlayerToList(player: Player) {
        players.append(player)
        playersListTableView.reloadData()
    }
    
    func deletePlayerFromList(playerId: String) {
        players.remove(at: Int(playerId)!)
        playersListTableView.reloadData()
    }
    
    func setPlayersList(players: Array<Player>) {
        self.players = players
        playersListTableView.reloadData()
    }
    
    func showAddNewPlayerAlertDialog() {
        let addNewPlayerAlert = UIAlertController(title: "Hello", message: "World", preferredStyle: UIAlertControllerStyle.alert)
        addNewPlayerAlert.addTextField { textField in
            textField.placeholder = "Player Name"
        }
        let addPlayerAction = UIAlertAction(title: "Add Player", style: UIAlertActionStyle.default) { action in
            let enteredText = ((addNewPlayerAlert.textFields?.first)! as UITextField).text
            self.presenter?.addPlayer(playerName: enteredText!)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertActionStyle.cancel, handler: nil)
        addNewPlayerAlert.addAction(addPlayerAction)
        addNewPlayerAlert.addAction(cancelAction)
        present(addNewPlayerAlert, animated: true, completion: nil)
    }
    
    func launchDashboard() {
        let dashboardViewController = storyboard?.instantiateViewController(withIdentifier: "hello") as! DashboardViewController
        present(dashboardViewController, animated: true, completion: nil)
    }
    
    func showStartContinueDialog() {
        
    }
    
    func showWarning() {
        
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

    func onPlayerStatus(position: Int) {
        print("hello \(position)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
}
