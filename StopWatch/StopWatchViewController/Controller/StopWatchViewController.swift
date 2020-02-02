//
//  ViewController.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2019/10/15.
//  Copyright © 2019 Motoyuki Ito. All rights reserved.
//

import UIKit

final class StopWatchViewController: UIViewController {
	
    //MARK: - Constant
    private enum ButtonStateString {
        static let start    = "Start"
        static let stop     = "Stop"
        static let lap      = "Lap"
        static let reset    = "Reset"
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
		
        self.tabBarController?.tabBar.barTintColor = .background
        self.tabBarController?.tabBar.tintColor = .tabBarTint
		
        stopWatchView = self.view as? StopWatchView
        stopWatchView?.lapsTableView.dataSource = self
        stopWatchView?.lapsTableView.delegate = self
        
        stopWatchView?.lapsTableView.backgroundColor = .background
        stopWatchView?.lapButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        stopWatchView?.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        stopWatchView?.timeLabel.text = stopWatch.time

        switchButtonsAppearance(state: stopWatch.state)
    }
	
	
    //MARK: - Appearance
    private func switchButtonsAppearance(state: StopWatch.State ){
        switch state {
        case .valid:
            stopWatchView?.startButton.setTitle( ButtonStateString.stop, for: .normal)
            stopWatchView?.startButton.backgroundColor = .stopButtonBackground
            stopWatchView?.startButton.tintColor = .stopButtonText
            stopWatchView?.lapButton.setTitle( ButtonStateString.lap, for: .normal)
            stopWatchView?.lapButton.alpha = 1
        case .invalid:
            stopWatchView?.startButton.setTitle( ButtonStateString.start, for: .normal)
            stopWatchView?.startButton.backgroundColor = .startButtonBackground
            stopWatchView?.startButton.tintColor = .startButtonText
            stopWatchView?.lapButton.setTitle( ButtonStateString.reset, for: .normal)
        case .default:
            stopWatchView?.startButton.setTitle( ButtonStateString.start, for: .normal)
            stopWatchView?.startButton.backgroundColor = .startButtonBackground
            stopWatchView?.startButton.tintColor = .startButtonText
            stopWatchView?.lapButton.setTitle( ButtonStateString.lap, for: .normal)
            stopWatchView?.lapButton.alpha = 0.6
        }
    }


    //MARK: - TimerHandler
    @objc private func update(){
        stopWatch.update()
        stopWatchView?.timeLabel.text = stopWatch.time
        stopWatchView?.lapsTableView.cellForRow(at: .init(row: 0, section: 0))?.detailTextLabel?.text = stopWatch.lapTime
    }
}

//MARK: - UITableViewDataSource
extension StopWatchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch stopWatch.state {
        case .default: return 0
        default: return stopWatch.laps.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1 , reuseIdentifier: "cell")
        cell.backgroundColor = .background
        cell.textLabel?.text = "Lap \(stopWatch.laps.count - indexPath.row + 1)"
        cell.detailTextLabel?.textColor = .white
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        
        if indexPath.row != 0 {
            cell.detailTextLabel?.text = stopWatch.laps[indexPath.row - 1]
        } else {
            cell.detailTextLabel?.text = stopWatch.lapTime
        }
        
        if stopWatch.laps.count > 1 {
            if let minIndex = stopWatch.shortTimeIndex, let maxIndex = stopWatch.longTimeIndex {
                switch indexPath.row {
                case minIndex + 1:
                    cell.detailTextLabel?.textColor = .green
                    cell.textLabel?.textColor = .green
                case maxIndex + 1:
                    cell.detailTextLabel?.textColor = .red
                    cell.textLabel?.textColor = .red
                default: break
                }
            }
        }
        return cell
    }
}

//MARK: - UITableViewDataSource
extension StopWatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44.0
    }
}

