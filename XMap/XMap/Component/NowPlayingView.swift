//
//  NowPlayingView.swift
//  XMap
//
//  Created by Xiao Shuai on 2025/1/8.
//

import SwiftUI
import MediaPlayer
import UIKit

struct NowPlayingView: View {
    @State private var nowPlayingTitle: String = "未知歌曲"
    @State private var nowPlayingArtist: String = "未知艺术家"
    @State private var playbackStatus: String = "未连接"
    @State private var albumArtwork: UIImage? = nil
    @State private var playbackPosition: Int = 0
    
    @State private var statusMessage: String = "等待操作"
    
    let deviceName = UIDevice.current.name

    // 获取设备品牌 (iOS 设备品牌通常为 "Apple")
    let deviceBrand = "Apple"

    // 获取设备唯一ID
    let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "未知设备ID"

    // 获取应用的 Bundle Identifier
    let appID = Bundle.main.bundleIdentifier ?? "未知应用ID"
    let callbackUrl = "xmap://callback"
    
    var body: some View {
        VStack(spacing: 10) {
            Text("正在播放音乐")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Image(uiImage: albumArtwork ?? UIImage())
                    .resizable()
                    .frame(width: 50,height: 50)
                    .cornerRadius(5)
                VStack(alignment: .leading) {
                    Text(nowPlayingTitle)
                        .font(.headline)
                    Text(nowPlayingArtist)
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            Text("播放状态: \(playbackStatus)")
                .font(.subheadline)
                .padding(.top)

            if playbackPosition > 0 {
                Text("播放进度: \(playbackPosition) 秒")
                    .font(.subheadline)
            }

            Spacer()

            Button(action: activateQQMusicAppMode) {
                Text("激活 QQ 音乐 (App 模式)")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: activateQQMusicLogin) {
                Text("打开 QQ 音乐并登录")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Text("状态: \(statusMessage)")
                .padding()
                .foregroundColor(.gray)
        }
        .padding()
        .onOpenURL(perform: handleCallback)
    }
    
//    func launchQQMusic() {
//        // 构造参数
//        let jsonDict: [String: Any] = [
//            "cmd": "login",
//            "callbackurl": "xmap://callback",
//            "devicename": "XS iPad",
//            "devicebrand": "carlife",
//            "deviceid": "XS123456",
//            "appid": "com.xs.assistant",
//            "packagename": "com.xs.assistant",
//            "encrypt": "abcdef123456"
//        ]
//
//        // JSON 转字符串
//        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict),
//           let jsonString = String(data: jsonData, encoding: .utf8),
//           let encodedString = jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//           let url = URL(string: "qqmusic://qq.com/other/qplayauto?p=\(encodedString)") {
//
//            // 使用 UIApplication 打开 URL
//            UIApplication.shared.open(url, options: [:]) { success in
//                if success {
//                    print("成功拉起 QQ 音乐")
//                } else {
//                    print("无法拉起 QQ 音乐")
//                }
//            }
//        }
//    }
//    
//    // 拉起 QQ 音乐并发送请求
//    func fetchCurrentSong() {
//        let callbackUrl = "xmap://callback" // 替换为实际的回调 URL
//        let scheme = """
//        qqmusic://qq.com/other/qplayauto?p={"cmd":"start","callbackurl":"\(callbackUrl)","devicename":"iPhonell","devicebrand":"Apple","deviceid":"12345","appid":"com.xs.assistant","packagename":"com.xs.assistant","encrypt":"none"}
//        """
//
//        guard let url = URL(string: scheme) else {
//            playbackStatus = "URL 构造失败"
//            return
//        }
//
//        UIApplication.shared.open(url) { success in
//            if success {
//                playbackStatus = "已发送请求"
//            } else {
//                playbackStatus = "无法拉起 QQ 音乐"
//            }
//        }
//    }

    // 处理回调并更新界面
//    func handleCallback(url: URL) {
//        print("回调函数")
//        guard let query = url.query else {
//            playbackStatus = "无效的回调数据"
//            return
//        }
//
//        if let data = query.data(using: .utf8),
//           let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
//           let jsonDict = jsonObject as? [String: Any],
//           let getCurrentSong = jsonDict["GetCurrentSong"] as? [String: Any] {
//            
//            let state = getCurrentSong["State"] as? Int ?? -1
//            let position = getCurrentSong["Position"] as? Int ?? 0
//            let song = getCurrentSong["Song"] as? String ?? "未知歌曲"
//
//            nowPlayingTitle = song
//            playbackPosition = position
//
//            playbackStatus = {
//                switch state {
//                case 0: return "停止"
//                case 1: return "播放中"
//                case 2: return "暂停"
//                default: return "未知状态"
//                }
//            }()
//
//            // 如果返回值包含艺术家信息或专辑封面，可以在此扩展
//            // nowPlayingArtist = "艺术家名称" (如果协议支持艺术家字段)
//        } else {
//            playbackStatus = "解析数据失败"
//        }
//    }
    
    /// 激活 QQ 音乐 (App 模式)
    func activateQQMusicAppMode() {

        // 构建请求的参数
        let params: [String: Any] = [
            "cmd": "start",
            "callbackurl": callbackUrl,  // 替换成你的回调 URL
            "devicename": deviceName,
            "devicebrand": deviceBrand,
            "deviceid": deviceID,
            "appid": appID,
            "packagename": appID,  // 对应应用包名，可以用 Bundle ID
            "encrypt": "none"  // 你的加密信息
        ]
        
        print(deviceID)
        print(appID)
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            let encodedString = jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "qqmusic://qq.com/other/qplayauto?p=\(encodedString)"
            if let url = URL(string: urlString) {
                // 通过 scheme 打开 QQ 音乐
                UIApplication.shared.open(url) { success in
                    statusMessage = success ? "成功激活 QQ 音乐 (App 模式)" : "激活失败"
                }
            } else {
                statusMessage = "无法构造 URL Scheme"
            }
        }
    }

    /// 打开 QQ 音乐并登录
    func activateQQMusicLogin() {
// 替换为实际的回调 URL
        let scheme = """
        qqmusic://qq.com/other/qplayauto?p={"cmd":"login","callbackurl":"\(callbackUrl)","devicebrand":"\(deviceBrand)","deviceid":"\(deviceID)"}
        """

        guard let url = URL(string: scheme) else {
            statusMessage = "无法构造 URL Scheme"
            return
        }

        UIApplication.shared.open(url) { success in
            statusMessage = success ? "成功拉起 QQ 音乐进行登录" : "激活失败"
        }
    }

    /// 处理回调 URL
    func handleCallback(url: URL) {
        if let query = url.query, query.contains("qmlogin=1") {
            statusMessage = "登录成功"
        } else if let query = url.query, query.contains("qmlogin=0") {
            statusMessage = "登录失败"
        } else if let query = url.query {
            parsePlaybackInfo(query: query)
        } else {
            statusMessage = "未知回调数据: \(url.absoluteString)"
        }
    }

    /// 解析播放信息 (示例 JSON)
    func parsePlaybackInfo(query: String) {
        
        // 提取JSON部分（例如，p=encodedJson）
        guard let jsonString = extractJsonString(from: query) else {
            statusMessage = "未能提取 JSON 字符串"
            return
        }
        
        print(jsonString)

        // 解析JSON
        if let data = jsonString.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(jsonObject)
                    // 这里处理 JSON 对象
                    if let errorMsg = jsonObject["errorMsg"] as? String {
                        statusMessage = "错误信息: \(errorMsg)"
                    }
                }
            } catch {
                statusMessage = "JSON 解析错误: \(error.localizedDescription)"
            }
        }
    }
    
    /// 从查询字符串中提取 JSON 字符串
    func extractJsonString(from query: String) -> String? {
        // 假设 JSON 被编码在 `p=<JSON字符串>` 的形式
        if let range = query.range(of: "p=") {
            let jsonPart = query[range.upperBound...]
            return jsonPart.removingPercentEncoding // 解码并返回 JSON 字符串
        }
        return nil
    }
}

#Preview {
    NowPlayingView()
}
