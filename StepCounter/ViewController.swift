//
//  ViewController.swift
//  StepCounter
//
//  Created by George Michokostas on 29/01/2017.
//  Copyright © 2017 George Michokostas. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var stepsCounterLabel: UILabel!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var lastSessionCounterLabel: UILabel!

    let pedometer   = CMPedometer()
    let currentDate = Date()
    let defaults    = UserDefaults.standard
    let alert = UIAlertController(title: "Error",
                                       message: "Pedometer is not available",
                                       preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.stepsCounterLabel.text = "0"
        self.lastSessionCounterLabel.text = self.defaults.string(forKey: "userSteps")
        self.controlButton.setTitle("Start", for: .normal)
        alert.addAction(defaultAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stepsButton (sender: UIButton){
        switch sender.currentTitle! {
        case "Start":
            self.controlButton.setTitle("Stop", for: .normal)
            self.startCounting()
        case "Stop":
            self.controlButton.setTitle("Start", for: .normal)
            self.stopCounting()
        default : break    
        }
    }

    private func startCounting() {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { (data: CMPedometerData?, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil) {
                        print("\(data!.numberOfSteps)")

                        self.controlButton.setTitle("Stop", for: .normal)
                        self.defaults.set("\(data!.numberOfSteps)", forKey: "userSteps")
                        self.stepsCounterLabel.text = "\(data!.numberOfSteps)"
                    } else {
                        self.disableButton(button: self.controlButton)
                        self.present(self.alert, animated: false, completion: nil)
                    }
                })
            }
        } else {
            print("Pedometer is not available")
            self.disableButton(button: self.controlButton)
            present(alert, animated: false, completion: nil)
        }
    }

    private func stopCounting() {
        self.lastSessionCounterLabel.text = self.defaults.string(forKey: "userSteps")
        self.pedometer.stopUpdates()
    }

    private func disableButton(button: UIButton) {
        button.setTitle("Start", for: .normal)
        button.isUserInteractionEnabled = false
    }
}

