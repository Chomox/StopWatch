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
	public enum State {
		case valid
		case invalid
		case `default`
	}
	
	private enum PropertySaveKeys {
		static let timeText       = "Time_String"
        static let lapTimeText    = "LapTime_String"
        static let laps           = "Laps"
        static let count          = "Count"
        static let lapCount       = "Lap_Count"
	}
	
	private enum TimeTemplateString {
        static let timeFormatString   = "%02d:%02d.%02d"
        static let timeDefaultString  = "00:00.00"
	}
	
	
	//MARK: - Properties
	private var count:          Int     = 0
	private var lapCount:       Int     = 0
	private var timeText:       String  = ""
	private var lapTimeText:    String  = ""
	
	private(set) var laps:  [String]    = []
	private(set) var state: State       = .default
	
    public var shortTimeIndex: Int? {
        laps.firstIndex(of: self.laps.min() ?? "")
    }
	
    public var longTimeIndex: Int? {
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
        
        timeText = UserDefaults.standard.string(forKey: PropertySaveKeys.timeText) ?? TimeTemplateString.timeDefaultString
        lapTimeText = UserDefaults.standard.string(forKey: PropertySaveKeys.lapTimeText) ?? ""
        laps = UserDefaults.standard.array(forKey: PropertySaveKeys.laps) as? [String] ?? [String]()
        count = UserDefaults.standard.integer(forKey: PropertySaveKeys.count)
        lapCount = UserDefaults.standard.integer(forKey: PropertySaveKeys.lapCount)
        
        state = count > 0 ? .invalid : .default
        
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: Notification.Name.Save, object: nil)
    }
	
    @objc private func save(){
        UserDefaults.standard.set(timeText, forKey: PropertySaveKeys.timeText)
        UserDefaults.standard.set(lapTimeText, forKey: PropertySaveKeys.lapTimeText)
        UserDefaults.standard.set(laps, forKey: PropertySaveKeys.laps)
        UserDefaults.standard.set(count, forKey: PropertySaveKeys.count)
        UserDefaults.standard.set(lapCount, forKey: PropertySaveKeys.lapCount)
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
        timeText = String (format: TimeTemplateString.timeFormatString, minutes,seconds,milliSecond)
		
        lapCount += 1
        let lms = lapCount % 100
        let ls = (lapCount - lms) / 100 % 60
        let lm = (lapCount - ls - lms) / 6000 % 3600
        lapTimeText = String (format: TimeTemplateString.timeFormatString, lm,ls,lms)
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
        timeText = TimeTemplateString.timeDefaultString
		
        UserDefaults.standard.removeObject(forKey: PropertySaveKeys.timeText)
        UserDefaults.standard.removeObject(forKey: PropertySaveKeys.lapTimeText)
        UserDefaults.standard.removeObject(forKey: PropertySaveKeys.laps)
        UserDefaults.standard.removeObject(forKey: PropertySaveKeys.count)
    }
}

