//
//  ChartsViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 21.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {

    var presenter: ChartsPresenter?
    fileprivate var playedPlayers: [Player] = []
    fileprivate var currentScoreType: ScoreType?
    
    @IBOutlet weak fileprivate var lineChartView: LineChartView!
    @IBOutlet weak fileprivate var playedPlayersTableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playedPlayersTableView.dataSource = self
        playedPlayersTableView.delegate = self
        presenter?.attachView(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
    // MARK: Helpers
    
    func loadChartData(chartType: ScoreType) {
        currentScoreType = chartType
        presenter?.loadChartData(type: chartType)
        presenter?.loadPlayers(sortType: chartType)
    }

}

extension ChartsViewController: ChartsView {
    
    func showPlayersList(players: [Player]) {
        playedPlayers = players
        playedPlayersTableView.reloadData()
    }
    
    func showPlayersCharts(chartData: ChartData) {
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.leftAxis.granularity = 1
        lineChartView.chartDescription?.enabled = false
        lineChartView.data = chartData
        lineChartView.invalidateIntrinsicContentSize()
    }
    
}

// MARK: UITableViewDelegate & UITableViewDataSource

extension ChartsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playedPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = playedPlayersTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChartsTableViewCell else { fatalError("Dequeuing reusable cell failed") }
        let player = playedPlayers[indexPath.row]
        
        cell.ivPlayerImage?.setImageWith(player.playerName, color: UIColor.colorHash(hexString: player.playerName), circular: true)
        cell.tvPlayerName.text = player.playerName
        
        switch currentScoreType! {
        case .levelScore:
            cell.tvPlayerScore.text = "\(player.playerLevel)"
        case .strengthScore:
            cell.tvPlayerScore.text = "\(player.playerStrength)"
        case .totalScore:
            cell.tvPlayerScore.text = "\(player.getTotalScore())"
        }
        
        return cell
    }
    
}
