//
//  StopWatchView.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2019/10/15.
//  Copyright © 2019 Motoyuki Ito. All rights reserved.
//

import UIKit

class StopWatchView: UIView {
	
	//MARK: - Properties
	private var className: String {
        get {
            return String(describing: type(of: self))
        }
    }
	
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var startButton: UIButton!
	@IBOutlet weak var lapButton: UIButton!
	@IBOutlet weak var lapsTableView: UITableView!
	

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialize()
    }
	
    private func initialize() {
		if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
		
		self.setupAppearance()
    }
	
	
	//MARK: - Appearance
	private func setupAppearance(){
		startButton.layer.cornerRadius = startButton.frame.height / 2
		startButton.backgroundColor = .green
		
		lapButton.layer.cornerRadius = lapButton.frame.height / 2
		lapButton.backgroundColor = .gray
		
		timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 72, weight: .regular)
	}
}
