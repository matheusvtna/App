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
        
        commStatusLabel.text = "No connection started yet"
        commStatusLabel.textColor = .lightGray
    }
    
    @IBAction func connectClicked() {
        
        communication.connect()
        let actuatorView = storyboard?.instantiateViewController(identifier: "ActuatorViewController") as! ActuatorViewController
        self.present(actuatorView, animated: true, completion: nil)
        
        setupCommunicationSettings()
        setupConnectionLabel()
        saveUserDefaults()
        
        ipTextField.isEnabled = !connected
        portTextField.isEnabled = !connected
        endpointTextField.isEnabled = !connected
        commTypeControl.isEnabled = !connected
    }
    
    func setupCommunicationSettings() {
        let typeIndex = commTypeControl.selectedSegmentIndex
        
        settings.serverName = ipTextField.text ?? ""
        settings.port = (portTextField.text! as NSString).integerValue
        settings.endpoint = endpointTextField.text ?? ""
        settings.type = CommunicationType.init(rawValue: typeIndex)!
    }
    
    func setupConnectionLabel() {
        var text = ""
        if communication.isConnected {
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
    
    func saveUserDefaults() {
        let defaults = UserDefaults.standard
        
        let ip: String = ipTextField.text ?? "localhost"
        let port: Int = Int(portTextField.text ?? "80") ?? 80
        let endpoint:String = endpointTextField.text ?? ""
        let type: CommunicationType = CommunicationType.init(rawValue: commTypeControl.selectedSegmentIndex)!
        
        defaults.set(ip, forKey: "commServer")
        defaults.set(port, forKey: "commPort")
        defaults.set(endpoint, forKey: "commEndpoint")
        defaults.set(type.rawValue, forKey: "commType")
    }
}
