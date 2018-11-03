//
//  ViewController.swift
//  Night2
//
//  Created by William Hou on 11/3/18.
//  Copyright © 2018 William Hou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var clock: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        _ = ClockRunner(clockk: clock, startTime : String(hour) + ":" + String(minutes)+":"+String(seconds))
        
    }


}

class ClockRunner {
    var clock : UITextView = UITextView();
    init(clockk : UITextView, startTime : String) {
        // Creates new thread
        // Gets current time, increment by one % 60 minutes, % 24 for hour
        clock = clockk;
        clock.text = startTime;
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ClockRunner.incrementClock), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func incrementClock()
    {
        var splitString = clock.text.components(separatedBy: ":")
        var currentHour = splitString[0];
        var currentMinute = splitString[1];
        var currentSecond = splitString[2];
        
        if(currentMinute == "59") {
            currentHour = String((Int(currentHour)!  + 1) % 24);
            currentSecond = "00";
        } else if (currentSecond == "59") {
            currentMinute = String((Int(currentMinute)!  + 1) % 60);
            currentSecond = "00";
        } else {
            currentSecond = String((Int(currentSecond)!  + 1) % 60);
            if(Int(currentSecond)! < 10) {
                currentSecond = "0" + currentSecond;
            } else if (Int(currentMinute)! < 10) {
                currentMinute = "0" + currentMinute;
            }
        }
        
        clock.text = currentHour + ":" + currentMinute + ":" + currentSecond;
    }
}


