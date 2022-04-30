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
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yazujumusa.RestockListWidget")!
        config.fileURL = url.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)
        let data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        
        return SimpleEntry(date: Date(), data: data)
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yazujumusa.RestockListWidget")!
        config.fileURL = url.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)
        let data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        
        let entry = SimpleEntry(date: Date(), data: data)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yazujumusa.RestockListWidget")!
        config.fileURL = url.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)
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
        //3.アイテム名と残り日数を取得する
        ZStack {
            Color("WidgetBackground")
            VStack (spacing: 5){
                Spacer()
                if family == .systemLarge {
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
                                .padding(.bottom, 5)
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
                                .padding(.bottom, 5)
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
                                .padding(.bottom, 5)
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
                                .padding(.bottom, 5)
                        }
                    }
                } else {
                    if data.count > 5 {
                        ForEach(0..<5){ num in
                            HStack {
                                Text("\(data[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                    .padding(.bottom, 5)
                                Spacer()
                            }
                        }
                    } else {
                        ForEach(0..<data.count, id: \.self){ num in
                            HStack {
                                Text("\(data[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                    .padding(.bottom, 5)
                                Spacer()
                            }
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
