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
        return SimpleEntry(date: Date(), data: [], theme: 1)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), data: [], theme: 1)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let realm = r.realm
        let data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        let currentDate = Int(floor(Date().timeIntervalSince1970)/86400)
        if let lastDate = r.user.object(forKey: "lastDate") as? Int {
            let elapsedDays = currentDate - lastDate
            if elapsedDays > 0 {
                realm.beginWrite()
                for Item in realm.objects(Item.self) {
                    Item.remainingTime -= elapsedDays
                    if Item.remainingTime < 0 {
                        Item.remainingTime = 0
                    }
                }
                try! realm.commitWrite()
            }
        }
        r.user.set(currentDate, forKey: "lastDate")
        let theme: Int = r.user.object(forKey: "theme") as? Int ?? 1
        let entry = SimpleEntry(date: Date(), data: data, theme: theme)
        var entries: [SimpleEntry] = []
        entries.append(entry)
        let morning = Calendar.current.date(from: DateComponents(hour: 9, minute: 1))!
        let timeline = Timeline(entries: entries, policy: .after(morning))
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let data: [Item]
    let theme: Int
}

struct WidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var data: [Item]
    var theme: Int
    var entry: Provider.Entry
    init(entry: Provider.Entry){
        self.entry = entry
        data = entry.data
        theme = entry.theme
    }
    var body: some View {
        ZStack {
            Color("AccentColor\(theme)")
            VStack (spacing: 5){
                Spacer()
                if family == .systemSmall {
                    if data.count > 5 {
                        ForEach(0..<5){ num in
                            HStack(spacing: 0) {
                                Text("\(data[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(data[num].remainingTime)日 ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }.padding(.bottom, 2)
                        }
                    } else {
                        ForEach(0..<data.count, id: \.self){ num in
                            HStack(spacing: 0) {
                                Text("\(data[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(data[num].remainingTime)日 ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }.padding(.bottom, 2)
                        }
                    }
                } else if family == .systemMedium {
                    if data.count > 4 {
                        ForEach(0..<4){ num in
                            HStack(spacing: 0){
                                Text("\(data[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(data[num].remainingTime)日 ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }
                            Rectangle()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 2)
                        }
                    } else {
                        ForEach(0..<data.count, id: \.self){ num in
                            HStack(spacing: 0){
                                Text("\(data[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(data[num].remainingTime)日 ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }
                            Rectangle()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 2)
                        }
                    }
                } else {
                    if data.count > 10 {
                        ForEach(0..<10){ num in
                            HStack(spacing: 0){
                                Text("\(data[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(data[num].remainingTime)日 ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }
                            Rectangle()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                                .background(Color.white)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 2)
                        }
                    } else {
                        ForEach(0..<data.count, id: \.self){ num in
                            HStack(spacing: 0){
                                Text("\(data[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(data[num].remainingTime)日 ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }
                            Rectangle()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                                .background(Color.white)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 2)
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
        .configurationDisplayName("消耗品リスト")
        .description("リストを残り日数が少ない順に表示します。")
    }
}

//struct WidgetRowView: View {
//    var text: String
//    var period: Int
//    var isSmall: Bool
//    var body: some View {
//        HStack(spacing: 0) {
//            Text("\(text) ")
//                .foregroundColor(.white)
//                .font(.system(size: 14, weight: .bold))
//                .lineLimit(1)
//            Spacer()
//            Text("\(period)日 ")
//                .foregroundColor(.white)
//                .font(.system(size: 14, weight: .bold))
//        }
//        if isSmall {
//            self.padding(.bottom, 5)
//        } else {
//            Rectangle()
//                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
//                .foregroundColor(Color.white)
//                .padding(.bottom, 5)
//        }
//    }
//}
