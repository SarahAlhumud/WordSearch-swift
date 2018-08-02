//
//  UpdatingCharacterGrid.swift
//  WordSearch
//
//  Created by SARA ALHUMUD on 11/14/1439 AH.
//  Copyright © 1439 Matthew Crenshaw. All rights reserved.
//

import Foundation

enum CaseOfWordLocation {
    case empty
    case fillWithEqualChar
    case fillWithUnequalChar
}

class RandomCharacterGrid {
    var characterGrid = [[String]]()
    
    var englishLetters = ["a", "b", "c", "d", "e","f", "g", "h", "i", "j","k", "l", "m", "n", "o","p", "q", "r", "s", "t","u", "v", "w", "x", "y"]
    var arabicLetters = ["ء","ا","أ","ب","ت","ث","ج","ح","خ","د","ذ","ر","ز","س","ش","ص","ض","ط","ظ","ع","غ","ف","ق","ك","ل","م","ن","ه","و","ي","ة"]
    var gridSize = 0
    
    init() {
        gridSize = gridSizeFunc()
        for i in 0..<gridSize {
            characterGrid.append([""])
            for _ in 0..<gridSize-1 {
                characterGrid[i].append("")
            }
        }
    }
    
    func gridSizeFunc() -> Int {
        //make grid's size lager than word's size
        var size = 0
        var largestWordSize = 0
        
        for word in solutionWords {
            if (largestWordSize < word.count){
                largestWordSize = word.count
            }
        }
        
        if(largestWordSize <= 8){
            size = largestWordSize + 3
        } else if(largestWordSize == 9 || largestWordSize == 10){
            size = largestWordSize + 1
        } else if(largestWordSize == 11 || largestWordSize == 12){
            size = largestWordSize
        } else {
            size = 0
        }
        return size
    }
    
    func fillGridRandomly(){
        
        for (i,word) in solutionWords.enumerated() {
            generateGridRandomly(i,word)
        }
    }
    
    func generateGridRandomly(_ index:Int,_ word: String){
        var caseOfWordLocation: CaseOfWordLocation = .empty
        var randRow = 0
        var randCol = 0
        
        //choose random direction
        let randDirection: WordDirection = WordDirection.randomWordDirection()
        
        //choose random location
        switch randDirection {
        case .vertical:
            //row must be less than gridSize - solutionWord.count, col is less than gridSize
            randRow = Int(arc4random_uniform(UInt32(gridSize - word.count+1)))
            randCol = Int(arc4random_uniform(UInt32(gridSize)))
            
        case .horizontal:
            //row must be less than gridSize, col is less than gridSize - solutionWord.count
            randRow = Int(arc4random_uniform(UInt32(gridSize)))
            randCol = Int(arc4random_uniform(UInt32(gridSize - word.count+1)))
            randCol = gridSize - (randCol + 1)
            
        case .diagonal:
            //row must be less than gridSize - - solutionWord.count, col is less than gridSize - solutionWord.count
            randRow = Int(arc4random_uniform(UInt32(gridSize - word.count+1)))
            randCol = Int(arc4random_uniform(UInt32(gridSize - word.count+1)))
            
        case .reversedDiagonal:
            //row must be less than gridSize - - solutionWord.count, col is less than gridSize - solutionWord.count
            randRow = Int(arc4random_uniform(UInt32(gridSize - word.count+1)))
            randCol = Int(arc4random_uniform(UInt32(gridSize - word.count+1)))
            randCol = gridSize - (randCol + 1) //to reverse Diagonal, assign largre number to the col
        }
        var row = randRow
        var col = randCol
        
        for i in 0..<word.count {
            //check if location of word is empty
            if (characterGrid[row][col] != "" && characterGrid[row][col] != String(word.charAt(at: i))){
                caseOfWordLocation = .fillWithUnequalChar
                break
            } else if (characterGrid[row][col] == String(word.charAt(at: i))) {
                caseOfWordLocation = .fillWithEqualChar
            }
            
            switch randDirection {
            case .vertical:
                row += 1
            case .horizontal:
                col -= 1
            case .diagonal:
                row += 1
                col += 1
            case .reversedDiagonal:
                row += 1
                col -= 1
            }
        }

        switch caseOfWordLocation {
            
        case .empty:
                fillGrid(word,randRow,randCol,randDirection,index)
        case .fillWithEqualChar:
                fillGrid(word,randRow,randCol,randDirection,index)
        case .fillWithUnequalChar:
            //fillGrid(word,randRow,randCol,randDirection,index)
            print("change grid")
            generateGridRandomly(index,word)
        }
        
    }
    
