import SwiftCrossUI
import DefaultBackend
import Foundation

struct MarkdownText: View{
    @State var text: String
    @State var fontToUse = Font.system(size: 16, design: .default)
    var body: some View{
        let lines = text.split(whereSeparator: \.isNewline)
        ForEach(lines){ line in
            InLineMarkdowns(text: textWithoutPrefix(text: String(line)))
                .font(chooseFont(text: String(line)))
        }
    }

    func chooseFont(text: String) -> Font
    {
        if(text.hasPrefix("# "))
        {
            return Font.system(size: 34)
        } else if (text.hasPrefix("## ")){
            return Font.system(size: 31)
        }else if (text.hasPrefix("### ")){
            return Font.system(size: 28)
        }else if (text.hasPrefix("#### ")){
            return Font.system(size: 25)
        }else if (text.hasPrefix("##### ")){
            return Font.system(size: 22)
        }
        else if (text.hasPrefix("###### ")){
            return Font.system(size: 19)
        }else{
            return Font.system(size: 16)
        }
    }

    func textWithoutPrefix(text: String) -> String{
        var editableText = text
        if(text.hasPrefix("# "))
        {
            return String(text.dropFirst(2))
        } else if (text.hasPrefix("## ")){
            return String(text.dropFirst(3))
        }else if (text.hasPrefix("### ")){
            return String(text.dropFirst(4))
        }else if (text.hasPrefix("#### ")){
            return String(text.dropFirst(5))
        }else if (text.hasPrefix("##### ")){
            return String(text.dropFirst(6))
        }
        else if (text.hasPrefix("###### ")){
            return String(text.dropFirst(7))
        }else if(text.hasPrefix("- ") || text.hasPrefix("* ")||text.hasPrefix("+ ")){
            editableText.remove(at: editableText.startIndex)
            editableText.remove(at: editableText.startIndex)
            editableText = "・ " + editableText
            return editableText
        }else{
            return String(text)
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

//it appears that if you put two consecutive bolds like **text** **text** none get bold. I don't know how to fix it, and it seems specific enough not to worry about
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
                    Text(string)
                        .emphasized()
                        .padding(.leading, -5)
                        //FIXME: find italics
                }else{
                    
                    Text(stringToShow(string: string))
                    .padding(.leading, -5)
                }
            }
        }
    }

    func stringToShow(string:String) -> String
    {
        var stringToShow = string
        if(string.first == " "){
            stringToShow.remove(at: stringToShow.startIndex)
        }
        if(string.last == " ")
        {
            stringToShow = String(stringToShow.dropLast())
        }
        return stringToShow
    }
}

//unfortunately crossui doesn't seem to support italics