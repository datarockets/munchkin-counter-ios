//
//  DashboardViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDelegate,
    UITableViewDataSource,
    DashboardView {

    var presenter: DashboardPresenter?
    
    private var playingPlayers: [Player] = []
    
    @IBOutlet weak var playingPlayersTableView: UITableView!
    @IBOutlet weak var playerViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playingPlayersTableView.delegate = self
        playingPlayersTableView.dataSource = self
        presenter?.attachView(self)
        presenter?.getPlayingPlayers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playingPlayersTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DashboardTableViewCell
        let player = playingPlayers[indexPath.row]
        cell.tvPlayerName.text = player.playerName
        cell.tvPlayerLevel.text = "\(player.playerLevel)"
        cell.tvPlayerStrength.text = "\(player.playerStrength)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playingPlayers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select row")
        let selectedPlayerId = playingPlayers[indexPath.row].playerId
        let playerView = self.childViewControllers[0] as? PlayerViewController
        playerView?.loadPlayerScores(playerId: selectedPlayerId!)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("Will select row at")
        return indexPath
    }
    
    func finishGame() {
        presenter?.setGameFinished()
        let gameResultViewController = storyboard?.instantiateViewController(withIdentifier: "gameResult")
        present(gameResultViewController!, animated: true, completion: nil)
    }
    
    
    @IBAction func onNextPlayerClick(_ sender: Any) {
        var selectedIndex = playingPlayersTableView.indexPathForSelectedRow?.row
        print("\(selectedIndex)")
        selectedIndex = selectedIndex! + 1
        let indexPath = IndexPath(row: selectedIndex!, section: 0)
        playingPlayersTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        
        let playerView = self.childViewControllers[0] as? PlayerViewController
        playerView?.loadPlayerScores(playerId: playingPlayers[selectedIndex!].playerId!)
        
    }
    
    @IBAction func onFinishGameButtonClick(_ sender: Any) {
        showConfirmFinishGameDialog()
    }
    
    func showConfirmFinishGameDialog() {
        let confirmFinishGameAlertDialog = UIAlertController(title: "Finish game", message: "Do you want to finish the game?", preferredStyle: .alert)
        let finishGameAction = UIAlertAction(title: "Yes", style: .default) { action in
            self.finishGame()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { action in
            print("Cancel")
        }
        confirmFinishGameAlertDialog.addAction(finishGameAction)
        confirmFinishGameAlertDialog.addAction(cancelAction)
        present(confirmFinishGameAlertDialog, animated: true, completion: nil)
    }
    
    func showRollDiceDialog() {
        
    }
    
    func setPlayers(players: Array<Player>) {
        self.playingPlayers = players
        playingPlayersTableView.reloadData()
        let selectedIndex = playingPlayersTableView.indexPathForSelectedRow
        playingPlayersTableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .top)
    }
    
    func updatePlayerInformation(player: Player, position: Int) {
    }

}
