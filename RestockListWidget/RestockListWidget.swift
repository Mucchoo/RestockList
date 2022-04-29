//
//  RestockListWidget.swift
//  RestockListWidget
//
//  Created by Musa Yazuju on 2022/04/27.
//

import WidgetKit
import SwiftUI
import RealmSwift

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    var body: some View {
        //3.アイテム名と残り日数を取得する
        ZStack {
            Color("WidgetBackground")
            VStack (spacing: 5){
                Spacer()
                if family == .systemLarge {
                    ForEach(0..<10){ num in
                        HStack(spacing: 0){
                            Text("ここに文章が入ります")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                                .lineLimit(1)
                            Spacer()
                            Text("365日 ")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                        }
                        Rectangle()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1)
                            .background(Color.white)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 5)
                    }
                } else if family == .systemMedium {
                    ForEach(0..<4){ num in
                        HStack(spacing: 0){
                            Text("ここに文章が入ります")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                                .lineLimit(1)
                            Spacer()
                            Text("365日 ")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                        }
                        Rectangle()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 5)
                    }
                } else {
                    ForEach(0..<5){ num in
                        Text("ここに文章が入りますううう")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .lineLimit(1)
                            .padding(.bottom, 5)
                    }
                }
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(15)
        }
    }
}

@main
struct MyWidget: Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Restock List")
        .description("リストを残り日数が少ない順に表示します。")
    }
}
