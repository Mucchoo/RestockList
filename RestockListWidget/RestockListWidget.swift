//
//  RestockListWidget.swift
//  RestockListWidget
//
//  Created by Musa Yazuju on 2022/04/27.
//

import SwiftUI
import WidgetKit
import RealmSwift

struct Provider: TimelineProvider {
    //ほとんど使われない情報
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), data: [], theme: 1)
    }
    //widget追加時に表示される情報
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), data: [], theme: 1)
        completion(entry)
    }
    //毎日9時1分にwidgetを更新
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        //テーマカラーを反映
        let theme: Int = Data.user.object(forKey: "theme") as? Int ?? 1
        //realmからアイテムを取得
        let realm = Data.realm
        let data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        //日付が変わっていた場合アイテムの残り日数を更新
        let currentDate = Int(floor(Date().timeIntervalSince1970)/86400)
        if let lastDate = Data.user.object(forKey: "lastDate") as? Int {
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
        Data.user.set(currentDate, forKey: "lastDate")
        //毎日9時1分に更新
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: Date(), data: data, theme: theme)
        entries.append(entry)
        let morning = Calendar.current.date(from: DateComponents(hour: 9, minute: 1))!
        let timeline = Timeline(entries: entries, policy: .after(morning))
        completion(timeline)
    }
    
}
//widget更新時に受け取る情報
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
    //更新時に受け取った情報を反映
    init(entry: Provider.Entry){
        self.entry = entry
        data = entry.data
        theme = entry.theme
    }
    
    var body: some View {
        ZStack {
            //背景色
            Color("AccentColor\(theme)")
            
            VStack (spacing: 5){
                Spacer()
                //widget小
                if family == .systemSmall {
                    //アイテムが5個以上あるときは5個だけ表示
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
                    //アイテムが5個ないときはあるだけ表示
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
                //widget中
                } else if family == .systemMedium {
                    //アイテムが4個以上あるときは4個だけ表示
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
                    //アイテムが4個ないときはあるだけ表示
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
                //widget大
                } else {
                    //アイテムが10個以上あるときは10個だけ表示
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
                    //アイテムが10個ないときはあるだけ表示
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
//構造体を使うとWidgetが表示されなくなる
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