    func fillGrid(_ word: String,_ randRow: Int,_ randCol: Int,_ location: WordDirection,_ index: Int){
        var row = randRow
        var col = randCol
        var randomLetter = 0

        for i in 0..<word.count {
            characterGrid[row][col] = String(word.charAt(at: i))
            switch location {
            case .vertical:
                row += 1
            case .horizontal:
                col -= 1
            case .diagonal:
                row += 1
                col += 1
            case .reversedDiagonal:
                row += 1
                col -= 1
            }
        }
        if (index == (solutionWords.count-1)){
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                randomLetter = Int(arc4random_uniform(UInt32(arabicLetters.count)))
               if (characterGrid[row][col] == ""){
                    characterGrid[row][col] = arabicLetters[randomLetter]
               }
            }
        }
        }
    }
    
    
    func generateVerticalGrid(){
        
        //row must be less than gridSize - solutionWord.count, col is less than gridSize
        var randRow = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        let randCol = Int(arc4random_uniform(UInt32(gridSize)))
        var randomLetter = 0
        
        //fill grid with solution word
        //becuse it is vertical, the col will be fixed
        for i in 0..<solutionWord.count {
            characterGrid[randRow][randCol] = String(solutionWord.charAt(at: i))
            randRow += 1
        }
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                randomLetter = Int(arc4random_uniform(UInt32(arabicLetters.count)))
                if (characterGrid[row][col] == ""){
                    characterGrid[row][col] = arabicLetters[randomLetter]
                }
            }
        }
    }
    
    func generateHorizontalGrid(){
        
        //row must be less than gridSize, col is less than gridSize - solutionWord.count
        let randRow = Int(arc4random_uniform(UInt32(gridSize)))
        var randCol = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        randCol = gridSize - (randCol + 1)
        var randomLetter = 0
        
        //fill grid with solution word
        //becuse it is Horizontal, the row will be fixed
        for i in 0..<solutionWord.count {
            characterGrid[randRow][randCol] = String(solutionWord.charAt(at: i))
            randCol -= 1
        }
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                randomLetter = Int(arc4random_uniform(UInt32(arabicLetters.count)))
                if (characterGrid[row][col] == ""){
                    characterGrid[row][col] = arabicLetters[randomLetter]
                }
            }
        }
        
        
    }
    
    func generateDiagonalGrid(){
        
        //row must be less than gridSize - - solutionWord.count, col is less than gridSize - solutionWord.count
        var randRow = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        var randCol = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        var randomLetter = 0
        
        //fill grid with solution word
        //becuse it is Diagonal, the row & col unfixed
        for i in 0..<solutionWord.count {
            characterGrid[randRow][randCol] = String(solutionWord.charAt(at: i))
            randRow += 1
            randCol += 1
        }
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                randomLetter = Int(arc4random_uniform(UInt32(arabicLetters.count)))
                if (characterGrid[row][col] == ""){
                    characterGrid[row][col] = arabicLetters[randomLetter]
                }
            }
        }
    }
    
    func generateReversedDiagonalGrid(){
        
        //row must be less than gridSize - - solutionWord.count, col is less than gridSize - solutionWord.count
        var randRow = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        var randCol = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        randCol = gridSize - (randCol + 1) //to reverse Diagonal, assign largre number to the col
        var randomLetter = 0
        
        //fill grid with solution word
        //becuse it is Diagonal, the row & col unfixed
        for i in 0..<solutionWord.count {
            characterGrid[randRow][randCol] = String(solutionWord.charAt(at: i))
            randRow += 1
            randCol -= 1
        }
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                randomLetter = Int(arc4random_uniform(UInt32(arabicLetters.count)))
                if (characterGrid[row][col] == ""){
                    characterGrid[row][col] = arabicLetters[randomLetter]
                }
            }
        }
    }
    
}

extension String {
    // charAt(at:) returns a character at an integer (zero-based) position.
    // example:
    // let str = "hello"
    // var second = str.charAt(at: 1)
    //  -> "e"
    func charAt(at: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: at)
        return self[charIndex]
    }
}
