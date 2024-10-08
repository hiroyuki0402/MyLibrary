//
//  File.swift
//  MyLibrary
//
//  Created by SHIRAISHI HIROYUKI on 2024/10/08.
//

import Foundation

extension String {
    public enum CommonString {
        public enum CommonTitle {
            // MARK: - 共通

            /// OK
            public static let commonOK = "OK"

            /// 完了
            public static let commonDone = "完了"

            /// キャンセル
            public static let commonCancel = "キャンセル"

            /// 保存
            public static let commonSave = "保存"

            /// 編集
            public static let commonEdit = "編集"

            /// 削除
            public static let commonDelete = "削除"

            /// はい
            public static let commonYes = "はい"

            /// いいえ
            public static let commonNo = "いいえ"

            /// 再試行
            public static let commonRetry = "再試行"

            /// 次へ
            public static let commonNext = "次へ"

            /// 戻る
            public static let commonBack = "戻る"

            /// 閉じる
            public static let commonClose = "閉じる"

            /// 続ける
            public static let commonContinue = "続ける"

            /// 確認
            public static let commonConfirm = "確認"

            /// エラー
            public static let commonError = "エラー"

            /// 警告
            public static let commonWarning = "警告"

            /// 成功
            public static let commonSuccess = "成功"

            /// 失敗
            public static let commonFail = "失敗"

            /// 読み込み中...
            public static let commonLoading = "読み込み中..."

            /// お待ちください...
            public static let commonPleaseWait = "お待ちください..."

            /// 検索
            public static let commonSearch = "検索"

            /// 設定
            public static let commonSettings = "設定"

            /// ヘルプ
            public static let commonHelp = "ヘルプ"

            /// サインイン
            public static let commonSignIn = "サインイン"

            /// サインアウト
            public static let commonSignOut = "サインアウト"

            /// 更新
            public static let commonUpdate = "更新"

            /// もっと見る
            public static let commonViewMore = "もっと見る"

            /// 詳紀
            public static let commonDetails = "詳紀"

            /// その他のオプション
            public static let commonMoreOptions = "その他のオプション"

            /// スキップ
            public static let commonSkip = "スキップ"

            /// 送信
            public static let commonSubmit = "送信"

            /// プライバシーポリシー
            public static let commonPrivacyPolicy = "プライバシーポリシー"

            /// 利用規約
            public static let commonTermsOfService = "利用規約"

            /// フィードバック
            public static let commonFeedback = "フィードバック"

            /// バージョン
            public static let commonVersion = "バージョン"

            /// お問い合わせ
            public static let commonContactUs = "お問い合わせ"

            /// 適用
            public static let commonApply = "適用"

            /// リセット
            public static let commonReset = "リセット"

            /// さらに読み込む
            public static let commonLoadMore = "さらに読み込む"

            /// 全て見る
            public static let commonSeeAll = "全て見る"

            /// 閉じる
            public static let commonDismiss = "閉じる"

            /// 展開する
            public static let commonExpand = "展開する"

            /// 折りたたむ
            public static let commonCollapse = "折りたたむ"

            /// 作成
            public static let commonCreate = "作成"

            /// 追加
            public static let commonAdd = "追加"

            /// 削除
            public static let commonRemove = "削除"

            /// 更新
            public static let commonRefresh = "更新"

            /// 有効にする
            public static let commonEnable = "有効にする"

            /// 無効にする
            public static let commonDisable = "無効にする"

            /// 選択
            public static let commonSelect = "選択"

            /// 選択解除
            public static let commonDeselect = "選択解除"

            /// エクスポート
            public static let commonExport = "エクスポート"

            /// インポート
            public static let commonImport = "インポート"

            /// アップロード
            public static let commonUpload = "アップロード"

            /// ダウンロード
            public static let commonDownload = "ダウンロード"

            /// 印刷
            public static let commonPrint = "印刷"

            /// 終了
            public static let commonExit = "終了"

            /// 変更
            public static let commonChange = "変更"

            /// 管理
            public static let commonManage = "管理"

            /// アクセス
            public static let commonAccess = "アクセス"

            /// 認証
            public static let commonAuthorize = "認証"

            /// ブロック
            public static let commonBlock = "ブロック"

            /// ブロック解除
            public static let commonUnblock = "ブロック解除"

            /// 報告
            public static let commonReport = "報告"

            /// 送信
            public static let commonSend = "送信"

            /// 受信
            public static let commonReceive = "受信"

