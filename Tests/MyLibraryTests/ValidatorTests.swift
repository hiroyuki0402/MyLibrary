import XCTest
import Combine
import Foundation

@testable import MyLibrary

final class ValidatorTests: XCTestCase {

    // MARK: - Email

    func testEmailValidator_ValidEmail_ShouldReturnTrue() {
        /// 有効なメールアドレスを検証
        let result = Validators.email.validate("test@example.com", errorWords: "invalid email")
        XCTAssertTrue(result.isValid, "有効なメールアドレスが失敗として判定された")
        XCTAssertNil(result.error, "メールアドレスが有効ならerrorはnilになるはず")
    }

    func testEmailValidator_InvalidEmail_ShouldReturnFalse() {
        /// 無効なメールアドレスを検証
        let result = Validators.email.validate("testexample.com", errorWords: "invalid email")
        XCTAssertFalse(result.isValid, "無効なメールアドレスが成功として判定された")
        XCTAssertNil(result.error, "バリデーション失敗時もerrorがnilの場合があるが、問題がないか確認")
    }

    // MARK: - 電話番号

    func testPhoneValidator_ValidPhone_ShouldReturnTrue() {
        /// 10桁〜15桁の数字を有効とする
        let result = Validators.phone.validate("08012345678", errorWords: "invalid phone")
        XCTAssertTrue(result.isValid, "有効な電話番号が失敗として判定された")
    }

    func testPhoneValidator_InvalidPhone_ShouldReturnFalse() {
        /// 桁数が足りない、または多い場合
        let resultShort = Validators.phone.validate("012345", errorWords: "invalid phone")
        XCTAssertFalse(resultShort.isValid, "桁数が足りない電話番号が成功として判定された")

        let resultLong = Validators.phone.validate("01234567890123456", errorWords: "invalid phone")
        XCTAssertFalse(resultLong.isValid, "桁数が多い電話番号が成功として判定された")

        /// 数字以外の文字が混ざっている場合
        let resultAlpha = Validators.phone.validate("080-1234-5678", errorWords: "invalid phone")
        XCTAssertFalse(resultAlpha.isValid, "ハイフンが入った電話番号が成功として判定された")
    }

    // MARK: - URL

    func testURLValidator_ValidURL_ShouldReturnTrue() {
        let result = Validators.url.validate("https://example.com", errorWords: "invalid url")
        XCTAssertTrue(result.isValid, "有効なURLが失敗として判定された")
    }

    func testURLValidator_InvalidURL_ShouldReturnFalse() {
        /// スキームがない場合
        let resultNoScheme = Validators.url.validate("www.example.com", errorWords: "invalid url")
        XCTAssertFalse(resultNoScheme.isValid, "スキームがないURLが成功として判定された")

        /// スペースが含まれるなどの不正URL
        let resultWithSpace = Validators.url.validate("http: //example", errorWords: "invalid url")
        XCTAssertFalse(resultWithSpace.isValid, "スペースが含まれるURLが成功として判定された")
    }

    // MARK: - パスワード

    func testPasswordValidator_ValidPassword_ShouldReturnTrue() {
        /// それぞれの要件（大文字、小文字、数字、特殊文字、最小8文字）を満たすパスワード
        let password = "Abcdefg1!"
        let result = Validators.password.validate(password, errorWords: "")
        XCTAssertTrue(result.isValid, "有効なパスワードが失敗として判定された: \(result.log ?? "")")
    }

    func testPasswordValidator_MissingUppercase_ShouldReturnFalse() {
        /// 大文字が1文字もない場合
        let password = "abcdefg1!"
        let result = Validators.password.validate(password, errorWords: "パスワードエラー")
        XCTAssertFalse(result.isValid, "大文字がないパスワードが成功として判定された")
        XCTAssertNotNil(result.log, "失敗時のメッセージを確認: \(result.log ?? "")")
    }

    func testPasswordValidator_MissingLowercase_ShouldReturnFalse() {
        /// 小文字が1文字もない場合
        let password = "ABCDEFG1!"
        let result = Validators.password.validate(password, errorWords: "パスワードエラー")
        XCTAssertFalse(result.isValid, "小文字がないパスワードが成功として判定された")
    }

    func testPasswordValidator_MissingNumber_ShouldReturnFalse() {
        /// 数字が1文字もない場合
        let password = "Abcdefgh!"
        let result = Validators.password.validate(password, errorWords: "パスワードエラー")
        XCTAssertFalse(result.isValid, "数字がないパスワードが成功として判定された")
    }

    func testPasswordValidator_MissingSpecialCharacter_ShouldReturnFalse() {
        /// 特殊文字が1文字もない場合
        let password = "Abcdefg1"
        let result = Validators.password.validate(password)
        XCTAssertFalse(result.isValid, "特殊文字がないパスワードが成功として判定された")
    }

    func testPasswordValidator_TooShort_ShouldReturnFalse() {
        /// 8文字未満の場合
        let password = "Ab1!"
        let result = Validators.password.validate(password, errorWords: "短すぎるパスワード")
        XCTAssertFalse(result.isValid, "短すぎるパスワードが成功として判定された")
        XCTAssertTrue(result.log?.contains("短すぎるパスワード") ?? false, "エラーメッセージが上書きされているか確認")
    }

    // MARK: - Custom Regex

    func testCustomRegex_ValidString_ShouldReturnTrue() {
        /// 先頭に大文字3文字 + その後に数字2文字のパターンを定義
        let customPattern = "^[A-Z]{3}\\d{2}$"
        let customValidator = Validators.customRegex(pattern: customPattern)

        let result = customValidator.validate("ABC12", errorWords: "invalid custom format")
        XCTAssertTrue(result.isValid, "マッチする文字列が失敗として判定された")
        XCTAssertNil(result.error, "マッチに成功した場合、errorはnilになるはず")
    }

    func testCustomRegex_InvalidString_ShouldReturnFalse() {
        /// 上記パターンに合致しない文字列を検証
        let customPattern = "^[A-Z]{3}\\d{2}$"
        let customValidator = Validators.customRegex(pattern: customPattern)

        let result = customValidator.validate("AB12C", errorWords: "invalid custom format")
        XCTAssertFalse(result.isValid, "パターンに合わない文字列が成功として判定された")
        XCTAssertNil(result.error, "バリデーション失敗時もerrorはnilの可能性があるので確認")
    }
}
