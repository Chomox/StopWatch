//
//  ViewController.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2019/10/15.
//  Copyright © 2019 Motoyuki Ito. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController {

	//MARK: - Properties
	private let stopWatchModel = StopWatchModel()
	
	private weak var timer :Timer?
	private weak var lapTimer :Timer?
	
	//MARK: - View Life Cycle
	override func loadView() {
		super.loadView()
		self.view = StopWatchView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let stopWatchView = self.view as? StopWatchView
        //stopWatchView.refreshControl.addTarget(self, action: "tableUpdate:", forControlEvents: UIControlEvents.ValueChanged)
		stopWatchView?.lapsTableView.delegate = self
        stopWatchView?.lapsTableView.dataSource = stopWatchModel
	}
}

extension StopWatchViewController: UITableViewDelegate {
	
}

