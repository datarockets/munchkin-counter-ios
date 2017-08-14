//
//  DashboardViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController {
    
    var presenter: DashboardPresenter?
    fileprivate var playingPlayers: [Player] = []
    
    @IBOutlet weak fileprivate var playingPlayersTableView: UITableView!
    @IBOutlet weak fileprivate var playerViewController: PlayerViewController!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playingPlayersTableView.delegate = self
        playingPlayersTableView.dataSource = self
        presenter?.attachView(self)
        presenter?.getPlayingPlayers()
        playerViewController = self.childViewControllers.first as? PlayerViewController
        playerViewController?.scoreChangedDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
    // MARK: Actions
    
    @IBAction func didTapNextPlayerButton(_ sender: Any) {
        presenter?.nextPlayer()
    }
    
    @IBAction func didTapFinishGameButton(_ sender: Any) {
        presenter?.finishGameWithConfirmation()
    }
    
    @IBAction func didTapDiceButton(_ sender: Any) {
        presenter?.rollTheDice()
    }
    
    // MARK: Helpers
    
    fileprivate func showRollTheDiceDialog() {
        let diceValue = Int(arc4random_uniform(6) + 1)
        let diceAlertDialog = UIAlertController(title: String(format: "text.dice".localized, diceValue),
                                                message: "",
                                                preferredStyle: .alert)
        let closelAction = UIAlertAction(title: "Ok",
                                         style: .default,
                                         handler: nil)
        diceAlertDialog.addAction(closelAction)
        present(diceAlertDialog, animated: true, completion: nil)
    }
    
}

// MARK: PlayersEditorView

extension DashboardViewController: DashboardView {
 
    func setPlayers(players: [Player]) {
        self.playingPlayers = players
        playingPlayersTableView.reloadData()
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        playingPlayersTableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .top)
        tableView(playingPlayersTableView, didSelectRowAt: selectedIndexPath)
    }
    
    func rollTheDice() {
        self.showRollTheDiceDialog()
    }
    
    func nextPlayer() {
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
    
    func showFinishGameConfirmationDialog() {
        let confirmFinishGameAlertDialog = UIAlertController(title: NSLocalizedString("dialog.finish_game.title", comment: ""),
                                                             message: NSLocalizedString("dialog.finish_game.message", comment: ""),
                                                             preferredStyle: .alert)
        let finishGameAction = UIAlertAction(title: NSLocalizedString("button.yes", comment: ""),
                                             style: .default) { _ in
                                                self.finishGame()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("button.no", comment: ""),
                                         style: .cancel) { _ in }
        confirmFinishGameAlertDialog.addAction(finishGameAction)
        confirmFinishGameAlertDialog.addAction(cancelAction)
        present(confirmFinishGameAlertDialog, animated: true, completion: nil)
    }
    
    func finishGame() {
        presenter?.setGameFinished()
        guard let gameResultViewController = storyboard?.instantiateViewController(withIdentifier: "gameResult") else { return }
        self.navigationController?.pushViewController(gameResultViewController, animated: true)
    }
    
}

// MARK: UITableViewDelegate & UITableViewDataSource

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
}

// MARK: OnScoreChanged Delegate

extension DashboardViewController: OnScoreChangedDelegate {
    
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
