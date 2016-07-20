syn match EmailNoSpell '<\?\w\+@\w\+\.\w\+>\?' contains=@NoSpell
syn match GitRefNoSpell '[a-fA-F0-9]\{7,40\}' contains=@NoSpell
syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell
