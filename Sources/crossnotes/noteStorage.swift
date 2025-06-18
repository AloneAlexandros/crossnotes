import SwiftCrossUI
import Foundation

class Database : SwiftCrossUI.ObservableObject
{
    @SwiftCrossUI.Published var notes: [Note] = []
    var savesDirectories: [URL] = [] 
    let configDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("crossnotes").appendingPathComponent("config")
    let defaultDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("crossnotes")

    init(){
        fetchValidDirectories()
        //make sure the folders exist
        for directory in savesDirectories{
            if !FileManager.default.fileExists(atPath: directory.path) {
                do {
                    try FileManager.default.createDirectory(atPath: directory.path, withIntermediateDirectories: true, attributes: nil)
                    print("this is canon now there is a save folder")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        loadNotes()
    }

    func createNote(title: String, folder: URL)
    {
        //create file for the note
        let filePath = folder.appendingPathComponent(title).appendingPathExtension("txt")
        do {
            try "".write(to: filePath, atomically: true, encoding: .utf8)
        } catch {
            assertionFailure("Failed writing to URL: \(filePath), Error: " + error.localizedDescription)
        }
        //add note in the notes array for the app to see
        notes.append(Note(title: title, content: "", date: fileModificationDate(url: filePath)!, noteURL: filePath))
    }

    func saveNote(note: Note)
    {
        do {
            try note.content.write(to: note.noteURL, atomically: true, encoding: .utf8)
        } catch {
            assertionFailure("Failed writing to URL: \(note.noteURL), Error: " + error.localizedDescription)
        }
    }

    func loadNotes()
    {
        for directory in savesDirectories{
            do {
                let items = try FileManager.default.contentsOfDirectory(atPath: directory.path).filter{ $0.hasSuffix(".txt")}

                for item in items {
                    let name = String(item.prefix(upTo: item.lastIndex { $0 == "." } ?? item.endIndex))
                    print(directory)
                    let filePath = directory.appendingPathComponent(item)
                    var contents: String = ""
                    do {
                        contents = try String(contentsOf: filePath, encoding: .utf8)
                    }
                    catch {
                        print("couldn't find file contents???")
                    }
                    notes.append(Note(title: name, content: contents, date: fileModificationDate(url: filePath)!, noteURL: filePath))
                }
            } catch {
                print("missing permission to write this folder")
            }
        }
        notes = notes.sorted{$0.date > $1.date}
        //for testing the date sorting!
        for note in notes {
            print(note.title)
        }
    }

    func fileModificationDate(url: URL) -> Date? {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            return attr[FileAttributeKey.modificationDate] as? Date
        } catch {
            return nil
        }
    }

    func fetchValidDirectories()
    {
        let configFileURL = configDirectory.appendingPathComponent("config").appendingPathExtension("txt")
        //check if config direcory exists and if not create it
        if !FileManager.default.fileExists(atPath: configDirectory.path) {
            do {
                try FileManager.default.createDirectory(atPath: configDirectory.path, withIntermediateDirectories: true, attributes: nil)
                print("this is canon now there is a save folder")

                //make config.txt
                do {
                    //FIXME: use addDirectory instead. Using this as an example value
                    try defaultDirectory.path.write(to: configFileURL, atomically: true, encoding: .utf8)
                } catch {
                    assertionFailure("Failed writing to URL: \(configFileURL), Error: " + error.localizedDescription)
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        //fetch note directories
        var configString = ""
        do{
           configString = try String(contentsOf: configFileURL, encoding: .utf8)  
        } catch {
            print(error.localizedDescription)
        }
        let splitConfigString = configString.split(whereSeparator: \.isNewline)
        for directory in splitConfigString{
            let directoryURL = URL(string: "file://" + directory)!
            savesDirectories.append(directoryURL)
        }
        
    }


    //TODO: make this actually work or smth
    func addDirectory()
    {

    }
}