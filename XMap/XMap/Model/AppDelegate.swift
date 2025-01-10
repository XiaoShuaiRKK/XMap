//
//  AppDelegate.swift
//  XMap
//
//  Created by Xiao Shuai on 2025/1/8.
//

import Foundation
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard url.scheme == "carlife" else { return false }

        // 解析回调 URL
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
           let queryItems = components.queryItems {
            let status = queryItems.first(where: { $0.name == "status" })?.value
            let songId = queryItems.first(where: { $0.name == "currentSongId" })?.value

            print("操作状态: \(status ?? "未知")")
            print("当前歌曲ID: \(songId ?? "未知")")

            // 发送通知到 SwiftUI
            NotificationCenter.default.post(name: Notification.Name("CallbackURLReceived"), object: [
                "status": status ?? "",
                "currentSongId": songId ?? ""
            ])
        }
        return true
    }
}
