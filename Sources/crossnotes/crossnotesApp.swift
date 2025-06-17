import SwiftCrossUI
import DefaultBackend

@main
struct crossnotesApp: App {
   
    var body: some Scene {
        @State var database = Database()
        WindowGroup("crossnotes") {
            HelloWorldView()
        }
    }
}

struct HelloWorldView : View{
    var body: some View{
        Text("haiiiiiiii")
    }
}
