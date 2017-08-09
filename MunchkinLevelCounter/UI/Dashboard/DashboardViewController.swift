//
//  DashboardViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, OnScoreChangedDelegate, DashboardView {

    var presenter: DashboardPresenter?
    
    private var playingPlayers: [Player] = []
    
    @IBOutlet weak var playingPlayersTableView: UITableView!
    @IBOutlet weak var playerViewController: PlayerViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playingPlayersTableView.delegate = self
        playingPlayersTableView.dataSource = self
        presenter?.attachView(self)
        presenter?.getPlayingPlayers()
        playerViewController = self.childViewControllers.first as? PlayerViewController
        playerViewController?.scoreChangedDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = playingPlayersTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DashboardTableViewCell else { fatalError("Dequeing reusable cell failed") }
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
        let selectedPlayerId = playingPlayers[indexPath.row].playerId
        playerViewController?.loadPlayerScores(playerId: selectedPlayerId, playerPosition: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func finishGame() {
        presenter?.setGameFinished()
        guard let gameResultViewController = storyboard?.instantiateViewController(withIdentifier: "gameResult") else { return }
        self.navigationController?.pushViewController(gameResultViewController, animated: true)
    }
    
    @IBAction func onNextPlayerClick(_ sender: Any) {
        var selectedIndex = playingPlayersTableView.indexPathForSelectedRow?.row
        loggingPrint("onNextPlayerClick selected index \(String(describing: selectedIndex))")
        if (selectedIndex == playingPlayers.count - 1) {
            let indexPath = IndexPath(row: 0, section: 0)
            playingPlayersTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            tableView(playingPlayersTableView, didSelectRowAt: indexPath)
            selectedIndex = 0
        } else {
            selectedIndex! += 1
            let indexPath = IndexPath(row: selectedIndex!, section: 0)
            playingPlayersTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            tableView(playingPlayersTableView, didSelectRowAt: indexPath)
        }

    }

    @IBAction func onFinishGameButtonClick(_ sender: Any) {
        showConfirmFinishGameDialog()
    }
    
    func showConfirmFinishGameDialog() {
        let confirmFinishGameAlertDialog = UIAlertController(title: NSLocalizedString("dialog.finish_game.title", comment: ""),
                                                             message: NSLocalizedString("dialog.finish_game.message", comment: ""),
                                                             preferredStyle: .alert)
        let finishGameAction = UIAlertAction(title: NSLocalizedString("button.yes", comment: ""),
                                             style: .default) { _ in
            self.finishGame()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("button.no", comment: ""),
                                         style: .cancel) { _ in
            print("Cancel")
        }
        confirmFinishGameAlertDialog.addAction(finishGameAction)
        confirmFinishGameAlertDialog.addAction(cancelAction)
        present(confirmFinishGameAlertDialog, animated: true, completion: nil)
    }
    
    func showRollDiceDialog() {
        
    }
    
    func setPlayers(players: [Player]) {
        self.playingPlayers = players
        playingPlayersTableView.reloadData()
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        playingPlayersTableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .top)
        tableView(playingPlayersTableView, didSelectRowAt: selectedIndexPath)
    }
    
    func updatePlayerInformation(player: Player, position: Int) {
        
    }
    
    func onScoreChanged(playerPosition: Int, playerLevel: Int, playerStrength: Int) {
        playingPlayers[playerPosition].playerLevel = playerLevel
        playingPlayers[playerPosition].playerStrength = playerStrength
        presenter?.insertStep(playerId: playingPlayers[playerPosition].playerId,
                              levelScore: playerLevel,
                              strengthScore: playerStrength)
        let selectedIndexPath = IndexPath(row: playerPosition, section: 0)
        loggingPrint("onScoreChanged selectedIndex \(selectedIndexPath)")
        playingPlayersTableView.reloadRows(at: [selectedIndexPath], with: .none)
        playingPlayersTableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
    }

}
