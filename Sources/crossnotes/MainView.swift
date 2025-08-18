import SwiftCrossUI
import DefaultBackend
import Foundation

struct MainView: View{
    @State var selectedNote: Note?
    @Binding var database: Database
    @State var creatingNote = false
    @State var editingNote: Bool = false
    var body: some View{
        NavigationSplitView(sidebar: {
            Button("+ New note")
            {
                creatingNote = true
                editingNote = true
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
                    NoteView(note: Binding($selectedNote)!, database: $database, currentNote: $selectedNote, editing: $editingNote)
                        .padding(5)
                }else{
                    Text("^-ω-^")
                        .font(.noteTitle)
                }
            }else{
                NoteCreationView(database: $database, currentNote: $selectedNote, creatingNote: $creatingNote)
            }
        })
    }
}