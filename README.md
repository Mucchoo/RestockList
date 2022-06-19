# 消耗品リスト <img src="https://img.shields.io/badge/-Xcode13-000.svg?logo=xcode&style=flat"> <img src="https://img.shields.io/badge/-Swift5-000.svg?logo=swift&style=flat"> <img src="https://img.shields.io/badge/-Realm-000.svg?logo=realm&style=flat"> <img src="https://img.shields.io/badge/-iOS15~-000.svg?logo=apple&style=flat"> <img src="https://img.shields.io/badge/-MVC-000.svg?&style=flat">
<img width="1122" alt="Screen Shot 2022-06-18 at 21 40 31" src="https://user-images.githubusercontent.com/97211329/174438127-2aaf9e6c-dce3-41ce-b319-e401c001b937.png">
僕はシャンプーやティッシュなどの日用品がいつの間にか無くなっていて困ることが何度もあります。
そこで、定期的に購入するものをデータで管理し残り少ない物は買い忘れないようにリマインドできるアプリを開発しました。

ただ、このアプリを作る上で問題だったのが自分で設定した消費期間と実際の消費期間に必ずズレが生じることでした。
なので、期間の微調整や再設定はとにかく簡単に素早く出来るようにデザインしています。
[App Storeで見る](https://itunes.apple.com/jp/app/id1628820821?mt=8)
# アプリの説明
## 使い方
<img src="https://user-images.githubusercontent.com/97211329/174437318-b925b394-b8de-4abe-bcab-397ec5dd796f.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437321-705aebb9-71b3-42a2-9d09-c065a3d0d2ff.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437322-f7e195e0-5a0f-4ace-b934-28eb2181dd25.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437323-b4c4c1a6-eb3e-45f0-9803-fd43bce78eed.PNG" width="200">
## アイテム一覧
<img src="https://user-images.githubusercontent.com/97211329/174437324-ece1636b-b4b1-4a14-8457-ebc4b6fea975.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437342-f41278f5-ea23-40d8-8d7f-1addb78f9950.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437351-3bae40df-4741-4447-835a-c0a58a97f3b6.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437352-52c4167c-089d-47f0-854a-57372854addf.PNG" width="200">

## アイテムの追加
<img src="https://user-images.githubusercontent.com/97211329/174476357-1241fb36-60cc-46ca-8c53-6bc049dce818.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174476360-5e0fb0ec-7229-4c44-afa5-8b71bfec1909.PNG" width="200">

## アイテムの編集/削除
<img src="https://user-images.githubusercontent.com/97211329/174437328-b203ce29-0475-4361-9098-88f0c56de695.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437346-de1e5265-5194-4dc4-b7b0-3907a99568e2.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437358-4ae1ac40-5fa9-4bb4-82fa-0987a7d96fc0.PNG" width="200">

## 設定画面
<img src="https://user-images.githubusercontent.com/97211329/174437333-81ed5713-d86b-4b6e-a5bb-d8b46c207f34.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437355-13780d7e-efb0-4643-aabf-abccb9f2fd7c.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437339-057a1002-5670-4a30-ae7f-25387149b8d0.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437348-12b9fc22-e3ee-4239-bab4-8d57276e10cf.PNG" width="200">

## アプリ内課金
<img src="https://user-images.githubusercontent.com/97211329/174437329-5efe2261-3ec2-479a-9ea4-a1cfeaa15a9a.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437332-b7bc147a-86e3-45a2-a27e-93a5a4ed39ec.PNG" width="200">

## テーマカラー
<img src="https://user-images.githubusercontent.com/97211329/174437334-6cbe2ec9-6bc1-4aa1-9a26-927c074d133c.PNG" width="200">

## アイコン
<img src="https://user-images.githubusercontent.com/97211329/174437335-dc1b3d97-6a41-4931-8f4c-652ce766c6b1.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437337-bc2f2466-4c53-4d39-86f8-bf134f2bb21b.PNG" width="200"><img src="https://user-images.githubusercontent.com/97211329/174437361-c3de8f2d-b84b-430d-8b42-4f6135972b8d.PNG" width="200">

## 通知

## アプリのシェア

## ご意見・ご要望
<img src="https://user-images.githubusercontent.com/97211329/174437338-c7ba75b1-7124-4b8c-9ff6-35dd16f44d8d.PNG" width="200">

## 受動的レビュー

# 制作の流れ
## 1.案を書き出す
最初は思いついた案をノートに手書きでひたすら書き出していき、完成イメージを形にしました。
## 2.デザイン作成
案を書き出した後は、主要なページのデザインをSketchで作成しました。
## 3.最低限の機能を実装
まずはアプリとして成立するために最低限必要な「アイテムの追加/削除」から実装しました。
## 4.追加機能の実装
最低限の機能を実装した後は、アイテムの編集機能やチュートリアルの作成、アプリ内課金、ウィジェットなどの追加機能を順番に実装していきました。
## 5.デザイン/挙動の改善
アプリが一通り出来上がった後はユーザーの使い心地を改善するために細かい部分の見直しや修正をしたり、デザインを改善していきました。
## 6.アプリのテスト
考えられる全ての操作を行い、問題なく動くかテストをしたり、最小端末iPodで問題なく使えるかを全てのViewで確認していきました。
