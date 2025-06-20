import SwiftCrossUI
import DefaultBackend
import Foundation

@main
struct crossnotesApp: App {
    @State var database = Database()
    var body: some Scene {
        WindowGroup("crossnotes") {
            // NotesTestView(database: $database)
            // NoteCreationView(database: $database)
            DirectoryEditView(database: $database)
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

struct DirectoryEditView: View{
    @Binding var database: Database
    @State var newDirectory: String = ""
    var body: some View{
        
        ForEach(database.configString) { directory in
            HStack{
                Text(String(directory))
                Button("Delete"){
                    database.configString = database.configString.filter{$0 != directory}
                    database.updateDirectories(directories: database.configString)
                }
            }
        }
        HStack{
            TextField("Enter your directory", text: $newDirectory)
            Button("Add"){
                database.configString.append(String.SubSequence(newDirectory))
                database.updateDirectories(directories: database.configString)
            }
        }
    }
}