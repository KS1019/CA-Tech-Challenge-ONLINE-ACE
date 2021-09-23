## インターン後改善したところ
- RepositoryのMock化を行って、ViewModelのテストを可能にした
- RepositoryやViewModelをコンストラクタインジェクションを使ってDI

## 依存ライブラリ＆ツール等
### ライブラリ
#### OHHTTPStubs
- バックエンドのAPIができるまで、HTTP通信の確認ができない問題があった。そのため、今回はHTTPスタブをクライアント内で設定することができるライブラリとしてOHHTTPStubsを選択しました。
- このライブラリを用いることで、非同期でRepositoryのテストを事前に行いました。
- テストでは正常系と異常系を用意し、実際のリクエストを行った時にどういった振る舞いをするかについて確認することができました。
##### 選定理由
このライブラリはObjective-Cの時代からある老舗のHTTPスタブライブラリであり、現在も開発が進められています。
また、今回のテストではスタブを用意するために使用したため、多くのことができる他のテストライブラリと比べてより使い方がシンプルでアプリ自体のパフォーマンスに影響を与えないライブラリだと判断したためこのライブラリを選定しました。

### ツール
#### Xcodegen
- .xcodeprojファイルのコンフリクトを防ぐため。利用停止する場合は生成された.xcodeprojファイルをそのままpushすることで簡単に移行できるので選択した。
#### Swiftlint
- 構文を統一することで読みやすさと、エラーの早期発見を行うことができるため導入しました。また、プルリクエスト時に自動チェックを行うために、Github Actionsにも導入しました。
## チャレンジポイント
- SwiftUIをUIフレームワークとして選択した点。UIKitと比較した時、成熟しきっていない部分もあるが、MVCアーキテクチャに囚われず他のアーキテクチャの選定を行いやすいなど、SwiftUIの方が将来性がありどうしても厳しい部分はUIKitを組み合わせて補えるという判断でSwiftUIを選択した。

# Xcodegenのインストール
Homebrewの場合
```
brew install xcodegen
```
その他のインストール方法は https://github.com/yonaskolb/XcodeGen を参照してください。

# .xcodeprojの生成
このプロジェクトをクローンした後、以下のコマンドで生成してください。
```
cd 2108-ace-c-ios
xcodegen generate
```


# 開発時のルール

## 開発方法

1. `main` ブランチから開発用のブランチを切る。（ブランチ名については下のブランチ命名規則を参照）
2. 開発用のブランチで開発を進める。（このブランチからさらにブランチを切ってマージをさせる分には自由にやってもらって大丈夫です。コミットのルールについては下記を参照）
4. `main` -> 開発用ブランチにマージをし、コンフリクトが発生していないか確認する。(大きな破壊的変更を加えた時のみ)
5. 開発用のブランチ -> `main` にプルリクを出す。
6. レビュアーが承認した後、**レビュアーが実際にマージを行う**。(レビューして欲しい時はReviewersに追加)
7. レビュアーがマージの後、PRブランチを削除する

## テストに関して
- テスト関数は日本語で命名する

## ブランチ命名規則

- 新規ページ `design/[ページ名]`
- 新規機能 `feat/[機能名]`
- 既存機能の修正 `fix/[機能名]`
- バグ修正 `hotfix/[バグ名]`
- リリース `release/[バージョン]`


## コミットのルール

- コメントの言語（日・英）に関してはとくに定めていません。
- 頭に、タグ（add:, update:, fix: など）をつけてもらえると非常に見やすいかと思います。
- コミットの粒度については、なるべく細かめにお願いします。（目安としては、1機能1コミット）
- ドキュメントは直接mainにコミットしてもOKです。
