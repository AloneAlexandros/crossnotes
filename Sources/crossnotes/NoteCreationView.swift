import SwiftCrossUI
import DefaultBackend
import Foundation

struct NoteCreationView: View{
    @Binding var database: Database
    @State var noteTitle = ""
    @State var chosenFolder: URL? = nil
    @Binding var currentNote: Note?
    @Binding var creatingNote: Bool
    @State var editingDirectories: Bool = false
    var body: some View{
        if (!editingDirectories){
            TextField("Note title", text: $noteTitle)
            HStack{
                Text("Note directory: ")
                Picker(of: database.savesDirectories, selection: $chosenFolder)
                Button("✏️"){
                    editingDirectories = true
                }
            }
            let nameExists = database.notes.filter{ $0.title == noteTitle}
            if chosenFolder != nil && noteTitle != "" && nameExists.count == 0{
                Button("Create note", action: {
                    database.createNote(title: noteTitle, folder: chosenFolder!)
                    currentNote = database.notes[0]
                    creatingNote = false
                })
            } else if nameExists.count != 0{
                Text("Note with the same name already exists")
                    .foregroundColor(.red)
            }
        }else{
            DirectoryEditView(database: $database, editingDirectories: $editingDirectories)
        }
    }
}

struct DirectoryEditView: View{
    @Binding var database: Database
    @State var newDirectory: String = ""
    @Binding var editingDirectories: Bool
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