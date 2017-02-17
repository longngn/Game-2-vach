//
//  Bullet.swift
//  PanGestureDemo
//
//  Created by Nguyen Le Vu Long on 12/31/16.
//  Copyright © 2016 Nguyen Le Vu Long. All rights reserved.
//

import UIKit

class Bullet: UIImageView {
    let movePerLoop: CGFloat = 2.0
    let loopTime = 0.01
    var liveTimer: Timer!
    var bulletController: ViewController!
    
    func startMoving(_ side: Side) {
        if side == .right {
            liveTimer = Timer.scheduledTimer(withTimeInterval: loopTime, repeats: true) { _ in
                self.center.x = self.center.x + self.movePerLoop
                if self.center.x > self.bulletController.view.frame.width + 100 {
                    self.bulletController.disposeBullet(self)
                }
            }
        } else {
            liveTimer = Timer.scheduledTimer(withTimeInterval: loopTime, repeats: true) { _ in
                self.center.x = self.center.x - self.movePerLoop
                if self.center.x < -100 {
                    self.bulletController.disposeBullet(self)
                }
            }
        }
        
    }
}
