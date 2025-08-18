import SwiftCrossUI
import DefaultBackend
import Foundation

struct MarkdownText: View{
    @State var text: String
    @State var fontToUse = Font.system(size: 16, design: .default)
    var body: some View{
        let lines = text.split(whereSeparator: \.isNewline)
        ForEach(lines){ line in
            InLineMarkdowns(text: String(line).textWithoutPrefix())
                .font(String(line).chooseFont())
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    
}

struct InLineMarkdowns: View{
    //this is purely to avoid confusing when calling it
    //the view will first check for bold&italics (***) then for bold(**) then italics (*) etc and it will do it's changes gradually
    @State var text: String
    var body: some View{
        Bold(text: text)
    }
}


//it appears that if you put two consecutive bolds like **text** **text** none get bold. I don't know how to fix it, and it is not expected for someone to do that anyway
struct Bold: View{
    @State var text: String
    @State var i = 1
    var body: some View{
        let splitted = text.components(separatedBy: "**")
        let betterSplitted = splitted.filter{ $0 != ""}
        HStack{
            ForEach(Array(betterSplitted.enumerated())){i,string in
                if(((betterSplitted.count-i)%2==0 || betterSplitted.count == 1) && splitted.count != 1)
                {
                    Italic(text: string)
                        .emphasized()
                }else{
                    
                    Italic(text: string.stringToShow())
                    
                }
            }
        }
    }
}
//i assume putting two italics in a row, like *text* *text* makes none of them italic, however this is no porblem since it's not expected for a user to do that anyway
struct Italic: View{
    @State var text: String
    @State var i = 1
    var body: some View{
        let splitted = text.components(separatedBy: "*")
        let betterSplitted = splitted.filter{ $0 != ""}
        HStack{
            ForEach(Array(betterSplitted.enumerated())){i,string in
                if(((betterSplitted.count-i)%2==0 || betterSplitted.count == 1) && splitted.count != 1)
                {
                    Text(string)
                        .italic()
                        .padding(.leading, -5)
                }else{
                    
                    Text(string.stringToShow())
                    .padding(.leading, -5)
                }
            }
        }
    }
}