//
//  XMapWidgetBundle.swift
//  XMapWidget
//
//  Created by Xiao Shuai on 2025/1/13.
//

import WidgetKit
import SwiftUI

@main
struct XMapWidgetBundle: WidgetBundle {
    var body: some Widget {
        XMapWidget()
        XMapWidgetControl()
        XMapWidgetLiveActivity()
    }
}