            /// 返信
            public static let commonReply = "返信"

            /// 転送
            public static let commonForward = "転送"

            /// 共有
            public static let commonShare = "共有"

            /// サポート
            public static let commonSupport = "サポート"

            /// 通知
            public static let commonNotifications = "通知"

            /// アラート
            public static let commonAlerts = "アラート"

            /// メッセージ
            public static let commonMessages = "メッセージ"

            /// 情報
            public static let commonInfo = "情報"

            /// ヒント
            public static let commonTips = "ヒント"

            /// トリック
            public static let commonTricks = "トリック"

            /// チュートリアル
            public static let commonTutorial = "チュートリアル"

            /// ガイド
            public static let commonGuide = "ガイド"

            /// よくある質問
            public static let commonFAQ = "よくある質問"

            /// トラブルシューティング
            public static let commonTroubleshooting = "トラブルシューティング"

            /// 言語
            public static let commonLanguage = "言語"

            /// 探索
            public static let commonExplore = "探索"

            /// ギャラリー
            public static let commonGallery = "ギャラリー"

            /// プロフィール
            public static let commonProfile = "プロフィール"

            /// 詳細設定
            public static let commonSettingsAdvanced = "詳細設定"

            /// 法的情報
            public static let commonLegal = "法的情報"

            /// 課金情報
            public static let commonBilling = "課金情報"

            /// サブスクリプション
            public static let commonSubscriptions = "サブスクリプション"

            /// アカウント
            public static let commonAccount = "アカウント"

            /// セキュリティ
            public static let commonSecurity = "セキュリティ"

            /// プライバシー
            public static let commonPrivacy = "プライバシー"

            /// ログアウト
            public static let commonLogout = "ログアウト"

            /// プッシュ通知
            public static let commonNotificationsPush = "プッシュ通知"

            /// 変更を保存
            public static let commonSaveChanges = "変更を保存"

            /// 元に戻す
            public static let commonUndo = "元に戻す"

            /// やり直し
            public static let commonRedo = "やり直し"

            /// 新規
            public static let commonNew = "新規"

            /// 開く
            public static let commonOpen = "開く"

            /// ビュー
            public static let commonView = "ビュー"

            /// 退出
            public static let commonLeave = "退出"

            /// 入る
            public static let commonEnter = "入る"

            /// 開始
            public static let commonStart = "開始"

            /// 停止
            public static let commonStop = "停止"

            /// 一時停止
            public static let commonPause = "一時停止"

            /// 再開
            public static let commonResume = "再開"

            /// 計算
            public static let commonCalculate = "計算"

            /// 分析
            public static let commonAnalyze = "分析"

            /// 並び替え
            public static let commonSort = "並び替え"

            /// フィルタ
            public static let commonFilter = "フィルタ"

            /// タイムライン
            public static let commonTimeline = "タイムライン"

            /// ドラフト
            public static let commonDrafts = "ドラフト"

            /// すべて
            public static let commonAll = "すべて"

            /// アクティブ
            public static let commonActive = "アクティブ"

            /// 非アクティブ
            public static let commonInactive = "非アクティブ"

            /// お気に入り
            public static let commonFavorited = "お気に入り"

            /// アーカイブ
            public static let commonArchived = "アーカイブ"

            /// スケジュール
            public static let commonScheduled = "スケジュール"

            /// 履歌
            public static let commonHistory = "履歌"

            /// おすすめ
            public static let commonRecommendations = "おすすめ"

            /// 添付ファイル
            public static let commonAttachments = "添付ファイル"

            /// PDFをダウンロード
            public static let commonDownloadPDF = "PDFをダウンロード"

            /// 詳細を見る
            public static let commonViewDetails = "詳細を見る"

            /// 履歴をクリア
            public static let commonClearHistory = "履歴をクリア"

            /// サポートに連絡
            public static let commonContactSupport = "サポートに連絡"

            /// ナレッジベース
            public static let commonKnowledgeBase = "ナレッジベース"

            /// ユーザーガイド
            public static let commonUserGuide = "ユーザーガイド"

            /// ようこそ
            public static let commonWelcome = "ようこそ"

            /// 紹介
            public static let commonIntroduction = "紹介"

            /// 概要
            public static let commonOverview = "概要"

            /// チュートリアルを始める
            public static let commonTutorialStart = "チュートリアルを始める"

            /// 完了
            public static let commonComplete = "完了"

            /// 未完了
            public static let commonIncomplete = "未完了"

        }
    }
}
