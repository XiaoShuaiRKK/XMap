//
//  XMapWidget.swift
//  XMapWidget
//
//  Created by Xiao Shuai on 2025/1/13.
//

import WidgetKit
import SwiftUI
import HealthKit

struct Provider: AppIntentTimelineProvider {
    let healthManager: HealthManager
    
    init() {
        healthManager = HealthManager()
    }
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), steps: 0, distance: 0.0)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let (steps, distance) = await fetchSteps()
        return SimpleEntry(date: Date(), configuration: configuration, steps: steps, distance: distance)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // 获取步数和公里数
        let (steps, distance) = await fetchSteps()
        let currentDate = Date()

        // 生成多个条目，更新间隔为1小时
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, steps: steps, distance: distance)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    func fetchSteps() async -> (Int, Double) {
        return await withCheckedContinuation { continuation in
            healthManager.fetchTodayStepsAndDistance { steps, distance in
                continuation.resume(returning: (steps, distance))
            }
        }
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let steps: Int
    let distance: Double
}

struct XMapWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if entry.steps == 0 && entry.distance == 0 {
            Text("请打开主应用以授权健康数据访问")
                .font(.caption)
                .foregroundColor(.red)
                .padding()
        } else {
            switch widgetFamily {
            case .systemSmall :
                VStack(alignment: .leading, spacing: 8) {
                    Text("今天")
                        .font(.headline)
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("步数")
                            .font(.subheadline)
                        Text("\(entry.steps)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    HStack{
                        Text("公里数")
                            .font(.subheadline)
                        Text(String(format: "%.2f km", entry.distance))
                            .font(.body)
                            .bold()
                            .foregroundColor(.green)
                    }
                }
                .padding()
            case .accessoryInline:
                // Inline 显示文字信息
                Text("步数: \(entry.steps), 距离: \(String(format: "%.2f km", entry.distance))")
                    .font(.footnote)

            case .accessoryCircular:
                // Circular 使用进度条和文字信息
                ZStack {
                    ProgressView(value: Double(entry.steps) / 10000.0)
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("\(entry.steps)")
                        .font(.caption)
                        .bold()
                }

            case .accessoryRectangular:
                // Rectangular 显示详细信息
                VStack(alignment: .leading) {
                    Text("步数: \(entry.steps)")
                        .font(.footnote)
                        .bold()
                    Text(String(format: "距离: %.2f km", entry.distance))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            default:
                VStack(alignment: .leading, spacing: 8) {
                    Text("今天")
                        .font(.headline)
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("步数")
                            .font(.headline)
                        Text("\(entry.steps)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    HStack{
                        Text("公里数")
                            .font(.headline)
                        Text(String(format: "%.2f km", entry.distance))
                            .font(.title2)
                            .bold()
                            .foregroundColor(.green)
                    }
                }
                .padding()
            }
        }
    }
}

struct XMapWidget: Widget {
    let kind: String = "XMapWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            XMapWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("步数 Widget")
        .description("显示今日步数的 Widget")
        .supportedFamilies([.systemSmall,.systemMedium,.systemLarge,.accessoryCircular, .accessoryInline, .accessoryRectangular])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var defaultConfig: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🚶‍♂️"
        return intent
    }
}

#Preview(as: .systemSmall) {
    XMapWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .defaultConfig, steps: 0, distance: 0.0)
    SimpleEntry(date: .now, configuration: .defaultConfig, steps: 0, distance: 0.0)
}
