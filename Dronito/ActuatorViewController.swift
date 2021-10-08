//
//  WebViewController.swift
//  Dronito
//
//  Created by Victor Vieira on 06/10/21.
//
//
import UIKit
import Starscream

class ActuatorViewController: UIViewController {
    
    @IBOutlet weak var actuactorSlider: UISlider!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var disconnectButton: UIButton!
    
    var communication = Communication.shared
    var digitalLed = 1
    var analogLed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func writeTextON() {
        digitalLed = 0
        communication.send(content: Message(value: digitalLed))
    }
    
    @IBAction func writeTextOFF() {
        digitalLed = 1
        communication.send(content: Message(value: digitalLed))
    }
    
    @IBAction func sliderValueChanged() {
        let value = Int(actuactorSlider.value)
        analogLed = value
        percentageLabel.text = "\(value) %"
        communication.send(content: Message(value: value))
    }
    
    @IBAction func disconnectClicked() {
        communication.disconnect()
        self.dismiss(animated: true)
    }
    
    
}
