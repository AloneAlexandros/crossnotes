import SwiftCrossUI
import DefaultBackend
import Foundation

@main
struct crossnotesApp: App {
    @State var database = Database()
    var body: some Scene {
        WindowGroup("crossnotes") {
            NotesTestView(database: $database)
            NoteCreationView(database: $database)
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

struct NoteCreationView: View{
    @Binding var database: Database
    @State var noteTitle = ""
    @State var chosenFolder: URL? = nil
    var body: some View{
        TextField("Note title", text: $noteTitle)
        Picker(of: database.savesDirectories, selection: $chosenFolder)
        let nameExists = database.notes.filter{ $0.title == noteTitle}
        if chosenFolder != nil && noteTitle != "" && nameExists.count == 0{
            Button("Create note", action: {
                database.createNote(title: noteTitle, folder: chosenFolder!)
                //TODO: navigate away
            })
        } else if nameExists.count != 0{
            Text("Note with the same name already exists")
                .foregroundColor(.red)
        }
    }
}