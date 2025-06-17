import SwiftCrossUI
import DefaultBackend

@main
struct crossnotesApp: App {
    @State var database = Database()
    var body: some Scene {
        WindowGroup("crossnotes") {
            NotesTestView(database: $database)
        }
    }
}

struct NotesTestView: View{
    @Binding var database: Database
    var body: some View{
        ForEach(database.notes){ note in
            Text(note.title)
                .font(.noteTitle)
            Text(note.content)
                .padding(.bottom, 20)
        }
    }
}