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
            .padding(5)
            HStack{
                Text("Note directory: ")
                Picker(of: database.savesDirectories, selection: $chosenFolder)
                Button("✏️ Edit directories"){
                    editingDirectories = true
                }
            }
            let nameExists = database.notes.filter{ $0.title == noteTitle}
            HStack{
                Button("↩ Cancel note creation")
                {
                    creatingNote = false
                }
                if chosenFolder != nil && noteTitle != "" && nameExists.count == 0{
                    Button("+ Create note", action: {
                        database.createNote(title: noteTitle, folder: chosenFolder!)
                        currentNote = database.notes[0]
                        creatingNote = false
                    })
                } else if nameExists.count != 0{
                    Text("Note with the same name already exists")
                        .foregroundColor(.red)
                }
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
    @Environment(\.chooseFile) var chooseFile
    var body: some View{
        
        ForEach(database.configString) { directory in
            HStack{
                Text(String(directory))
                Button("🗑️ Remove"){
                    database.configString = database.configString.filter{$0 != directory}
                    database.updateDirectories(directories: database.configString)
                }
            }
        }
        HStack{
            Button("+ Add"){
                Task {
                    guard let file = await chooseFile(allowSelectingFiles: false, allowSelectingDirectories: true) else {
                        return
                    }
                    database.configString.append(String.SubSequence(file.absoluteString.dropFirst(7)))
                    database.updateDirectories(directories: database.configString)
                }
                //TODO: make it a filepicker, if it's possible
                // database.configString.append(String.SubSequence(newDirectory))
                // database.updateDirectories(directories: database.configString)
                // newDirectory = ""
            }
        }.padding(5)
        Text("if the directory does not exist, crossnotes will attempt to create it")
            .font(Font.system(size: 10))
        Button("↩ Return to note creation")
        {
            editingDirectories = false
        }
    }
}