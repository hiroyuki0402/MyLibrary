//
//  File.swift
//  MyLibrary
//
//  Created by SHIRAISHI HIROYUKI on 2024/10/08.
//

import Foundation

extension String {
    public enum ErrorString {
        public enum CommonErrorString {
            // MARK: - 共通
            /// ネットワーク接続がありません。
            public static let errorNetworkUnavailable = "ネットワーク接続がありません。"

            /// サーバーが応答していません。
            public static let errorServerNotResponding = "サーバーが応答していません。"

            /// ユーザー名またはパスワードが正しくありません。
            public static let errorInvalidCredentials = "ユーザー名またはパスワードが正しくありません。"

            /// セッションが期限切れです。再度ログインしてください。
            public static let errorSessionExpired = "セッションが期限切れです。再度ログインしてください。"

            /// アクセス権限がありません。
            public static let errorPermissionDenied = "アクセス権限がありません。"

            /// 要求されたリソースが見つかりませんでした。
            public static let errorNotFound = "要求されたリソースが見つかりませんでした。"

            /// データが破損しています。
            public static let errorDataCorrupted = "データが破損しています。"

            /// 操作に失敗しました。
            public static let errorOperationFailed = "操作に失敗しました。"

            /// 保存に失敗しました。
            public static let errorSaveFailed = "保存に失敗しました。"

            /// 削除に失敗しました。
            public static let errorDeleteFailed = "削除に失敗しました。"

            /// 更新に失敗しました。
            public static let errorUpdateFailed = "更新に失敗しました。"

            /// アップロードに失敗しました。
            public static let errorUploadFailed = "アップロードに失敗しました。"

            /// ダウンロードに失敗しました。
            public static let errorDownloadFailed = "ダウンロードに失敗しました。"

            /// ファイルにアクセスできません。
            public static let errorFileNotAccessible = "ファイルにアクセスできません。"

            /// サービスが利用できません。しばらくしてから再度お試しください。
            public static let errorServiceUnavailable = "サービスが利用できません。しばらくしてから再度お試しください。"

            /// 支払いが必要です。
            public static let errorPaymentRequired = "支払いが必要です。"

            /// 内部エラーが発生しました。
            public static let errorInternal = "内部エラーが発生しました。"

            /// 予期せぬエラーが発生しました。
            public static let errorUnexpected = "予期せぬエラーが発生しました。"

            /// 設定エラーが発生しました。
            public static let errorConfiguration = "設定エラーが発生しました。"

            /// 制限を超えました。
            public static let errorLimitExceeded = "制限を超えました。"

            /// アカウントが無効になっています。
            public static let errorAccountDisabled = "アカウントが無効になっています。"

            /// コンテンツがブロックされています。
            public static let errorContentBlocked = "コンテンツがブロックされています。"

            /// 無効なレスポンスを受け取りました。
            public static let errorInvalidResponse = "無効なレスポンスを受け取りました。"

            /// この機能は現在利用できません。
            public static let errorFeatureNotAvailable = "この機能は現在利用できません。"

            /// リクエストの処理中にエラーが発生しました。
            public static let errorProcessingRequest = "リクエストの処理中にエラーが発生しました。"

            /// データベースエラーが発生しました。
            public static let errorDatabase = "データベースエラーが発生しました。"

            /// タイムアウトが発生しました。もう一度試してください。
            public static let errorTimeout = "タイムアウトが発生しました。もう一度試してください。"

            /// ストレージが不足しています。
            public static let errorInsufficientStorage = "ストレージが不足しています。"

            /// レート制限を超えました。
            public static let errorRateLimitExceeded = "レート制限を超えました。"

            /// 重複したエントリが存在します。
            public static let errorDuplicateEntry = "重複したエントリが存在します。"

            /// バリデーションエラーが発生しました。
            public static let errorValidationFailed = "バリデーションエラーが発生しました。"

            /// 必要なフィールドが入力されていません。
            public static let errorRequiredFieldMissing = "必要なフィールドが入力されていません。"

            /// ファイルタイプが正しくありません。
            public static let errorWrongFileType = "ファイルタイプが正しくありません。"

            /// 復号化に失敗しました。
            public static let errorDecryptionFailed = "復号化に失敗しました。"

            /// 暗号化に失敗しました。
            public static let errorEncryptionFailed = "暗号化に失敗しました。"

            /// 無効な操作です。
            public static let errorInvalidOperation = "無効な操作です。"

