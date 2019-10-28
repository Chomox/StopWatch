//
//  ViewController.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2019/10/15.
//  Copyright © 2019 Motoyuki Ito. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController {
	
	//MARK: - Constant
	private enum ButtonState: String {
		case start = "Start"
		case stop = "Stop"
		case lap = "Lap"
		case reset = "Reset"
	}

	
	//MARK: - Properties
	private let stopWatchModel = StopWatchModel()
	private var stopWatchView: StopWatchView?
	private weak var timer :Timer?
	
	
	//MARK: - Actions
	@IBAction private func startButtonTapped(){
		if timer == nil {
			timer = .scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateStopWatch), userInfo: nil, repeats: true)
			RunLoop.current.add(timer!, forMode: .common)
			stopWatchModel.start()
		} else {
			timer?.invalidate()
			
			timer = nil
			stopWatchModel.stop()
		}
		_switchButtonsAppearance(timerValid: stopWatchModel.isCounting)
	}
	
	@IBAction private func addButtonTapped(){
		switch stopWatchModel.isCounting {
		case true:
			self.stopWatchModel.add()
			stopWatchView?.lapsTableView.reloadData()
		case false:
			//ここなんでLap?
			stopWatchView?.lapButton.titleLabel?.text = ButtonState.lap.rawValue

			stopWatchModel.reset()
			stopWatchView?.lapsTableView.reloadData()
			
			stopWatchView?.timeLabel.text = stopWatchModel.time
		}
	}
	
	
	//MARK: - Life Cycle
	override func loadView() {
		super.loadView()
		self.view = StopWatchView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		stopWatchView = self.view as? StopWatchView
        stopWatchView?.lapsTableView.dataSource = stopWatchModel
		
		stopWatchView?.lapButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
		stopWatchView?.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
		
		stopWatchView?.timeLabel.text = stopWatchModel.time
		
		_switchButtonsAppearance(timerValid: stopWatchModel.isCounting)
	}
	
	
	//MARK: - Appearance
	private func _switchButtonsAppearance(timerValid: Bool){
		stopWatchView?.startButton.setTitle( timerValid ? ButtonState.stop.rawValue : ButtonState.start.rawValue, for: .normal)
		//FIXME: そのままの色にしない
		stopWatchView?.startButton.backgroundColor = timerValid ? .red : .green
		stopWatchView?.lapButton.setTitle( timerValid ? ButtonState.lap.rawValue : ButtonState.reset.rawValue, for: .normal)
	}
	
	
	//MARK: - TimerHandler
	@objc private func updateStopWatch(){
		stopWatchModel.update()
		self.stopWatchView?.timeLabel.text = stopWatchModel.time
	}
}
