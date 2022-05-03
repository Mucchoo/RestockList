//
//  RestockListWidget.swift
//  RestockListWidget
//
//  Created by Musa Yazuju on 2022/04/27.
//

import WidgetKit
import SwiftUI
import RealmSwift

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let realm = r.realm
        let data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        return SimpleEntry(date: Date(), data: data)
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let realm = r.realm
        let data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        let entry = SimpleEntry(date: Date(), data: data)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let realm = r.realm
        let data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        let entry = SimpleEntry(date: Date(), data: data)
        var entries: [SimpleEntry] = []
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let data: [Item]
}

struct WidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var data: [Item]
    var entry: Provider.Entry
    init(entry: Provider.Entry){
        self.entry = entry
        data = entry.data
    }
    var body: some View {
        ZStack {
            Color("WidgetBackground")
            VStack (spacing: 5){
                Spacer()
                if family == .systemLarge {
                    if data.count > 10 {
                        ForEach(0..<10){ i in
                            WidgetRowView(text: data[i].name, period: data[i].period, isSmall: false)
                        }
                    } else {
                        ForEach(0..<data.count, id: \.self){ i in
                            WidgetRowView(text: data[i].name, period: data[i].period, isSmall: false)
                        }
                    }
                } else if family == .systemMedium {
                    if data.count > 4 {
                        ForEach(0..<4){ i in
                            WidgetRowView(text: data[i].name, period: data[i].period, isSmall: false)
                        }
                    } else {
                        ForEach(0..<data.count, id: \.self){ i in
                            WidgetRowView(text: data[i].name, period: data[i].period, isSmall: false)
                        }
                    }
                } else {
                    if data.count > 5 {
                        ForEach(0..<5){ i in
                            WidgetRowView(text: data[i].name, period: data[i].period, isSmall: true)
                        }
                    } else {
                        ForEach(0..<data.count, id: \.self){ i in
                            WidgetRowView(text: data[i].name, period: data[i].period, isSmall: true)
                        }
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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Restock List")
        .description("リストを残り日数が少ない順に表示します。")
    }
}

struct WidgetRowView: View {
    var text: String
    var period: Int
    var isSmall: Bool
    var body: some View {
        HStack(spacing: 0) {
            Text("\(text) ")
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
                .lineLimit(1)
            Spacer()
            Text("\(period)日 ")
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
        }
        if isSmall {
            self.padding(.bottom, 5)
        } else {
            Rectangle()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                .foregroundColor(Color.white)
                .padding(.bottom, 5)
        }
    }
}
