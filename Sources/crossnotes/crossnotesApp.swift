import SwiftCrossUI
import DefaultBackend
import Foundation

@main
struct crossnotesApp: App {
    @State var database = Database()
    var body: some Scene {
        WindowGroup("crossnotes") {
            MainView(database: $database)
            // NotesTestView(database: $database)
            // NoteCreationView(database: $database)
            // DirectoryEditView(database: $database)
        }
    }
}

struct MainView: View{
    @State var selectedNote: Note?
    @Binding var database: Database
    @State var creatingNote = false
    var body: some View{
        NavigationSplitView(sidebar: {
            Button("+ New note")
            {
                creatingNote = true
            }.padding(.top, 5)
            ScrollView{
                ForEach(database.notes){ note in
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(selectedNote?.title == note.title ? Color.gray.opacity(0.5) : Color.black.opacity(0))
                        VStack{
                            Text(note.title)
                                .font(.sidebarTitle)
                            let trimmed = note.content.replacingOccurrences(of: "\n", with: " ")
                            Text(note.content.count > 20 ? String(trimmed.prefix(20)) + "..." : trimmed)
                        }
                    }.onTapGesture {
                        selectedNote = note
                    }
                    .frame(width: 200, height: 80)
                }.padding(5)
            }
            
        }, detail: {
            if(!creatingNote)
            {
                if selectedNote != nil{
                    NoteView(note: Binding($selectedNote)!, database: $database, currentNote: $selectedNote)
                        .padding(5)
                }else{
                    Text("^-ω-^")
                }
            }else{
                NoteCreationView(database: $database, currentNote: $selectedNote, creatingNote: $creatingNote)
            }
        })
    }
}

struct NoteView: View{
    //this will be force unwrapped
    @Binding var note: Note
    @Binding var database: Database
    @State var previousNoteName = ""
    @State var editingTitle = false
    @Binding var currentNote: Note?
    @State var editing = false
    var body: some View{
        //TODO: note deleting!
        if(!editingTitle)
        {
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(editing ? Color.gray.opacity(0.5) : Color.black.opacity(0))
                    Text("✏️")
                }.frame(width: 30, height: 30)
                .onTapGesture {
                    editing = true
                }
                .padding(.trailing, -10)
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(editing ?  Color.black.opacity(0) : Color.gray.opacity(0.5))
                    Text("👁️")
                }.frame(width: 30, height: 30)
                .onTapGesture {
                    editing = false
                }
                Spacer()
                Text(note.title)
                    .font(.noteTitle)
                    .onTapGesture {
                        editingTitle = true
                    }  
                Spacer()
                Button("🗑️")
                {
                    database.deleteNote(noteURL: note.noteURL)
                        currentNote = nil
                }
                    .foregroundColor(Color.red)
                    .font(.noteTitle)
                    .padding(.trailing, 5)
            }
        } else {
            //TODO: add title editing functionality
            TextField(text: $note.title)
                .font(.noteTitle)
                .onSubmit {
                    //empty names are problematic so let's check that :P
                    let nameExists = database.notes.filter{ $0.title == note.title}
                    if(note.title != "" && nameExists.count == 0)
                    {
                        database.deleteNote(noteURL: note.noteURL)
                        database.createNote(title: note.title, folder: note.noteFolder)
                        note.noteURL = note.noteFolder.appendingPathComponent(note.title).appendingPathExtension("txt")
                        database.saveNote(note: note)
                        editingTitle = false
                    }
                }
        }
        if(editing){
            TextEditor(text: $note.content)
            .padding(.bottom, 20)
            .onChange(of: note.content) {
                if(previousNoteName == note.title)
                {
                    database.saveNote(note: note)
                }else{
                    previousNoteName = note.title
                    editingTitle = false
                }
            }
        }else{
            MarkdownText(text: note.content)
            .padding(.leading, 5)
            Spacer()
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
    @Binding var currentNote: Note?
    @Binding var creatingNote: Bool
    var body: some View{
        TextField("Note title", text: $noteTitle)
        Picker(of: database.savesDirectories, selection: $chosenFolder)
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