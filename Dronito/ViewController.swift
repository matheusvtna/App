//
//  ViewController.swift
//  Dronito
//
//  Created by Matheus Andrade on 24/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ledButton: UIButton!
    var ledStatus: Bool = false
    var communicationSettings: CommunicationSettings = CommunicationSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeLedStatus() {
        self.ledStatus.toggle()
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
                                                
