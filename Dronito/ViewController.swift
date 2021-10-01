//
//  ViewController.swift
//  Dronito
//
//  Created by Matheus Andrade on 24/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var actuactorSlider: UISlider!
    @IBOutlet weak var percentageLabel: UILabel!
    
    var communicationSettings: CommunicationSettings = CommunicationSettings.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.actuactorSlider.minimumValue = 0
        self.actuactorSlider.maximumValue = 100
        
        let value = Int(actuactorSlider.value)
        self.percentageLabel.text = "\(value) %"
    }
    
    
    @IBAction func sliderValueChanged() {
        let value = Int(actuactorSlider.value)
        self.percentageLabel.text = "\(value) %"
        
        let message = Message(value: value)
        let api = Communication(settings: communicationSettings)
        api.send(content: message)
        
    }
    
    
    @IBAction func sendMessage() {
        let alertController = UIAlertController(title: "New message", message: "Enter a new message", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Your message..."
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Send", style: .default, handler: {_ in
            guard let text = alertController.textFields?.first?.text else { print("No text available") ; return}
            guard let value = Int(text) else { return }
            let message = Message(value: value)
            
            let api = Communication(settings: self.communicationSettings)
            api.send(content: message)
            
            self.present(alertController, animated: true)
            
        }))
    }
}
                                                
