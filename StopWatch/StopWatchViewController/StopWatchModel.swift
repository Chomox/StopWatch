//
//  StopWatchModel.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2019/10/16.
//  Copyright © 2019 Motoyuki Ito. All rights reserved.
//

import UIKit

final class StopWatchModel: NSObject {
	
	//MARK: - Constants
	private enum SavePropertiesKey: String {
		case time = "Time_String"
		case lapTime = "LapTime_String"
		case laps = "Laps"
		case shortTimeIndex = "ShortTime_Index"
		case longTimeIndex = "LongTime_Index"
	}
	
	
	private var lapCount: Int = 0
 
//	private var minutes = 0
//	private var seconds = 0
//	private var milliSecond = 0
//
//	private var lapMinutes = 0
//	private var lapSeconds = 0
//	private var lapMilliSecond = 0
	
	private var longTimeText: String? {
		get {
			self.laps.max()
		}
	}
	
	private var shortTimeText: String? {
		get {
			self.laps.min()
		}
	}
	
	private var shortTimeIndex: Int? {
		get {
			laps.firstIndex(of: self.shortTimeText ?? "")
		}
	}
	
	private var longTimeIndex: Int? {
		get {
			laps.firstIndex(of: self.longTimeText ?? "")
		}
	}
	
	private var timeText = "00:00.00"
	private var lapTimeText = ""
	
	
	//MARK: - Properties
	private var count: Int = 0
	
	private var laps: [String] = []
	
	private(set) var isCounting: Bool = false
	
	var time: String {
		get {
			return timeText
		}
	}
	
	//MARK: - Initialize
	override init(){
		super.init()
		
		self.timeText = UserDefaults.standard.string(forKey: SavePropertiesKey.time.rawValue) ?? ""
		self.lapTimeText = UserDefaults.standard.string(forKey: SavePropertiesKey.lapTime.rawValue) ?? ""
		self.laps = UserDefaults.standard.array(forKey: SavePropertiesKey.laps.rawValue) as? [String] ?? [String]()
		
		NotificationCenter.default.addObserver(self, selector: #selector(save), name: Notification.Name(rawValue: "a"), object: nil)
	}
	
	//値の保存
	@objc private func save(){
		UserDefaults.standard.set(timeText, forKey: SavePropertiesKey.time.rawValue)
		UserDefaults.standard.set(lapTimeText, forKey: SavePropertiesKey.lapTime.rawValue)
		UserDefaults.standard.set(laps, forKey: SavePropertiesKey.laps.rawValue)
		UserDefaults.standard.set(shortTimeIndex, forKey: SavePropertiesKey.shortTimeIndex.rawValue)
		UserDefaults.standard.set(longTimeIndex, forKey: SavePropertiesKey.longTimeIndex.rawValue)
	}
	

	//MARK: - StopWatch Control
	func start(){
		isCounting = true
	}
	
	func stop(){
		isCounting = false
	}
	
	func update(){
		count += 1
		let ms = count % 100
		let s = (count - ms) / 100 % 60
		let m = (count - s - ms) / 6000 % 3600
		timeText = String (format: "%02d:%02d.%02d", m,s,ms)
		
		lapCount += 1
		let lms = lapCount % 100
		let ls = (lapCount - lms) / 100 % 60
		let lm = (lapCount - ls - lms) / 6000 % 3600
		lapTimeText = String (format: "%02d:%02d.%02d", lm,ls,lms)
		
//		milliSecond += 1
//		lapMilliSecond += 1
//
//		if milliSecond == 100 {
//			seconds += 1
//			milliSecond = 0
//		}
//
//		if seconds == 60 {
//			minutes += 1
//			seconds = 0
//		}
//
//		if lapMilliSecond == 100 {
//			lapSeconds += 1
//			lapMilliSecond = 0
//		}
//
//		if lapSeconds == 60 {
//			lapMinutes += 1
//			lapSeconds = 0
//		}
//
//		//0が来ると名前が小さくて
//		let milliSecondString = milliSecond > 9 ? "\(milliSecond)" : "0\(milliSecond)"
//		let secondsnString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
//		let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
//
//		let lapMilliSecondString = lapMilliSecond > 9 ? "\(lapMilliSecond)" : "0\(lapMilliSecond)"
//		let lapSecondsnString = lapSeconds > 9 ? "\(lapSeconds)" : "0\(lapSeconds)"
//		let lapMinutesString = lapMinutes > 9 ? "\(lapMinutes)" : "0\(lapMinutes)"
		
//		timeText = "\(minutesString):\(secondsnString):\(milliSecondString)"
//		lapTimeText = "\(lapMinutesString):\(lapSecondsnString):\(lapMilliSecondString)"
	}
	
	func add(){
		laps.insert(lapTimeText, at: 0)
		lapCount = 0
	}
		
		
//		self.shortTimeText = laps.min()!
//		self.longTimeText = laps.max()!
//
//		//最後のはやおそ持ってきて
//		self.shortTimeIndex = laps.firstIndex(of: self.shortTimeText)!
//		self.longTimeIndex = laps.firstIndex(of: self.longTimeText)!
		
//		lapMilliSecond = 0
//		lapSeconds = 0
//		lapMinutes = 0
	
	func reset(){
		laps.removeAll(keepingCapacity: false)
		
//		minutes = 0
//		seconds = 0
//		milliSecond = 0
//
//		lapMilliSecond = 0
//		lapSeconds = 0
//		lapMinutes = 0
		
		count = 0
		lapCount = 0
		
		timeText = "00:00.00"
	}
}

extension StopWatchModel: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		laps.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1 , reuseIdentifier: "cell")
//		cell.backgroundColor = UIColor(red: 35/255, green: 38/255, blue: 44/255, alpha: 1.0)
		cell.tintColor = .black
		cell.textLabel?.text = "Lap \(laps.count - indexPath.row)"
		cell.detailTextLabel?.text = laps[indexPath.row]
		cell.selectionStyle = .none
		
		cell.detailTextLabel?.textColor = .black
		cell.textLabel?.textColor = .black
		
		switch indexPath.row {
		case shortTimeIndex:
			cell.detailTextLabel?.textColor = .green
			cell.textLabel?.textColor = .green
		case longTimeIndex:
			cell.detailTextLabel?.textColor = .red
			cell.textLabel?.textColor = .red
		default:
			cell.detailTextLabel?.textColor = .white
			cell.textLabel?.textColor = .white
		}
		return cell
	}
}
