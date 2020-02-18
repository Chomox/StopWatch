//
//  CircleButton.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2020/02/09.
//  Copyright © 2020 Motoyuki Ito. All rights reserved.
//

import UIKit

final class CircleButton: UIButton {
    
    //MARK: - Property
    let circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 78.5, height: 78.5)).cgPath
        layer.lineWidth = 1.5
        layer.strokeColor = UIColor.background.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    
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
        layer.addSublayer(self.circleLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //FIXME: HARD CODING
        circleLayer.frame.origin.x = (frame.width - 78.5) / 2
        circleLayer.frame.origin.y = (frame.height - 78.5) / 2
    }
}
