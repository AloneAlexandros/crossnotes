import SwiftCrossUI
import DefaultBackend
import Foundation

struct NoteView: View{
    //this will be force unwrapped
    @Binding var note: Note
    @Binding var database: Database
    @State var previousNoteName = ""
    @State var editingTitle = false
    @Binding var currentNote: Note?
    @State var editing = false
    var body: some View{
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