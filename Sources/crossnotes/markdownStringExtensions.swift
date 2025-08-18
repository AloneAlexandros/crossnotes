import SwiftCrossUI

extension String{
    func textWithoutPrefix() -> String{
        var editableText = self
        switch true{
            case self.hasPrefix("# "):
                return String(self.dropFirst(2))
            case self.hasPrefix("## "):
                return String(self.dropFirst(3))
            case self.hasPrefix("### "):
                return String(self.dropFirst(4))
            case self.hasPrefix("#### "):
                return String(self.dropFirst(5))
            case self.hasPrefix("##### "):
                return String(self.dropFirst(6))
            case self.hasPrefix("###### "):
                return String(self.dropFirst(7))
            case self.hasPrefix("-# "):
                return String(self.dropFirst(3))
            case self.hasPrefix("- ") || self.hasPrefix("* ")||self.hasPrefix("+ "):
                editableText.remove(at: editableText.startIndex)
                editableText.remove(at: editableText.startIndex)
                editableText = "・ " + editableText
                return editableText
            default:
               return String(self)
        }
    }
    func stringToShow() -> String
    {
        var stringToShow = self
        if(self.first == " "){
            stringToShow.remove(at: stringToShow.startIndex)
        }
        if(self.last == " ")
        {
            stringToShow = String(stringToShow.dropLast())
        }
        return stringToShow
    }
    func chooseFont() -> Font
    {
        switch true{
            case self.hasPrefix("# "):
                return Font.system(size: 34)
            case self.hasPrefix("## "):
                return Font.system(size: 31)
            case self.hasPrefix("### "):
                return Font.system(size: 28)
            case self.hasPrefix("#### "):
                return Font.system(size: 25)
            case self.hasPrefix("##### "):
                return Font.system(size: 22)
            case self.hasPrefix("###### "):
                return Font.system(size: 19)
            case self.hasPrefix("-# "):
                return Font.system(size: 10)
            default:
               return Font.system(size: 16) 
        }
    }
}