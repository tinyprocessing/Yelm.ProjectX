//
//  func.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 09.03.2021.
//

import Foundation
import Yelm_Server
import SwiftUI
import CommonCrypto

func region_change() {
    
    let region = UserDefaults.standard.string(forKey: "region") ?? ""
    let region_current = Locale.current.regionCode
    if (region != region_current){
        GlobalRealm.clear_cart()
    }
    
    if (Locale.current.regionCode != nil){
        UserDefaults.standard.set(Locale.current.regionCode, forKey: "region")
    }
    
}

extension Data{
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

public extension String {
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
}
