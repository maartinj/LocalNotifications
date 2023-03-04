//
//  LocalNotificationManager.swift
//  LocalNotifications
//
//  Created by Marcin Jędrzejak on 04/03/2023.
//

import Foundation
import NotificationCenter

@MainActor
class LocalNotificationManager: ObservableObject {
    @Published var isGranted = false
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
    }
    
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
        print(isGranted)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
}
