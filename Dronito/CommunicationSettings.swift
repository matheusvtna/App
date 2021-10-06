//
//  CommunicationSettings.swift
//  Dronito
//
//  Created by Matheus Andrade on 06/10/21.
//

import Foundation
import UIKit

class CommunicationSettingsController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var endpointTextField: UITextField!
    @IBOutlet weak var commTypeControl: UISegmentedControl!
    @IBOutlet weak var commStatusLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    let settings = CommunicationSettings.shared
    let communication = Communication.shared
    var connected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ipTextField.delegate = self
        portTextField.delegate = self
        endpointTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        let defaults = UserDefaults.standard
        
        ipTextField.text = defaults.object(forKey: "commServer") as? String ?? "localhost"
        portTextField.text = String(defaults.object(forKey: "commPort") as? Int ?? 80)
        endpointTextField.text = defaults.object(forKey: "commEndpoint") as? String ?? ""
        
        let typeIndex = defaults.object(forKey: "commType") as? Int ?? commTypeControl.selectedSegmentIndex
        commTypeControl.selectedSegmentIndex = typeIndex
        
    }
    
    @IBAction func connectClicked() {
        connected = !connected
        
        print("connected: \(connected)")
        
        if connected {
            communication.connect()
            connectButton.setTitle("DISCONNECT", for: .normal)
        } else {
            communication.disconnect()
            connectButton.setTitle("CONNECT", for: .normal)        }
        
        var text = ""
        if communication.isAlive() {
            text += "Connected on:\n\(settings.url)"
            commStatusLabel.textColor = .green
        } else {
            text += "Cannot open:\n\(settings.url)"
            commStatusLabel.textColor = .red
        }
        
        let type = settings.type == .HTTP ? "HTTP" : "WebSocket"
        text += "\n\nSending through " + type
        commStatusLabel.text = text
        
    }
    
}
