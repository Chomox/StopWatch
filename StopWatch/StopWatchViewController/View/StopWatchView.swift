//
//  StopWatchView.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2019/10/15.
//  Copyright © 2019 Motoyuki Ito. All rights reserved.
//

import UIKit

final class StopWatchView: UIView {
	
    //MARK: - Constants
    private enum Size {
        static let font: CGFloat = 90
    }


    //MARK: - Properties
    private var className: String {
        String(describing: type(of: self))
    }

    @IBOutlet weak var timeLabel: UILabel! {
        willSet {
            newValue.font = .monospacedDigitSystemFont(ofSize: Size.font, weight: .thin)
            newValue.textColor = .white
        }
    }

    @IBOutlet weak var startButton: CircleButton!

    @IBOutlet weak var lapButton: CircleButton! {
        willSet {
            newValue.backgroundColor = .lapButtonBackground
            newValue.tintColor = .white
        }
    }

    @IBOutlet weak var lapsTableView: UITableView!
	

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
