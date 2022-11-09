//
// BudgetTracker
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let modelManager = ModelManagerImpl(coreDataManager: CoreDataManger(), networkManager: NetworManagerImpl())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let mainViewController = MainViewController(modelManager: modelManager)
        window.rootViewController = UINavigationController(rootViewController: mainViewController)
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        modelManager.saveContext()
    }

}
