import Foundation

#if canImport(UIKit)
import UIKit
#endif


#if canImport(UIKit)
public extension UIViewController {
    /// Storyboardから特定のViewControllerに遷移
    ///
    /// Storyboardの名前とViewControllerのIdentifierを指定して、画面遷移する
    /// 遷移前にViewControllerに対して行いたいカスタム設定やデータの渡しを、
    /// クロージャを通じて実行することが可能
    ///
    /// - Parameters:
    ///   - storyboardName: 遷移先のViewControllerが存在するStoryboardの名前を指定
    ///   - viewControllerIdentifier: Storyboard内で遷移先のViewControllerに設定されたIdentifierを指定
    ///   - configuration: 遷移する前にViewControllerに対して行いたい設定やデータの渡しを記述するクロージャ
    ///     クロージャの引数として遷移先のViewControllerが渡る
    ///   - T: 遷移先のViewControllerの型をジェネリックパラメータとして指定
    ///
    /// - Example:
    ///   以下の例では、Storyboard名"Main"、Identifier"DetailViewController"のViewControllerに遷移し、
    ///   遷移前にそのViewControllerのプロパティに値を設定
    /// ```
    /// moveToViewController(storyboardName: "Main", viewControllerIdentifier: "DetailViewController") { (vc: DetailViewController) in
    ///     vc.detailItem = myData
    /// }
    /// ```
    ///
    /// - Note: このメソッドは、ナビゲーションコントローラが存在する場合には`push`遷移を、
    ///         存在しない場合にはモーダル遷移を使用し、遷移方法を変更したい場合は、
    ///         メソッド内の遷移ロジックを調整する
    func moveToViewController<T: UIViewController>(storyboardName: String, viewControllerIdentifier: String, configuration: @escaping (T) -> Void) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)

        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? T else {
            return
        }

        configuration(viewController)
        
        /// 遷移方法を適宜変更する
        if let navigationController = self.navigationController {
            /// ナビゲーションコントローラーがある場合はpushする
            navigationController.pushViewController(viewController, animated: true)
        } else {
            /// ナビゲーションコントローラーがない場合はmodal遷移など、他の方法を選択する
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }

}
#endif
