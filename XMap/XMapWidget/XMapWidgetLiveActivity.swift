//
//  XMapWidgetLiveActivity.swift
//  XMapWidget
//
//  Created by Xiao Shuai on 2025/1/13.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct XMapWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct XMapWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: XMapWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension XMapWidgetAttributes {
    fileprivate static var preview: XMapWidgetAttributes {
        XMapWidgetAttributes(name: "World")
    }
}

extension XMapWidgetAttributes.ContentState {
    fileprivate static var smiley: XMapWidgetAttributes.ContentState {
        XMapWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: XMapWidgetAttributes.ContentState {
         XMapWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: XMapWidgetAttributes.preview) {
   XMapWidgetLiveActivity()
} contentStates: {
    XMapWidgetAttributes.ContentState.smiley
    XMapWidgetAttributes.ContentState.starEyes
}
