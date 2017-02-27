//
//  GameResultViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 16.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit

class GameResultViewController: UIViewController, GameResultView {

    var presenter: GameResultPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.detachView()
    }

    @IBAction func onEditorButtonClick(_ sender: Any) {
        presenter?.clearGameResults()
        let playersEditorViewController = storyboard?.instantiateInitialViewController()
        present(playersEditorViewController!, animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
