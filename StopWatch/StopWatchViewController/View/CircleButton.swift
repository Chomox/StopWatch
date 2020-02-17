//
//  CircleButton.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2020/02/09.
//  Copyright © 2020 Motoyuki Ito. All rights reserved.
//

import UIKit

final class CircleButton: UIButton {
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize(){
        layer.cornerRadius = frame.height / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
