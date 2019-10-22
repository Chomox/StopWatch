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
	private var stopWatchView: StopWatchView?
	private weak var timer :Timer?
	private weak var lapTimer :Timer?

	
	//MARK: - Actions
	@IBAction private func timerValidSwitch(){
		if timer == nil {
			timer = .scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateStopWatch), userInfo: nil, repeats: true)
			lapTimer = .scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateStopWatch), userInfo: nil, repeats: true)
			RunLoop.current.add(timer!, forMode: .common)
			RunLoop.current.add(lapTimer!, forMode: .common)
			stopWatchModel.start()
		} else {
			timer?.invalidate()
			lapTimer?.invalidate()
			timer = nil
			lapTimer = nil
			stopWatchModel.stop()
		}
		_changeButtonsAppearance(timerValid: stopWatchModel.isCounting)
	}
	
	@IBAction private func addButtonTapped(){
		switch stopWatchModel.isCounting {
		case true:
			self.stopWatchModel.add()
			stopWatchView?.lapsTableView.reloadData()
		case false:
			//ここなんでLap?
			stopWatchView?.lapButton.titleLabel?.text = "Lap"

			stopWatchModel.reset()
			stopWatchView?.lapsTableView.reloadData()
			
			stopWatchView?.timeLabel.text = stopWatchModel.time
		}
	}
	
	
	//MARK: - View Life Cycle
	override func loadView() {
		super.loadView()
		self.view = StopWatchView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		stopWatchView = self.view as? StopWatchView
        stopWatchView?.lapsTableView.dataSource = stopWatchModel
		
		stopWatchView?.lapButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
		stopWatchView?.startButton.addTarget(self, action: #selector(timerValidSwitch), for: .touchUpInside)
		
		stopWatchView?.timeLabel.text = stopWatchModel.time
	}
	
	
	//MARK: - Appearance
	private func _viewInitialize(){
		stopWatchView?.timeLabel.backgroundColor = UIColor(red: 92/255, green: 98/255, blue: 114/255, alpha: 1.0)
		stopWatchView?.timeLabel.tintColor = .white
		stopWatchView?.timeLabel.text = stopWatchModel.time
		
		_changeButtonsAppearance(timerValid: stopWatchModel.isCounting)
	}
	
	private func _changeButtonsAppearance(timerValid: Bool){
		stopWatchView?.startButton.setTitle( timerValid ? "Stop" : "Start", for: .normal)
		stopWatchView?.startButton.backgroundColor = timerValid ? .red : .green
		stopWatchView?.lapButton.setTitle( timerValid ? "Lap" : "Reset", for: .normal)
	}
	
	
	//MARK: - TimerHandler
	@objc private func updateStopWatch(){
		stopWatchModel.update()
		self.stopWatchView?.timeLabel.text = stopWatchModel.time
	}
}
