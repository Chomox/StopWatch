//
//  StopWatchModel.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2019/10/16.
//  Copyright © 2019 Motoyuki Ito. All rights reserved.
//

import UIKit

final class StopWatch: NSObject {
	
	//MARK: - Constants
	public enum State: String {
		case valid
		case invalid
		case `default`
	}
	
	private enum PropertySaveKeys: String {
		case timeText = "Time_String"
		case lapTimeText = "LapTime_String"
		case laps = "Laps"
		case count = "Count"
		case lapCount = "Lap_Count"
	}
	
	private enum TimeTemplateString: String {
		case timeFormatString = "%02d:%02d.%02d"
		case timeDefaultString = "00:00.00"
	}
	
	
	//MARK: - Properties
	private var count:          Int     = 0
	private var lapCount:       Int     = 0
	private var timeText:       String  = TimeTemplateString.timeDefaultString.rawValue
	private var lapTimeText:    String  = ""
	
	private(set) var laps:  [String]    = []
	private(set) var state: State       = .default
	
	private var shortTimeIndex: Int? {
		laps.firstIndex(of: self.laps.min() ?? "")
	}
	
	private var longTimeIndex: Int? {
		laps.firstIndex(of: self.laps.max() ?? "")
	}
	
	var time: String {
		timeText
	}
	
	var lapTime: String {
		lapTimeText
	}
	
	
	//MARK: - Life Cycle
	override init(){
		super.init()
		
		timeText = UserDefaults.standard.string(forKey: PropertySaveKeys.timeText.rawValue) ?? ""
		lapTimeText = UserDefaults.standard.string(forKey: PropertySaveKeys.lapTimeText.rawValue) ?? ""
		laps = UserDefaults.standard.array(forKey: PropertySaveKeys.laps.rawValue) as? [String] ?? [String]()
		count = UserDefaults.standard.integer(forKey: PropertySaveKeys.count.rawValue)
		lapCount = UserDefaults.standard.integer(forKey: PropertySaveKeys.lapCount.rawValue)
		
		state = count > 0 ? .invalid : .default
		
		NotificationCenter.default.addObserver(self, selector: #selector(save), name: Notification.Name.Save, object: nil)
	}
	
	@objc private func save(){
		UserDefaults.standard.set(timeText, forKey: PropertySaveKeys.timeText.rawValue)
		UserDefaults.standard.set(lapTimeText, forKey: PropertySaveKeys.lapTimeText.rawValue)
		UserDefaults.standard.set(laps, forKey: PropertySaveKeys.laps.rawValue)
		UserDefaults.standard.set(count, forKey: PropertySaveKeys.count.rawValue)
		UserDefaults.standard.set(lapCount, forKey: PropertySaveKeys.lapCount.rawValue)
	}
	

	//MARK: - StopWatch Control
	func start(){
		state = .valid
	}
	
	func stop(){
		state = .invalid
	}
	
	func update(){
		//FIXME: CleanUp
		count += 1
		let milliSecond = count % 100
		let seconds = (count - milliSecond) / 100 % 60
		let minutes = (count - seconds - milliSecond) / 6000 % 3600
		timeText = String (format: TimeTemplateString.timeFormatString.rawValue, minutes,seconds,milliSecond)
		
		lapCount += 1
		let lms = lapCount % 100
		let ls = (lapCount - lms) / 100 % 60
		let lm = (lapCount - ls - lms) / 6000 % 3600
		lapTimeText = String (format: TimeTemplateString.timeFormatString.rawValue, lm,ls,lms)
	}
	
	func add(){
		laps.insert(lapTimeText, at: 0)
		lapCount = 0
	}
		
	func reset(){
		laps.removeAll(keepingCapacity: false)
	
		count = 0
		lapCount = 0
		
		state = .default
		timeText = TimeTemplateString.timeDefaultString.rawValue
		
		UserDefaults.standard.removeObject(forKey: PropertySaveKeys.timeText.rawValue)
		UserDefaults.standard.removeObject(forKey: PropertySaveKeys.lapTimeText.rawValue)
		UserDefaults.standard.removeObject(forKey: PropertySaveKeys.laps.rawValue)
		UserDefaults.standard.removeObject(forKey: PropertySaveKeys.count.rawValue)
	}
}

extension StopWatch: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch state {
		case .default: return 0
		default: return laps.count + 1
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = UITableViewCell(style: .value1 , reuseIdentifier: "cell")
		cell.backgroundColor = .background
		cell.textLabel?.text = "Lap \(laps.count - indexPath.row + 1)"
		cell.detailTextLabel?.textColor = .white
		cell.textLabel?.textColor = .white
		cell.selectionStyle = .none
		
		if indexPath.row != 0 {
			cell.detailTextLabel?.text = laps[indexPath.row - 1]
		} else {
			cell.detailTextLabel?.text = lapTime
		}
		
		if laps.count > 1 {
			if let minIndex = shortTimeIndex, let maxIndex = longTimeIndex {
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
