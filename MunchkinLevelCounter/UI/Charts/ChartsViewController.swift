//
//  ChartsViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 21.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController,
    ChartsView,
    UITableViewDelegate,
    UITableViewDataSource {

    var presenter: ChartsPresenter?

    var playedPlayers: [Player] = []
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var playedPlayersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playedPlayersTableView.dataSource = self
        playedPlayersTableView.delegate = self
        presenter?.attachView(self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playedPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playedPlayersTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChartsTableViewCell
        return cell
    }
    
    func showPlayersList(players: Array<Player>) {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }

}
