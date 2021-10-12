//
//  JoystickScene.swift
//  Dronito
//
//  Created by Victor Vieira on 12/10/21.
//

import Foundation
import SpriteKit
import Starscream


class JoystickScene: SKScene {
    var joystick: SKNode?
    var joystickKnob: SKNode?
    var farol: SKNode?
    var labelX: SKLabelNode?
    var labelY: SKLabelNode?
    var joystickAction = false
    var knobRadius: CGFloat = 50.0
    
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    var digitalLed = 1
    var analogLed = 0
    
    override func didMove(to view: SKView) {
        startSocket()
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        farol = childNode(withName: "farol")
//        let texture2 = SKTexture(imageNamed: "flashlight.on.fill")
//        let action = SKAction.setTexture(texture2, resize: true)
//        farol?.run(action)
        labelX = childNode(withName: "labelX") as? SKLabelNode
        labelY = childNode(withName: "labelY") as? SKLabelNode
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let joystickKnob = joystickKnob {
                let location = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(location)
            }
            //let location = touch.location(in: self)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard joystick != nil else { return }
        guard joystickKnob != nil else { return }

        if !joystickAction { return }
        
        for touch in touches {
            let position = touch.location(in: joystick!)

            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y, position.x)

            if knobRadius > length {
                joystickKnob!.position = position
            } else {
                joystickKnob!.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
            }
        }
        writeSocket()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let xJoystickCoordinate = touch.location(in: joystick!).x
            let xLimit: CGFloat = 200.0
            if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
                resetKnobPosition()
            }
        }
        
    }
    
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
        analogLed = 0
        writeSocket()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let joystickKnob = joystickKnob else { return }
        
        let xPosition = Int(joystickKnob.position.x)
        let yPosition = Int(joystickKnob.position.y)
        
        labelX?.text = String("X:\(xPosition)")
        labelY?.text = String("Y:\(yPosition)")
        analogLed = 2*abs(yPosition)
        
    }
    
}

extension JoystickScene: WebSocketDelegate{
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
                case .connected(let headers):
                    isConnected = true
                    print("websocket is connected: \(headers)")
                case .disconnected(let reason, let code):
                    isConnected = false
                    print("websocket is disconnected: \(reason) with code: \(code)")
                case .text(let string):
                    print("Received text: \(string)")
                case .binary(let data):
                    print("Received data: \(data.count)")
                case .ping(_):
                    break
                case .pong(_):
                    break
                case .viabilityChanged(_):
                    break
                case .reconnectSuggested(_):
                    break
                case .cancelled:
                    isConnected = false
                case .error(let error):
                    isConnected = false
                    handleError(error)
                }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    func writeSocket(){
        socket.write(string: "{\"LEDonoff\":\(digitalLed), \"LEDanalog\":\(analogLed)}")
    }
    func startSocket(){
        var request = URLRequest(url: URL(string: "ws://10.0.0.175:88/")!) //https://localhost:8080
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
}
