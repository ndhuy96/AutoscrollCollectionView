//
//  DeviceInfo.swift
//  AutoscrollCollectionView
//
//  Created by Nguyen Duc Huy B on 6/16/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import Foundation
import UIKit

class DeviceInfo {
    class func getDevice() -> String {
        var utsnameInstance = utsname()
        uname(&utsnameInstance)
        let optionalString: String? = withUnsafePointer(to: &utsnameInstance.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        return optionalString ?? "N/A"
    }
    
    class func getPixelPerInch() -> Int {
        let systemInfoString = DeviceInfo.getDevice()
        if systemInfoString == "x86_64" || systemInfoString == "i386" || systemInfoString == "N/A" { // iOS Simulator
            return 326
        }
        
        // IPhone
        if UIDevice.current.userInterfaceIdiom == .phone {
            let iPhonePlusTypes = Set<AnyHashable>(["iPhone7,1", "iPhone8,2", "iPhone9,2", "iPhone9,4"])
            if iPhonePlusTypes.contains(systemInfoString) {
                return 401
            }
            
            let iPhoneLowTypes = Set<AnyHashable>(["iPhone1,1", "iPhone1,2", "iPhone2,1"])
            if iPhoneLowTypes.contains(systemInfoString) {
                return 163
            }
            
            // iPhone3,1 iPhone3,2 iPhone3,3 iPhone4,1 iPhone5,1 iPhone5,2 iPhone5,3 iPhone5,4
            // iPhone6,1 iPhone6,2 iPhone7,2 iPhone8,1 iPhone8,4 iPhone9,1 iPhone9,3
            return 326;
        }
        
        // IPad Mini
        let iPadMiniTypes = Set<AnyHashable>(["iPad2,5", "iPad2,6", "iPad2,7",
                                              "iPad4,4", "iPad4,5", "iPad4,6",
                                              "iPad4,7", "iPad4,8", "iPad4,9",
                                              "iPad5,1", "iPad5,2"])
        if iPadMiniTypes.contains(systemInfoString) {
            let iPadMiniLowPPITypes = Set<AnyHashable>(["iPad2,5", "iPad2,6", "iPad2,7"])
            if iPadMiniLowPPITypes.contains(systemInfoString) {
                return 163
            }
            // iPad4,4 iPad4,5 iPad4,6 iPad4,7 iPad4,8 iPad4,9 iPad5,1 iPad5,2
            return 326
        }
        
        // IPod
        let iPodTypes = Set<AnyHashable>(["iPod1,1", "iPod2,1", "iPod3,1",
                                          "iPod4,1", "iPod5,1", "iPod7,1"])
        if iPodTypes.contains(systemInfoString) {
            let iPodLowPPITypes = Set<AnyHashable>(["iPod1,1", "iPod2,1", "iPod3,1"])
            if iPodLowPPITypes.contains(systemInfoString) {
                return 163
            }
            // iPod4,1 iPod5,1 iPod7,1
            return 326
        }
        
        // IPad
        let iPadLowPPITypes = Set<AnyHashable>(["iPad1,1","iPad2,1", "iPad2,2", "iPad2,3"])
        if iPadLowPPITypes.contains(systemInfoString) {
            return 132
        }
        // iPad3,1 iPad3,2 iPad3,3 iPad3,4 iPad3,5 iPad3,6 iPad4,1 iPad4,2 iPad4,3 iPad5,3 iPad5,4 iPad6,3 iPad6,4 iPad6,7 iPad6,8
        return 264;
    }
}
