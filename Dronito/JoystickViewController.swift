//
//  JoystickViewController.swift
//  Dronito
//
//  Created by Victor Vieira on 12/10/21.
//

import Foundation
import SpriteKit

class JoystickViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("matheusOtário")
        let scene = JoystickScene(fileNamed: "JoystickScene")
        scene?.backgroundColor = .black
        
        if let skView = self.view as? SKView {
            print("matheusIdiota")
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            skView.presentScene(scene)
        }
    }
    
    
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask  {
        return UIDevice.current.userInterfaceIdiom == .phone ? .landscape : .all
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
