//
//  CLLocationManager+.swift
//  Extensions
//
//  Created by 강동영 on 1/19/24.
//

import CoreLocation

extension CLAuthorizationStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        case .denied: return "denied"
        case .authorizedAlways: return "authorizedAlways"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorized: return "authorized"
        @unknown default:
            return "restricted"
        }
    }
}