            /// 項目がロックされています。
            public static let errorItemLocked = "項目がロックされています。"

            /// 現在メンテナンス中です。
            public static let errorMaintenance = "現在メンテナンス中です。"

            /// 非推奨の機能です。
            public static let errorDeprecated = "非推奨の機能です。"

            /// この地域では利用できません。
            public static let errorRegionRestricted = "この地域では利用できません。"

            /// 認証のタイムアウトが発生しました。
            public static let errorAuthenticationTimeout = "認証のタイムアウトが発生しました。"

            /// 接続が失われました。
            public static let errorConnectionLost = "接続が失われました。"

            /// 必要な権限がありません。
            public static let errorInsufficientPermissions = "必要な権限がありません。"

            /// トークンが無効です。
            public static let errorInvalidToken = "トークンが無効です。"

            /// クォータを超過しました。
            public static let errorQuotaExceeded = "クォータを超過しました。"

            /// リソースがロックされています。
            public static let errorResourceLocked = "リソースがロックされています。"

            /// 依存関係のエラーが発生しました。
            public static let errorDependencyFailed = "依存関係のエラーが発生しました。"

            /// APIのレートリミットが超えられました。
            public static let errorAPIRateLimitExceeded = "APIのレートリミットが超えられました。"

            /// ハードウェアの障害が発生しました。
            public static let errorHardwareFailure = "ハードウェアの障害が発生しました。"

            /// ソフトウェアの障害が発生しました。
            public static let errorSoftwareFailure = "ソフトウェアの障害が発生しました。"

            /// データの整合性に問題が発生しました。
            public static let errorDataIntegrityFailure = "データの整合性に問題が発生しました。"

            /// 入力が無効です。
            public static let errorInvalidInput = "入力が無効です。"

            /// 互換性のないバージョンです。
            public static let errorIncompatibleVersion = "互換性のないバージョンです。"

            /// バックアップに失敗しました。
            public static let errorBackupFailed = "バックアップに失敗しました。"

            /// 復元に失敗しました。
            public static let errorRestoreFailed = "復元に失敗しました。"

            /// 移行に失敗しました。
            public static let errorMigrationFailed = "移行に失敗しました。"

            /// プロトコルエラーが発生しました。
            public static let errorProtocolError = "プロトコルエラーが発生しました。"

            /// 設定が無効です。
            public static let errorInvalidConfiguration = "設定が無効です。"

            /// セキュリティ違反が発生しました。
            public static let errorSecurityBreach = "セキュリティ違反が発生しました。"

            /// データ損失が発生しました。
            public static let errorDataLoss = "データ損失が発生しました。"

            /// システムが過負荷状態です。
            public static let errorSystemOverload = "システムが過負荷状態です。"

            /// 操作がキャンセルされました。
            public static let errorOperationCanceled = "操作がキャンセルされました。"

            /// キーが見つかりませんでした。
            public static let errorKeyNotFound = "キーが見つかりませんでした。"

            /// 範囲外のアクセスです。
            public static let errorOutOfBounds = "範囲外のアクセスです。"

            /// 空のレスポンスを受け取りました。
            public static let errorEmptyResponse = "空のレスポンスを受け取りました。"

            /// 必要な依存関係が見つかりません。
            public static let errorMissingDependency = "必要な依存関係が見つかりません。"

            /// ネットワーク設定エラーです。
            public static let errorNetworkConfiguration = "ネットワーク設定エラーです。"

            /// データが破損しています。
            public static let errorCorruptedData = "データが破損しています。"

            /// 予期せぬシャットダウンが発生しました。
            public static let errorUnexpectedShutdown = "予期せぬシャットダウンが発生しました。"

            /// ユーザーがブロックされています。
            public static let errorUserBlocked = "ユーザーがブロックされています。"

            /// 無効なファイルタイプです。
            public static let errorInvalidFileType = "無効なファイルタイプです。"

            /// セッションの競合が発生しました。
            public static let errorSessionConflict = "セッションの競合が発生しました。"

            /// リソースが枯渇しました。
            public static let errorResourceDepleted = "リソースが枯渇しました。"

            /// まだ実装されていません。
            public static let errorNotImplemented = "まだ実装されていません。"

            /// サービスが中断されました。
            public static let errorServiceInterrupted = "サービスが中断されました。"

            /// 無効な状態です。
            public static let errorInvalidState = "無効な状態です。"

        }
    }
}
