//
//  zAmbiLightController.swift
//  AmbiMac
//
//  Created by Floris-Jan Willemsen on 29-04-17.
//  Copyright © 2017 Floris-Jan Willemsen. All rights reserved.
//

import Foundation
import AppKit
import Alamofire
import HexColors


class zAmbiLightController {
    
    let precision :Int = 100              //The higher the number, the lower the precision
    let responsiveness :Double = 0.8      //The lower the number, the higher the responsivness at the cost of processing power
    var timer = Timer()
    
    init() {
        scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: responsiveness, target: self, selector: #selector(self.setColor), userInfo: nil, repeats: true)
    }
    
    
    @objc func setColor() {
        
        var displayCount: UInt32 = 0;
        var result = CGGetActiveDisplayList(0, nil, &displayCount)
        if (result != CGError.success) {
            print("error: \(result)")
            return
        }
        let allocated = Int(displayCount)
        let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
        result = CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)
        
        if (result != CGError.success) {
            print("error: \(result)")
            return
        }
        
//        For Multiple Displays
        
//        for i in 1...displayCount {
//            let screenShot:CGImage = CGDisplayCreateImage(activeDisplays[Int(i-1)])!
//            let bitmapRep = NSBitmapImageRep(cgImage: screenShot)
//            color = averageImageColor(image: bitmapRep)     //Average color
//            print(color)
//        }
        
        
//        For a Single Display
        
        let screenShot:CGImage = CGDisplayCreateImage(activeDisplays[Int(0)])!
        let bitmapRep = NSBitmapImageRep(cgImage: screenShot)
        let color = averageImageColor(image: bitmapRep)     //Average color
        var nscolor = NSColor.init(red: CGFloat(color.red)/255, green: CGFloat(color.green)/255, blue: CGFloat(color.blue)/255, alpha: 1)
//        print("NSColor \(nscolor)")
        var sat = nscolor.saturationComponent + 0.3
        if sat > 1 { sat = 1 }
        nscolor = NSColor.init(hue: nscolor.hueComponent, saturation: sat, brightness: nscolor.brightnessComponent, alpha: 1)
//        print("Saturated \(nscolor)")
        let str = nscolor.hex
        let start = str.index(str.startIndex, offsetBy: 1)
        let end = str.index(str.endIndex, offsetBy: 0)
        let colorhex = str[start..<end]
        print("http://sonoff-h801/cm?cmnd=Color%20\(colorhex)")
        Alamofire.request("http://sonoff-h801/cm?cmnd=Color%20\(colorhex)")
    }
    
    func averageImageColor(image :NSBitmapImageRep) -> RGBColor {
        
        var x :Int = 0
        var y :Int = 0
        var pixel :NSColor
        
        var red :CGFloat = 0
        var green :CGFloat = 0
        var blue :CGFloat = 0
        
        while (y < Int(image.size.height)) {
            x = 0
            
            while (x < Int(image.size.width)) {
                pixel = image.colorAt(x: x, y: y)!
                
                red = red + pixel.redComponent
                green = green + pixel.greenComponent
                blue = blue + pixel.blueComponent
                
                x = x + precision
            }
            
            y = y + precision
        }
        
        let count :CGFloat = CGFloat((x / precision) * (y / precision))
        return RGBColor.init(red: UInt16(red / count * 254), green: UInt16(green / count * 254), blue: UInt16(blue / count * 254))
    }
}

