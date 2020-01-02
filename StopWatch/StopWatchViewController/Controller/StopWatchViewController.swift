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
	private let stopWatch = StopWatch()
	private var stopWatchView: StopWatchView?
	private weak var timer :Timer?
	
	
	//MARK: - Actions
	@IBAction private func startButtonTapped(){
		if timer == nil {
			timer = .scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
			RunLoop.current.add(timer!, forMode: .common)
			stopWatch.start()
			
			self.stopWatchView?.lapsTableView.reloadData()
		} else {
			timer?.invalidate()
			timer = nil
			stopWatch.stop()
		}
		
		switchButtonsAppearance(state: stopWatch.state)
	}
	
	@IBAction private func addButtonTapped(){
		switch stopWatch.state {
		case .valid:
			stopWatch.add()
			stopWatchView?.lapsTableView.reloadData()
		case .invalid:
			stopWatch.reset()
			stopWatchView?.lapsTableView.reloadData()
			stopWatchView?.timeLabel.text = stopWatch.time
			switchButtonsAppearance(state: stopWatch.state)
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
        stopWatchView?.lapsTableView.dataSource = stopWatch
		stopWatchView?.lapButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
		stopWatchView?.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
		stopWatchView?.timeLabel.text = stopWatch.time
		
		switchButtonsAppearance(state: stopWatch.state)
	}
	
	
	//MARK: - Appearance
	private func switchButtonsAppearance(state: StopWatch.State ){
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
	@objc private func update(){
		stopWatch.update()
		stopWatchView?.timeLabel.text = stopWatch.time
		stopWatchView?.lapsTableView.cellForRow(at: .init(row: 0, section: 0))?.detailTextLabel?.text = stopWatch.lapTime
	}
}
