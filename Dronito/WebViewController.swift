//
//  WebViewController.swift
//  Dronito
//
//  Created by Victor Vieira on 06/10/21.
//
//
//import UIKit
//import Starscream
//
//class WebViewController: UIViewController, WebSocketDelegate {
//
//    @IBOutlet weak var actuactorSlider: UISlider!
//    @IBOutlet weak var percentageLabel: UILabel!
//    @IBOutlet weak var connectButton: UIButton!
//    var digitalLed = 1
//    var analogLed = 0
//
//    func didReceive(event: WebSocketEvent, client: WebSocket) {
//        switch event {
//                case .connected(let headers):
//                    isConnected = true
//            connectButton.setTitle("Disconnect", for: .normal)
//                    print("websocket is connected: \(headers)")
//                case .disconnected(let reason, let code):
//                    connectButton.setTitle("Connect", for: .normal)
//                    isConnected = false
//                    print("websocket is disconnected: \(reason) with code: \(code)")
//                case .text(let string):
//                    print("Received text: \(string)")
//                case .binary(let data):
//                    print("Received data: \(data.count)")
//                case .ping(_):
//                    break
//                case .pong(_):
//                    break
//                case .viabilityChanged(_):
//                    break
//                case .reconnectSuggested(_):
//                    break
//                case .cancelled:
//                    isConnected = false
//                case .error(let error):
//                    isConnected = false
//                    handleError(error)
//                }
//    }
//
//
//
//    var socket: WebSocket!
//    var isConnected = false
//    let server = WebSocketServer()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        let err = server.start(address: "localhost", port: 8080)
////        if err != nil {
////            print("server didn't start!")
////        }
////        server.onEvent = { event in
////            switch event {
////            case .text(let conn, let string):
////                let payload = string.data(using: .utf8)!
////                conn.write(data: payload, opcode: .textFrame)
////            default:
////                break
////            }
////        }
//        //https://echo.websocket.org
//        var request = URLRequest(url: URL(string: "ws://10.0.0.175:88/")!) //https://localhost:8080
//        request.timeoutInterval = 5
//        socket = WebSocket(request: request)
//        socket.delegate = self
//        socket.connect()
//
//    }
//
//    // MARK: - WebSocketDelegate
//
//
//    func handleError(_ error: Error?) {
//        if let e = error as? WSError {
//            print("websocket encountered an error: \(e.message)")
//        } else if let e = error {
//            print("websocket encountered an error: \(e.localizedDescription)")
//        } else {
//            print("websocket encountered an error")
//        }
//    }
//
//    func writeSocket(){
//        socket.write(string: "{\"LEDonoff\":\(digitalLed), \"LEDanalog\":\(analogLed)}")
//    }
//    // MARK: Write Text Action
//
//    @IBAction func writeTextON() {
//        digitalLed = 0
//        writeSocket()
//    }
//
//    @IBAction func writeTextOFF() {
//        digitalLed = 1
//        writeSocket()
//    }
//
//    @IBAction func sliderValueChanged() {
//        let value = Int(actuactorSlider.value)
//        analogLed = value
//        self.percentageLabel.text = "\(value) %"
//        writeSocket()
//    }
//
//    // MARK: Disconnect Action
//
//    @IBAction func disconnect() {
//        if isConnected {
//            socket.disconnect()
//        } else {
//            socket.connect()
//        }
//    }
//
//}
