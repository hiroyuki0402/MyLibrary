//
//  File.swift
//  MyLibrary
//
//  Created by SHIRAISHI HIROYUKI on 2024/10/08.
//

import Foundation

public extension String {
    enum CommonString {
        public enum CommonTitle {
            // MARK: - 共通

            /// OK
            static let commonOK = "OK"

            /// 完了
            static let commonDone = "完了"

            /// キャンセル
            static let commonCancel = "キャンセル"

            /// 保存
            static let commonSave = "保存"

            /// 編集
            static let commonEdit = "編集"

            /// 削除
            static let commonDelete = "削除"

            /// はい
            static let commonYes = "はい"

            /// いいえ
            static let commonNo = "いいえ"

            /// 再試行
            static let commonRetry = "再試行"

            /// 次へ
            static let commonNext = "次へ"

            /// 戻る
            static let commonBack = "戻る"

            /// 閉じる
            static let commonClose = "閉じる"

            /// 続ける
            static let commonContinue = "続ける"

            /// 確認
            static let commonConfirm = "確認"

            /// エラー
            static let commonError = "エラー"

            /// 警告
            static let commonWarning = "警告"

            /// 成功
            static let commonSuccess = "成功"

            /// 失敗
            static let commonFail = "失敗"

            /// 読み込み中...
            static let commonLoading = "読み込み中..."

            /// お待ちください...
            static let commonPleaseWait = "お待ちください..."

            /// 検索
            static let commonSearch = "検索"

            /// 設定
            static let commonSettings = "設定"

            /// ヘルプ
            static let commonHelp = "ヘルプ"

            /// サインイン
            static let commonSignIn = "サインイン"

            /// サインアウト
            static let commonSignOut = "サインアウト"

            /// 更新
            static let commonUpdate = "更新"

            /// もっと見る
            static let commonViewMore = "もっと見る"

            /// 詳紀
            static let commonDetails = "詳紀"

            /// その他のオプション
            static let commonMoreOptions = "その他のオプション"

            /// スキップ
            static let commonSkip = "スキップ"

            /// 送信
            static let commonSubmit = "送信"

            /// プライバシーポリシー
            static let commonPrivacyPolicy = "プライバシーポリシー"

            /// 利用規約
            static let commonTermsOfService = "利用規約"

            /// フィードバック
            static let commonFeedback = "フィードバック"

            /// バージョン
            static let commonVersion = "バージョン"

            /// お問い合わせ
            static let commonContactUs = "お問い合わせ"

            /// 適用
            static let commonApply = "適用"

            /// リセット
            static let commonReset = "リセット"

            /// さらに読み込む
            static let commonLoadMore = "さらに読み込む"

            /// 全て見る
            static let commonSeeAll = "全て見る"

            /// 閉じる
            static let commonDismiss = "閉じる"

            /// 展開する
            static let commonExpand = "展開する"

            /// 折りたたむ
            static let commonCollapse = "折りたたむ"

            /// 作成
            static let commonCreate = "作成"

            /// 追加
            static let commonAdd = "追加"

            /// 削除
            static let commonRemove = "削除"

            /// 更新
            static let commonRefresh = "更新"

            /// 有効にする
            static let commonEnable = "有効にする"

            /// 無効にする
            static let commonDisable = "無効にする"

            /// 選択
            static let commonSelect = "選択"

            /// 選択解除
            static let commonDeselect = "選択解除"

            /// エクスポート
            static let commonExport = "エクスポート"

            /// インポート
            static let commonImport = "インポート"

            /// アップロード
            static let commonUpload = "アップロード"

            /// ダウンロード
            static let commonDownload = "ダウンロード"

            /// 印刷
            static let commonPrint = "印刷"

            /// 終了
            static let commonExit = "終了"

            /// 変更
            static let commonChange = "変更"

            /// 管理
            static let commonManage = "管理"

            /// アクセス
            static let commonAccess = "アクセス"

            /// 認証
            static let commonAuthorize = "認証"

            /// ブロック
            static let commonBlock = "ブロック"

            /// ブロック解除
            static let commonUnblock = "ブロック解除"

            /// 報告
            static let commonReport = "報告"

            /// 送信
            static let commonSend = "送信"

            /// 受信
            static let commonReceive = "受信"

            /// 返信
            static let commonReply = "返信"

