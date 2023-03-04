//
//  LocalNotification.swift
//  LocalNotifications
//
//  Created by Marcin Jędrzejak on 04/03/2023.
//

import Foundation

struct LocalNotification {
    var identifier: String
    var title: String
    var body: String
    var timeInterval: Double
    var repeats: Bool
}
