//
//  NextView.swift
//  LocalNotifications
//
//  Created by Marcin Jędrzejak on 05/03/2023.
//

import SwiftUI

enum NextView: String, Identifiable {
    case promo, renew
    var id: String {
        self.rawValue
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .promo:
            Text("Promotional Offer")
                .font(.largeTitle)
        case .renew:
            VStack {
                Text("Renew Subscription")
                    .font(.largeTitle)
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 128))
            }
        }
    }
}
