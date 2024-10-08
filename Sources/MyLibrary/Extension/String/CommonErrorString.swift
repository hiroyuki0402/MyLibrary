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
            static let errorNetworkUnavailable = "ネットワーク接続がありません。"

            /// サーバーが応答していません。
            static let errorServerNotResponding = "サーバーが応答していません。"

            /// ユーザー名またはパスワードが正しくありません。
            static let errorInvalidCredentials = "ユーザー名またはパスワードが正しくありません。"

            /// セッションが期限切れです。再度ログインしてください。
            static let errorSessionExpired = "セッションが期限切れです。再度ログインしてください。"

            /// アクセス権限がありません。
            static let errorPermissionDenied = "アクセス権限がありません。"

            /// 要求されたリソースが見つかりませんでした。
            static let errorNotFound = "要求されたリソースが見つかりませんでした。"

            /// データが破損しています。
            static let errorDataCorrupted = "データが破損しています。"

            /// 操作に失敗しました。
            static let errorOperationFailed = "操作に失敗しました。"

            /// 保存に失敗しました。
            static let errorSaveFailed = "保存に失敗しました。"

            /// 削除に失敗しました。
            static let errorDeleteFailed = "削除に失敗しました。"

            /// 更新に失敗しました。
            static let errorUpdateFailed = "更新に失敗しました。"

            /// アップロードに失敗しました。
            static let errorUploadFailed = "アップロードに失敗しました。"

            /// ダウンロードに失敗しました。
            static let errorDownloadFailed = "ダウンロードに失敗しました。"

            /// ファイルにアクセスできません。
            static let errorFileNotAccessible = "ファイルにアクセスできません。"

            /// サービスが利用できません。しばらくしてから再度お試しください。
            static let errorServiceUnavailable = "サービスが利用できません。しばらくしてから再度お試しください。"

            /// 支払いが必要です。
            static let errorPaymentRequired = "支払いが必要です。"

            /// 内部エラーが発生しました。
            static let errorInternal = "内部エラーが発生しました。"

            /// 予期せぬエラーが発生しました。
            static let errorUnexpected = "予期せぬエラーが発生しました。"

            /// 設定エラーが発生しました。
            static let errorConfiguration = "設定エラーが発生しました。"

            /// 制限を超えました。
            static let errorLimitExceeded = "制限を超えました。"

            /// アカウントが無効になっています。
            static let errorAccountDisabled = "アカウントが無効になっています。"

            /// コンテンツがブロックされています。
            static let errorContentBlocked = "コンテンツがブロックされています。"

            /// 無効なレスポンスを受け取りました。
            static let errorInvalidResponse = "無効なレスポンスを受け取りました。"

            /// この機能は現在利用できません。
            static let errorFeatureNotAvailable = "この機能は現在利用できません。"

            /// リクエストの処理中にエラーが発生しました。
            static let errorProcessingRequest = "リクエストの処理中にエラーが発生しました。"

            /// データベースエラーが発生しました。
            static let errorDatabase = "データベースエラーが発生しました。"

            /// タイムアウトが発生しました。もう一度試してください。
            static let errorTimeout = "タイムアウトが発生しました。もう一度試してください。"

            /// ストレージが不足しています。
            static let errorInsufficientStorage = "ストレージが不足しています。"

            /// レート制限を超えました。
            static let errorRateLimitExceeded = "レート制限を超えました。"

            /// 重複したエントリが存在します。
            static let errorDuplicateEntry = "重複したエントリが存在します。"

            /// バリデーションエラーが発生しました。
            static let errorValidationFailed = "バリデーションエラーが発生しました。"

            /// 必要なフィールドが入力されていません。
            static let errorRequiredFieldMissing = "必要なフィールドが入力されていません。"

            /// ファイルタイプが正しくありません。
            static let errorWrongFileType = "ファイルタイプが正しくありません。"

            /// 復号化に失敗しました。
            static let errorDecryptionFailed = "復号化に失敗しました。"

            /// 暗号化に失敗しました。
            static let errorEncryptionFailed = "暗号化に失敗しました。"

            /// 無効な操作です。
            static let errorInvalidOperation = "無効な操作です。"

            /// 項目がロックされています。
            static let errorItemLocked = "項目がロックされています。"

            /// 現在メンテナンス中です。
            static let errorMaintenance = "現在メンテナンス中です。"

            /// 非推奨の機能です。
            static let errorDeprecated = "非推奨の機能です。"

            /// この地域では利用できません。
            static let errorRegionRestricted = "この地域では利用できません。"

            /// 認証のタイムアウトが発生しました。
            static let errorAuthenticationTimeout = "認証のタイムアウトが発生しました。"

            /// 接続が失われました。
            static let errorConnectionLost = "接続が失われました。"

            /// 必要な権限がありません。
            static let errorInsufficientPermissions = "必要な権限がありません。"

            /// トークンが無効です。
            static let errorInvalidToken = "トークンが無効です。"

            /// クォータを超過しました。
            static let errorQuotaExceeded = "クォータを超過しました。"

            /// リソースがロックされています。
            static let errorResourceLocked = "リソースがロックされています。"

            /// 依存関係のエラーが発生しました。
            static let errorDependencyFailed = "依存関係のエラーが発生しました。"

            /// APIのレートリミットが超えられました。
            static let errorAPIRateLimitExceeded = "APIのレートリミットが超えられました。"

            /// ハードウェアの障害が発生しました。
            static let errorHardwareFailure = "ハードウェアの障害が発生しました。"

            /// ソフトウェアの障害が発生しました。
            static let errorSoftwareFailure = "ソフトウェアの障害が発生しました。"

            /// データの整合性に問題が発生しました。
            static let errorDataIntegrityFailure = "データの整合性に問題が発生しました。"

            /// 入力が無効です。
            static let errorInvalidInput = "入力が無効です。"

            /// 互換性のないバージョンです。
            static let errorIncompatibleVersion = "互換性のないバージョンです。"

            /// バックアップに失敗しました。
            static let errorBackupFailed = "バックアップに失敗しました。"

            /// 復元に失敗しました。
            static let errorRestoreFailed = "復元に失敗しました。"

            /// 移行に失敗しました。
            static let errorMigrationFailed = "移行に失敗しました。"

            /// プロトコルエラーが発生しました。
            static let errorProtocolError = "プロトコルエラーが発生しました。"

            /// 設定が無効です。
            static let errorInvalidConfiguration = "設定が無効です。"

            /// セキュリティ違反が発生しました。
            static let errorSecurityBreach = "セキュリティ違反が発生しました。"

            /// データ損失が発生しました。
            static let errorDataLoss = "データ損失が発生しました。"

            /// システムが過負荷状態です。
            static let errorSystemOverload = "システムが過負荷状態です。"

            /// 操作がキャンセルされました。
            static let errorOperationCanceled = "操作がキャンセルされました。"

            /// キーが見つかりませんでした。
            static let errorKeyNotFound = "キーが見つかりませんでした。"

            /// 範囲外のアクセスです。
            static let errorOutOfBounds = "範囲外のアクセスです。"

            /// 空のレスポンスを受け取りました。
            static let errorEmptyResponse = "空のレスポンスを受け取りました。"

            /// 必要な依存関係が見つかりません。
            static let errorMissingDependency = "必要な依存関係が見つかりません。"

            /// ネットワーク設定エラーです。
            static let errorNetworkConfiguration = "ネットワーク設定エラーです。"

            /// データが破損しています。
            static let errorCorruptedData = "データが破損しています。"

            /// 予期せぬシャットダウンが発生しました。
            static let errorUnexpectedShutdown = "予期せぬシャットダウンが発生しました。"

            /// ユーザーがブロックされています。
            static let errorUserBlocked = "ユーザーがブロックされています。"

            /// 無効なファイルタイプです。
            static let errorInvalidFileType = "無効なファイルタイプです。"

            /// セッションの競合が発生しました。
            static let errorSessionConflict = "セッションの競合が発生しました。"

            /// リソースが枯渇しました。
            static let errorResourceDepleted = "リソースが枯渇しました。"

            /// まだ実装されていません。
            static let errorNotImplemented = "まだ実装されていません。"

            /// サービスが中断されました。
            static let errorServiceInterrupted = "サービスが中断されました。"

            /// 無効な状態です。
            static let errorInvalidState = "無効な状態です。"

        }
    }
}
