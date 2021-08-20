import SwiftUI

@main
struct AceCiOSApp: App {
    var body: some Scene {
        WindowGroup {
            TestAPI(vm: TestAPIViewModel())
            //            RootView()
            //            MockAPIView(vm: MockTimeTableViewModel())
        }
    }
}
