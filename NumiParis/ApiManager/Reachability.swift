//
//  Reachability.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import Foundation
import Reachability
import SystemConfiguration

struct Internet {
    
    
    
   static func isAvailable(completion:@escaping(_ status:Bool,_ message:String)->()) {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            completion(false,"Network connectivity not available")
            return
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            completion(false,"Network connectivity not available")
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return completion((isReachable && !needsConnection),"Network connectivity not available")
    }
}

