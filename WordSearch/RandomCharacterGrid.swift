//
//  UpdatingCharacterGrid.swift
//  WordSearch
//
//  Created by SARA ALHUMUD on 11/14/1439 AH.
//  Copyright © 1439 Matthew Crenshaw. All rights reserved.
//

import Foundation

struct RandomCharacterGrid {
    var characterGrid = [[String]]()
    
    var englishLetters = ["a", "b", "c", "d", "e","f", "g", "h", "i", "j","k", "l", "m", "n", "o","p", "q", "r", "s", "t","u", "v", "w", "x", "y"]
    var gridSize = 0
    var largestWordSize = 0
    
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
        let wordSize = solutionWord.count
        
        if(wordSize <= 8){
            size = wordSize + 3
        } else if(wordSize == 9 || wordSize == 10){
            size = wordSize + 1
        } else if(wordSize == 11 || wordSize == 12){
            size = wordSize
        } else {
            size = 0
        }
        return size
    }
    
    mutating func generateVerticalGrid(){
        
        //row must be less than gridSize - solutionWord.count, col is less than gridSize
        var ranRow = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        let ranCol = Int(arc4random_uniform(UInt32(gridSize)))
        var randomLetter = 0
        
        //fill grid with solution word
        //becuse it is vertical, the col will be fixed
        for i in 0..<solutionWord.count {
            characterGrid[ranRow][ranCol] = String(solutionWord.charAt(at: i))
            ranRow += 1
        }
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                randomLetter = Int(arc4random_uniform(UInt32(englishLetters.count)))
                if (characterGrid[row][col] == ""){
                characterGrid[row][col] = englishLetters[randomLetter]
                }
            }
        }
    }
    mutating func generateHorizontalGrid(){
        
        //row must be less than gridSize, col is less than gridSize - solutionWord.count
        let ranRow = Int(arc4random_uniform(UInt32(gridSize)))
        var ranCol = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        var randomLetter = 0
        
        //fill grid with solution word
        //becuse it is Horizontal, the row will be fixed
        for i in 0..<solutionWord.count {
            characterGrid[ranRow][ranCol] = String(solutionWord.charAt(at: i))
            ranCol += 1
        }
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                randomLetter = Int(arc4random_uniform(UInt32(englishLetters.count)))
                if (characterGrid[row][col] == ""){
                    characterGrid[row][col] = englishLetters[randomLetter]
                }
            }
        }
        
        
    }
    
    mutating func generateDiameterGrid(){
        
        //row must be less than gridSize - - solutionWord.count, col is less than gridSize - solutionWord.count
        var ranRow = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        var ranCol = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        var randomLetter = 0
        
        //fill grid with solution word
        //becuse it is Diameter, the row & col unfixed
        for i in 0..<solutionWord.count {
            characterGrid[ranRow][ranCol] = String(solutionWord.charAt(at: i))
            ranRow += 1
            ranCol += 1
        }
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                randomLetter = Int(arc4random_uniform(UInt32(englishLetters.count)))
                if (characterGrid[row][col] == ""){
                    characterGrid[row][col] = englishLetters[randomLetter]
                }
            }
        }
    }
    
    mutating func generateReversedDiameterGrid(){
        
        //row must be less than gridSize - - solutionWord.count, col is less than gridSize - solutionWord.count
        var ranRow = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        var ranCol = Int(arc4random_uniform(UInt32(gridSize - solutionWord.count+1)))
        ranCol = gridSize - (ranCol + 1) //to reverse Diameter, assign largre number to the col
        var randomLetter = 0
        
        //fill grid with solution word
        //becuse it is Diameter, the row & col unfixed
        for i in 0..<solutionWord.count {
            characterGrid[ranRow][ranCol] = String(solutionWord.charAt(at: i))
            ranRow += 1
            ranCol -= 1
        }
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                randomLetter = Int(arc4random_uniform(UInt32(englishLetters.count)))
                if (characterGrid[row][col] == ""){
                    characterGrid[row][col] = englishLetters[randomLetter]
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
