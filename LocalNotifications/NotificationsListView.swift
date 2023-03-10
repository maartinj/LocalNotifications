//
// Created for LocalNotifications
// by Stewart Lynch on 2022-05-22
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

// Playlista: https://www.youtube.com/watch?v=tNaSlfLeCB0&list=PLBn01m5Vbs4BkAf5RqyoD6c56h4MYJt3n&ab_channel=StewartLynch

// Date Components Reference: https://www.codingexplorer.com/nsdatecomponents-class-reference/

import SwiftUI

struct NotificationsListView: View {
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    @State private var scheduleDate = Date()
    var body: some View {
        NavigationView {
            VStack {
                if lnManager.isGranted {
                    GroupBox("Schedule") {
                        Button("Interval Notification") {
                            Task {
                                var localNotification = LocalNotification(identifier: UUID().uuidString,
                                                                          title: "Some Title",
                                                                          body: "Some body",
                                                                          timeInterval: 5,
                                                                          repeats: false)
                                localNotification.subtitle = "This is a subtitle"
                                localNotification.bundleImageName = "Stewart.png"
                                localNotification.userInfo = ["nextView" : NextView.renew.rawValue]
                                localNotification.categoryIdentifier = "snooze"
                                await lnManager.schedule(localNotification: localNotification)
                            }
                        }
                        .buttonStyle(.bordered)
                        GroupBox {
                            DatePicker("", selection: $scheduleDate)
                                .labelsHidden()
                            Button("Calendar Notification") {
                                Task {
                                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: scheduleDate)
                                    let localNotification = LocalNotification(identifier: UUID().uuidString,
                                                                              title: "Calendar Notification",
                                                                              body: "Some Body",
                                                                              dateComponents: dateComponents,
                                                                              repeats: false)
                                    await lnManager.schedule(localNotification: localNotification)
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                        Button("Promo Offer") {
                            Task {
                                let dateComponents = DateComponents(day: 1, hour: 10, minute: 0)
                                var localNotification = LocalNotification(identifier: UUID().uuidString,
                                                                          title: "Special Promotion",
                                                                          body: "Take advantage of the monthly promotion",
                                                                          dateComponents: dateComponents,
                                                                          repeats: true)
                                localNotification.bundleImageName = "Stewart.png"
                                localNotification.userInfo = ["nextView" : NextView.promo.rawValue]
                                await lnManager.schedule(localNotification: localNotification)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(width: 300)
                    List {
                        ForEach(lnManager.pendingRequests, id: \.identifier) { request in
                            VStack(alignment: .leading) {
                                Text(request.content.title)
                                HStack {
                                    Spacer()
                                    Text(request.identifier)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    lnManager.removeRequest(withIdentifier: request.identifier)
                                }
                            }
                        }
                    }
                } else {
                    Button("Enable Notifications") {
                        lnManager.openSettings()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .sheet(item: $lnManager.nextView, content: { nextView in
                nextView.view()
            })
            .navigationTitle("Local Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        lnManager.clearRequests()
                    } label: {
                        Image(systemName: "clear.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .task {
            try? await lnManager.requestAuthorization()
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    await lnManager.getPendingRequests()
                }
            }
        }
    }
}

struct NotificationsListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsListView()
            .environmentObject(LocalNotificationManager())
    }
}
