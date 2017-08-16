//
//  PlayersEditorTableViewCell.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 15.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit

protocol OnPlayerStatusChangedDelegate: class {
    
    func onPlayerStatus(position: Int, playing: Bool)
    
}

class PlayersEditorTableViewCell: UITableViewCell {
    
    weak var playerStatus: OnPlayerStatusChangedDelegate?
    
    @IBOutlet weak var ivPlayerImage: UIImageView?
    @IBOutlet weak var tvPlayerName: UILabel!
    @IBOutlet weak var swIsPlaying: UISwitch!
    
    @IBAction func onPlayingStatusChanged(_ sender: Any) {
        if swIsPlaying.isOn {
            playerStatus?.onPlayerStatus(position: tag, playing: true)
        } else {
            playerStatus?.onPlayerStatus(position: tag, playing: false)
        }
    }
    
}