            /// 転送
            static let commonForward = "転送"

            /// 共有
            static let commonShare = "共有"

            /// サポート
            static let commonSupport = "サポート"

            /// 通知
            static let commonNotifications = "通知"

            /// アラート
            static let commonAlerts = "アラート"

            /// メッセージ
            static let commonMessages = "メッセージ"

            /// 情報
            static let commonInfo = "情報"

            /// ヒント
            static let commonTips = "ヒント"

            /// トリック
            static let commonTricks = "トリック"

            /// チュートリアル
            static let commonTutorial = "チュートリアル"

            /// ガイド
            static let commonGuide = "ガイド"

            /// よくある質問
            static let commonFAQ = "よくある質問"

            /// トラブルシューティング
            static let commonTroubleshooting = "トラブルシューティング"

            /// 言語
            static let commonLanguage = "言語"

            /// 探索
            static let commonExplore = "探索"

            /// ギャラリー
            static let commonGallery = "ギャラリー"

            /// プロフィール
            static let commonProfile = "プロフィール"

            /// 詳細設定
            static let commonSettingsAdvanced = "詳細設定"

            /// 法的情報
            static let commonLegal = "法的情報"

            /// 課金情報
            static let commonBilling = "課金情報"

            /// サブスクリプション
            static let commonSubscriptions = "サブスクリプション"

            /// アカウント
            static let commonAccount = "アカウント"

            /// セキュリティ
            static let commonSecurity = "セキュリティ"

            /// プライバシー
            static let commonPrivacy = "プライバシー"

            /// ログアウト
            static let commonLogout = "ログアウト"

            /// プッシュ通知
            static let commonNotificationsPush = "プッシュ通知"

            /// 変更を保存
            static let commonSaveChanges = "変更を保存"

            /// 元に戻す
            static let commonUndo = "元に戻す"

            /// やり直し
            static let commonRedo = "やり直し"

            /// 新規
            static let commonNew = "新規"

            /// 開く
            static let commonOpen = "開く"

            /// ビュー
            static let commonView = "ビュー"

            /// 退出
            static let commonLeave = "退出"

            /// 入る
            static let commonEnter = "入る"

            /// 開始
            static let commonStart = "開始"

            /// 停止
            static let commonStop = "停止"

            /// 一時停止
            static let commonPause = "一時停止"

            /// 再開
            static let commonResume = "再開"

            /// 計算
            static let commonCalculate = "計算"

            /// 分析
            static let commonAnalyze = "分析"

            /// 並び替え
            static let commonSort = "並び替え"

            /// フィルタ
            static let commonFilter = "フィルタ"

            /// タイムライン
            static let commonTimeline = "タイムライン"

            /// ドラフト
            static let commonDrafts = "ドラフト"

            /// すべて
            static let commonAll = "すべて"

            /// アクティブ
            static let commonActive = "アクティブ"

            /// 非アクティブ
            static let commonInactive = "非アクティブ"

            /// お気に入り
            static let commonFavorited = "お気に入り"

            /// アーカイブ
            static let commonArchived = "アーカイブ"

            /// スケジュール
            static let commonScheduled = "スケジュール"

            /// 履歌
            static let commonHistory = "履歌"

            /// おすすめ
            static let commonRecommendations = "おすすめ"

            /// 添付ファイル
            static let commonAttachments = "添付ファイル"

            /// PDFをダウンロード
            static let commonDownloadPDF = "PDFをダウンロード"

            /// 詳細を見る
            static let commonViewDetails = "詳細を見る"

            /// 履歴をクリア
            static let commonClearHistory = "履歴をクリア"

            /// サポートに連絡
            static let commonContactSupport = "サポートに連絡"

            /// ナレッジベース
            static let commonKnowledgeBase = "ナレッジベース"

            /// ユーザーガイド
            static let commonUserGuide = "ユーザーガイド"

            /// ようこそ
            static let commonWelcome = "ようこそ"

            /// 紹介
            static let commonIntroduction = "紹介"

            /// 概要
            static let commonOverview = "概要"

            /// チュートリアルを始める
            static let commonTutorialStart = "チュートリアルを始める"

            /// 完了
            static let commonComplete = "完了"

            /// 未完了
            static let commonIncomplete = "未完了"

        }
    }
}
