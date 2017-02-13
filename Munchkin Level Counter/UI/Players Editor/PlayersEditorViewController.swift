//
//  PlayersEditorViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit
import Swinject

class PlayersEditorViewController: UIViewController, PlayersEditorView {

    var presenter: PlayersEditorPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
        presenter?.getPlayers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
    func showPlayers() {
        
    }
    
    func showText() {
        print("Hello world")
    }

    func addPlayerToList(playerItem: Player) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
