//
//  StopWatchView.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2019/10/15.
//  Copyright © 2019 Motoyuki Ito. All rights reserved.
//

import UIKit

class StopWatchView: UIView {
	
	//MARK: - Constants
	private enum Size {
		static let font:		CGFloat = 84.0
		static let cellHeight:	CGFloat = 43.0
	}
	
	
	//MARK: - Properties
	private var className: String {
        get {
            return String(describing: type(of: self))
        }
    }
	
	@IBOutlet weak var timeLabel: UILabel! {
		willSet {
			newValue.font = .monospacedDigitSystemFont(ofSize: Size.font, weight: .thin)
			newValue.textColor = .white
		}
	}
	
	@IBOutlet weak var startButton: UIButton! {
		willSet {
			newValue.layer.cornerRadius = newValue.frame.height / 2
			newValue.backgroundColor = .green
		}
	}
	
	@IBOutlet weak var lapButton: UIButton! {
		willSet {
			newValue.layer.cornerRadius = newValue.frame.height / 2
			newValue.backgroundColor = .gray
		}
	}
	
	@IBOutlet weak var lapsTableView: UITableView! {
		willSet {
			newValue.delegate = self
		}
	}
	

	//MARK: - Life Cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialize()
    }
	
    private func initialize() {
		let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView
		view?.frame = self.bounds
		self.addSubview(view ?? UIView())
    }
}

extension StopWatchView: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.detailTextLabel?.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		Size.cellHeight
	}
}
