import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var appCoordinator: AppCoordinator?
    private let container = AppDIContainer()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let ws = (scene as? UIWindowScene) else { return }

        let nav = UINavigationController()
        let win = UIWindow(windowScene: ws)
        win.rootViewController = nav
        win.makeKeyAndVisible()
        window = win

        let coordinator = AppCoordinator(navigationController: nav, container: container)
        coordinator.start()
        appCoordinator = coordinator
    }
}
