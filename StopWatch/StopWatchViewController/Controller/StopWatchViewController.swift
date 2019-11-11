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
			//TODO: timeずれ問題絵を解決する
			
			timer = .scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateStopWatch), userInfo: nil, repeats: true)
			RunLoop.current.add(timer!, forMode: .common)
			stopWatchModel.start()
		} else {
			timer?.invalidate()
			
			timer = nil
			stopWatchModel.stop()
		}
		_switchButtonsAppearance(state: stopWatchModel.state)
	}
	
	@IBAction private func addButtonTapped(){
		switch stopWatchModel.state {
		case .valid:
			self.stopWatchModel.add()
			stopWatchView?.lapsTableView.reloadData()
		case .invalid:
			
			

			self.stopWatchModel.reset()
			self.stopWatchView?.lapsTableView.reloadData()
			
			self.stopWatchView?.timeLabel.text = stopWatchModel.time
			self._switchButtonsAppearance(state: stopWatchModel.state)
			
		default: break
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
		
		_switchButtonsAppearance(state: stopWatchModel.state)
	}
	
	
	//MARK: - Appearance
	private func _switchButtonsAppearance(state: StopWatchModel.TimerState ){
		
		//FIXME: そのままの色にしない
		switch state {
		case .valid:
			stopWatchView?.startButton.setTitle( ButtonState.stop.rawValue, for: .normal)
			stopWatchView?.startButton.backgroundColor = .red
			stopWatchView?.lapButton.setTitle( ButtonState.lap.rawValue, for: .normal)
			stopWatchView?.lapButton.alpha = 1
			stopWatchView?.lapButton.isEnabled = true
		case .invalid:
			stopWatchView?.startButton.setTitle( ButtonState.start.rawValue, for: .normal)
			stopWatchView?.startButton.backgroundColor = .green
			stopWatchView?.lapButton.setTitle( ButtonState.reset.rawValue, for: .normal)
		case .default:
			stopWatchView?.startButton.setTitle( ButtonState.start.rawValue, for: .normal)
			stopWatchView?.startButton.backgroundColor = .green
			stopWatchView?.lapButton.setTitle( ButtonState.lap.rawValue, for: .normal)
			stopWatchView?.lapButton.alpha = 0.5
			stopWatchView?.lapButton.isEnabled = false
		}
	}
	
	
	//MARK: - TimerHandler
	@objc private func updateStopWatch(){
		stopWatchModel.update()
		self.stopWatchView?.timeLabel.text = stopWatchModel.time
	}
}
