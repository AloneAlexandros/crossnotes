import SwiftCrossUI
import Foundation

class Database : SwiftCrossUI.ObservableObject
{
    @SwiftCrossUI.Published var notes: [Note] = []
    let savesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var dataPath: URL? = nil

    init(){
        dataPath = savesDirectory.appendingPathComponent("crossnotes")
        if !FileManager.default.fileExists(atPath: dataPath!.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath!.path, withIntermediateDirectories: true, attributes: nil)
                print("this is canon now there is a save folder")
            } catch {
                print(error.localizedDescription)
            }
        }
        loadNotes()
    }

    func saveNote()
    {
        
    }

    func loadNotes()
    {
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: dataPath!.path).filter{ $0.hasSuffix(".txt")}

            for item in items {
                let name = String(item.prefix(upTo: item.lastIndex { $0 == "." } ?? item.endIndex))
                let filePath = dataPath!.appendingPathComponent(item)
                var contents: String = ""
                do {
                    contents = try String(contentsOf: filePath, encoding: .utf8)
                }
                catch {
                    print("that aint right")
                }
                notes.append(Note(title: name, content: contents, date: fileModificationDate(url: filePath)!))
            }
            notes = notes.sorted{$0.date > $1.date}
            for note in notes {
                print(note.title)
            }
        } catch {
            print("missing permission to write this folder")
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
}