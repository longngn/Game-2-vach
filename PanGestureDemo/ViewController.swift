//
//  ViewController.swift
//  PanGestureDemo
//
//  Created by Nguyen Le Vu Long on 12/30/16.
//  Copyright © 2016 Nguyen Le Vu Long. All rights reserved.
//

import UIKit
import os.log

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}

extension UILabel {
    var intValue: Int {
        get {
            return Int(text ?? "0") ?? 0
        }
        set {
            text = "\(newValue)"
        }
    }
}

extension Int {
    static func random(_ bound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(bound)))
    }
}

extension Double {
    static func random(_ bound: Double) -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * bound
    }
}

enum Side: Int {
    case left = 0, right
}

class ViewController: UIViewController {
    @IBOutlet weak var player: UIImageView!
    @IBOutlet var playerPanGesture: UIPanGestureRecognizer!
    @IBOutlet weak var score: UILabel!
    @IBOutlet var gameOverLabel: UILabel!
    @IBOutlet var playAgainButton: UIButton!
    
    var playerPosition: CGPoint!
    var gameOverScreen: UIView!
    var bullets = Set<Bullet>()
    var scoreTimer: Timer?
    var bulletTimer: Timer?
    var playerTimer: Timer?
    var bulletPerLoop = 1.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playAgainButton.layer.cornerRadius = 10
        // Set up player
        player.isUserInteractionEnabled = true
        playerPanGesture.addTarget(self, action: #selector(self.handlePan(gesture:)))
        
        gameInit()
    }
    
    @IBOutlet weak var sampleBullet: Bullet!
    // Game methods
    private func gameInit() {
        gameOverScreen?.removeFromSuperview()
        player.center = view.center
        score.intValue = 0
        for bullet in bullets {
            bullet.removeFromSuperview()
        }
        bullets.removeAll()
        bulletPerLoop = 1.0
        
        scoreTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.score.intValue = self.score.intValue + 1
        }
        bulletTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.bulletPerLoop += 0.3
            for _ in 0..<Int(self.bulletPerLoop) {
                self.spawnBullet()
            }
        }
        playerTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for bullet in self.bullets {
                if self.player.frame.intersects(bullet.frame) {
                    self.gameOver()
                }
            }
            
        }
    }
    private func gameOver() {
        scoreTimer?.invalidate()
        bulletTimer?.invalidate()
        playerTimer?.invalidate()
        
        gameOverScreen = UIView(frame: view.frame)
        gameOverScreen.backgroundColor = UIColor.black
        gameOverScreen.alpha = 0.8
        gameOverScreen.addSubview(gameOverLabel)
        gameOverLabel.center = gameOverScreen.center
        gameOverScreen.addSubview(playAgainButton)
        playAgainButton.center = CGPoint(x: gameOverScreen.center.x, y: gameOverScreen.frame.height - 50)
        
        view.addSubview(gameOverScreen)
        view.bringSubview(toFront: score)
    }
    private func spawnBullet() {
        let whichSide = Side(rawValue: Int.random(2))
        let heightCoordinate = Double.random(Double(view.frame.height))
        let bullet: Bullet!
        
        if whichSide == .left {
            bullet = Bullet(frame: CGRect(x: -100, y: heightCoordinate, width: 65, height: 26))
            bullet.image = #imageLiteral(resourceName: "tinhLeft")
            bullet.bulletController = self
            bullet.startMoving(.right)
        } else {
            bullet = Bullet(frame: CGRect(x: Double(view.frame.width) + 100, y: heightCoordinate, width: 65, height: 26))
            bullet.image = #imageLiteral(resourceName: "tinhRight")
            bullet.bulletController = self
            bullet.startMoving(.left)
        }
        view.addSubview(bullet)
        bullets.insert(bullet)
    }
    
    func disposeBullet(_ bullet: Bullet) {
        bullet.liveTimer?.invalidate()
        bullets.remove(bullet)
        bullet.removeFromSuperview()
        //print("dispose bullet, now remain \(bullets.count)")
    }
    
    // Actions
    func handlePan(gesture: UIPanGestureRecognizer) {
        let object = gesture.view!
        let view = object.superview
        
        switch gesture.state {
        case .began, .ended:
            playerPosition = object.center
        case .changed:
            object.center = playerPosition + gesture.translation(in: view)
        default: break
        }
    }
    @IBAction func playAgain(_ sender: UIButton) {
        gameInit()
    }
    
    // Helper

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

