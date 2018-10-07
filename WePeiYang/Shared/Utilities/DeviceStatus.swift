//
//  DeviceStatus.swift
//  WePeiYang
//
//  Created by Halcao on 2017/3/31.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

struct DeviceStatus {
    private static func getInfo(withKey key: String) -> String {
        if let name = Bundle.main.infoDictionary?[key] as? String {
            return name
        }
        return "null"
    }

    static func appName() -> String {
        return getInfo(withKey: "CFBundleName")
    }

    static func appVersion() -> String {
        return getInfo(withKey: "CFBundleShortVersionString")
    }

    static func appBuild() -> String {
        return getInfo(withKey: "CFBundleVersion")
    }

    static func deviceModel() -> String {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
//        var machine = [CChar](count: size, repeatedValue: 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
//        return String.fromCString(machine)!

        return String(cString: machine, encoding: .utf8) ?? UIDevice.current.model
    }

    private static func getIPAddresses() -> [String: String] {
        var addresses = [String: String]()

        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [:] }
        guard let firstAddr = ifaddr else { return [:] }

        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee

            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                        let address = String(cString: hostname)
                        if addr.sa_family == UInt8(AF_INET) {
                            addresses[address] = "IPv4"
                        } else if addr.sa_family == UInt8(AF_INET6) {
                            addresses[address] = "IPv6"
                        }
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        return addresses
    }

    static var deviceOSVersion: String {
        return UIDevice.current.systemVersion
    }

    static var userAgent: String {
        return "\(appName())/\(appVersion())(\(deviceModel()); iOS \(deviceOSVersion))"
    }

    static func getIPAddress(preferIPv4 preference: Bool) -> String {
        let dict = getIPAddresses()
        if preference {
            for address in dict.keys where address == "IPv4" {
                return address
            }
        }
        for address in dict.keys where address == "IPv6" {
            return address
        }
        return preference ? "0.0.0.0": "::"
    }

}
