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
        return SimpleEntry(date: Date(), expendables: [])
    }
    //widget追加時に表示される情報
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), expendables: [])
        completion(entry)
    }
    //毎日9時1分にwidgetを更新
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: Date(), expendables: RealmModel.expendables)
        entries.append(entry)
        let morning = Calendar.current.date(from: DateComponents(hour: 9, minute: 1))!
        let timeline = Timeline(entries: entries, policy: .after(morning))
        completion(timeline)
    }
    
}
//widget更新時に受け取る情報
struct SimpleEntry: TimelineEntry {
    var date: Date
    let expendables: [Expendable]
}

struct WidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var expendables: [Expendable]
    var entry: Provider.Entry
    //更新時に受け取った情報を反映
    init(entry: Provider.Entry){
        self.entry = entry
        expendables = entry.expendables
    }
    
    var body: some View {
        ZStack {
            //背景色
            Color(ThemeModel.color)
            
            VStack (spacing: 5){
                Spacer()
                //widget小
                if family == .systemSmall {
                    //アイテムが5個以上あるときは5個だけ表示
                    if expendables.count > 5 {
                        ForEach(0..<5){ num in
                            HStack(spacing: 0) {
                                Text("\(expendables[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(expendables[num].remainingDateCount)日 ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }.padding(.bottom, 2)
                        }
                    //アイテムが5個ないときはあるだけ表示
                    } else {
                        ForEach(0..<expendables.count, id: \.self){ num in
                            HStack(spacing: 0) {
                                Text("\(expendables[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(expendables[num].remainingDateCount)日 ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }.padding(.bottom, 2)
                        }
                    }
                //widget中
                } else if family == .systemMedium {
                    //アイテムが4個以上あるときは4個だけ表示
                    if expendables.count > 4 {
                        ForEach(0..<4){ num in
                            HStack(spacing: 0){
                                Text("\(expendables[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(expendables[num].remainingDateCount)日 ")
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
                        ForEach(0..<expendables.count, id: \.self){ num in
                            HStack(spacing: 0){
                                Text("\(expendables[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(expendables[num].remainingDateCount)日 ")
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
                    if expendables.count > 10 {
                        ForEach(0..<10){ num in
                            HStack(spacing: 0){
                                Text("\(expendables[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(expendables[num].remainingDateCount)日 ")
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
                        ForEach(0..<expendables.count, id: \.self){ num in
                            HStack(spacing: 0){
                                Text("\(expendables[num].name) ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(expendables[num].remainingDateCount)日 ")
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
