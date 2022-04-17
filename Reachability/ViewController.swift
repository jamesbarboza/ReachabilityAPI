//
//  ViewController.swift
//  Reachability
//
//  Created by Leo Dabus on 2/9/19.
//  Copyright © 2019 Dabus.tv. All rights reserved.
//

    import UIKit
    class ViewController: UIViewController {
        
        @IBOutlet var urlTextField: UITextField!
        @IBOutlet var statusTextView: UITextView!
        @IBOutlet var submitBtn: UIButton!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            submitBtn.addTarget(self, action: #selector(self.onSubmit(_:forEvent:)), for: .touchUpInside)
        }
        
        @IBAction func onSubmit(_ sender: UIButton, forEvent event: UIEvent) {
            NotificationCenter.default
                .addObserver(self,
                             selector: #selector(statusManager),
                             name: .flagsChanged,
                             object: nil)
            updateUserInterface()
            
        }
        
        func updateUserInterface() {
            do {
                let url: String = urlTextField.text!
                try Network.reachability = Reachability(hostname: url)
            }
            catch {
                switch error as? Network.Error {
                case let .failedToCreateWith(hostname)?:
                    print("Network error:\nFailed to create reachability object With host named:", hostname)
                case let .failedToInitializeWith(address)?:
                    print("Network error:\nFailed to initialize reachability object With address:", address)
                case .failedToSetCallout?:
                    print("Network error:\nFailed to set callout")
                case .failedToSetDispatchQueue?:
                    print("Network error:\nFailed to set DispatchQueue")
                case .none:
                    print(error)
                }
            }
            
            switch Network.reachability.status {
            case .unreachable:
                statusTextView.backgroundColor = .red
            case .wwan:
                statusTextView.backgroundColor = .yellow
            case .wifi:
                statusTextView.backgroundColor = .green
            }
            print("Reachability Summary")
            print("Status:", Network.reachability.status)
            print("HostName:", Network.reachability.hostname ?? "nil")
            print("Reachable:", Network.reachability.isReachable)
            print("Wifi:", Network.reachability.isReachableViaWiFi)
        }
        @objc func statusManager(_ notification: Notification) {
            updateUserInterface()
        }
    }

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlTextField.becomeFirstResponder()
        return true
    }
}
