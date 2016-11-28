//
//  Helper.swift
//  eword
//
//  Created by Admin on 29/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class Util {
    class func showAlertMessage(title: String, message: String, parent: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        parent.present(alert, animated: true, completion: nil)
    }
    
    class func timeForTicks(_ doubleTicks: Double) -> String {
        let intTicks = Int(floor(doubleTicks))
        
        let seconds = intTicks % 60
        let minutes = (intTicks / 60) % 60
        let hours = intTicks / 3600
        
        var secondsStr = String(seconds)
        if (seconds < 10) {
            secondsStr = "0" + secondsStr
        }
        
        var minutesStr = String(minutes)
        if (minutes < 10) {
            minutesStr = "0" + minutesStr
        }
        
        var hoursStr = String(hours)
        if (hours < 10) {
            hoursStr = "0" + hoursStr
        }
        
        return hoursStr + ":" + minutesStr + ":" + secondsStr
    }
}
