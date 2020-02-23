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
        static let four_point_seven_Constraint_constant: (CGFloat, CGFloat) = (74,60)
        static let six_point_one_Constraint_constant: (CGFloat, CGFloat) = (102.5,48)
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

    @IBOutlet weak var lapButton: CircleButton! {
        willSet {
            newValue.backgroundColor = .lapButtonBackground
            newValue.tintColor = .white
        }
    }

    @IBOutlet weak var startButton:     CircleButton!
    @IBOutlet weak var lapsTableView:   UITableView!
    
    @IBOutlet private weak var timeLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabelBottomConstraint: NSLayoutConstraint!
	

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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //FIXME: Set dynamically
        if #available(iOS 13, *){
            timeLabelTopConstraint.constant = Size.six_point_one_Constraint_constant.0
            timeLabelBottomConstraint.constant = Size.six_point_one_Constraint_constant.1
        }
        else {
            timeLabelTopConstraint.constant = Size.four_point_seven_Constraint_constant.0
            timeLabelBottomConstraint.constant = Size.four_point_seven_Constraint_constant.1
        }
        
    }
}
