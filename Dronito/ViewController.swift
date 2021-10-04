//
//  ViewController.swift
//  Dronito
//
//  Created by Matheus Andrade on 24/09/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var ipOkButton: UIButton!
    
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var portOkButton: UIButton!
    
    @IBOutlet weak var endpointTextField: UITextField!
    @IBOutlet weak var endpointOkButton: UIButton!
    
    @IBOutlet weak var actuactorSlider: UISlider!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var commTypeControl: UISegmentedControl!
    
    @IBOutlet weak var commStatusLabel: UILabel!
    
    var communicationSettings: CommunicationSettings = CommunicationSettings.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ipTextField.delegate = self
        portTextField.delegate = self
        endpointTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        self.actuactorSlider.minimumValue = 0
        self.actuactorSlider.maximumValue = 100
        
        let value = Int(actuactorSlider.value)
        self.percentageLabel.text = "\(value) %"
        
        let defaults = UserDefaults.standard
        
        ipTextField.text = defaults.object(forKey: "commServer") as? String ?? "localhost"
        portTextField.text = String(defaults.object(forKey: "commPort") as? Int ?? 80)
        endpointTextField.text = defaults.object(forKey: "commEndpoint") as? String ?? ""
        
        let typeIndex = defaults.object(forKey: "commType") as? Int ?? commTypeControl.selectedSegmentIndex
        communicationSettings.type = CommunicationType.init(rawValue: typeIndex)!
        commTypeControl.selectedSegmentIndex = typeIndex
        
        checkURL()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = UserDefaults.standard
        
        let ip: String = ipTextField.text ?? "localhost"
        let port: Int = Int(portTextField.text ?? "80") ?? 80
        let endpoint:String = endpointTextField.text ?? ""
        let type: CommunicationType = commTypeControl.selectedSegmentIndex == 0 ? .HTTP : .WebSocket
        
        defaults.set(ip, forKey: "commServer")
        defaults.set(port, forKey: "commPort")
        defaults.set(endpoint, forKey: "commEndpoint")
        defaults.set(type.rawValue, forKey: "commType")
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        
        if sender == ipOkButton {
            let ip = ipTextField.text ?? ""
            defaults.set(ip, forKey: "commServer")
            communicationSettings.serverName = ip
        } else if sender == portOkButton {
            let text = portTextField.text ?? ""
            let port = Int(text) ?? 0
            defaults.set(port, forKey: "commPort")
            communicationSettings.port = port
        } else {
            let endpoint = endpointTextField.text ?? ""
            defaults.set(endpoint, forKey: "commEndpoint")
            communicationSettings.endpoint = endpoint
        }
        
        checkURL()
    }
    
    @IBAction func commTypeChanged() {
        let defaults = UserDefaults.standard
        
        if commTypeControl.selectedSegmentIndex == 0 {
            defaults.set(CommunicationType.HTTP.rawValue, forKey: "commType")
            communicationSettings.type = .HTTP
        } else {
            defaults.set(CommunicationType.WebSocket.rawValue, forKey: "commType")
            communicationSettings.type = .WebSocket
        }
        
        checkURL()
    }
    
    @IBAction func sliderValueChanged() {
        let value = Int(actuactorSlider.value)
        self.percentageLabel.text = "\(value) %"
        
        let message = Message(value: value)
        let api = Communication(settings: communicationSettings)
        api.send(content: message)
        
    }
    
    
//    @IBAction func sendMessage() {
//        let alertController = UIAlertController(title: "New message", message: "Enter a new message", preferredStyle: .alert)
//        alertController.addTextField { textField in
//            textField.placeholder = "Your message..."
//        }
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alertController.addAction(UIAlertAction(title: "Send", style: .default, handler: {_ in
//            guard let text = alertController.textFields?.first?.text else { print("No text available") ; return}
//            guard let value = Int(text) else { return }
//            let message = Message(value: value)
//
//            let api = Communication(settings: self.communicationSettings)
//            api.send(content: message)
//
//        }))
//
//        self.present(alertController, animated: true)
//        
//    }
    
    func checkURL() {
        var canOpen = false
        if let url = NSURL(string: communicationSettings.url ) {
            canOpen = UIApplication.shared.canOpenURL(url as URL)
        }
        var text = ""
        if canOpen {
            text += "Connected on:\n\(communicationSettings.url)"
            commStatusLabel.textColor = .green
        } else {
            text += "Cannot open:\n\(communicationSettings.url)"
            commStatusLabel.textColor = .red
        }
        
        let type = communicationSettings.type == .HTTP ? "HTTP" : "WebSocket"
        text += "\n\nSending through " + type

        
        commStatusLabel.text = text
    }
}

