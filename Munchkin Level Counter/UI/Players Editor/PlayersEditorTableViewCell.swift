//
//  PlayersEditorTableViewCell.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 15.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit

protocol OnPlayerStatusChanged {
    func onPlayerStatus(position: Int)
}

class PlayersEditorTableViewCell: UITableViewCell {
    @IBOutlet weak var ivPlayerImage: UIImageView?
    @IBOutlet weak var tvPlayerName: UILabel!
    @IBOutlet weak var swIsPlaying: UISwitch!
    var playerStatus: OnPlayerStatusChanged?
    
    @IBAction func onPlayingStatusChanged(_ sender: Any) {
        playerStatus?.onPlayerStatus(position: tag)
    }
    
}
