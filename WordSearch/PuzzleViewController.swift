//
//  PuzzleViewController.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit


//TODO:- transfer the following statements to Puzzle class
var solutionWord = "فوزية"
//

enum WordDirection: Int {
    case vertical = 0
    case horizontal = 1
    case diagonal = 2
    case reversedDiagonal = 3
    
    static func randomWordDirection() -> WordDirection {
        // return random number between 0 - 3 (cases numbers).
        let rand = Int(arc4random_uniform(UInt32(4)))
        return WordDirection(rawValue: rand) ?? .vertical
    }
}

class PuzzleViewController: UIViewController, CharacterGridViewDelegate {

    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var characterGridView: CharacterGridView!
    @IBOutlet weak var targetTextView: UITextView!
    
    fileprivate let highlightColor = UIColor.random()
    //transfer the following statements to Puzzle class
    var solutionWords = ["الله","محمد","الإسلام","ركعتان","سارة","الظهر","العصر","المغرب","العشاء","الفجر","الضحى"]
    var randomCharGrid: RandomCharacterGrid!
    //
    
    var highlightedWord = ""
    var puzzleIndex = 0

    var puzzle: Puzzle? {
        didSet {
//            sourceLabel.text = "أبحث عن الكلمات داخل الشبكة"
//            targetTextView.text = solutionWords.description
//            randomCharGrid.fillGridRandomly()
//            characterGridView.characterGrid = randomCharGrid.characterGrid
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.alpha = 0
        highlightedWord = ""
        
        // Can't link this in IB ¯\_(ツ)_/¯
        characterGridView.delegate = self
        characterGridView.highlightColor = highlightColor
        

        sourceLabel.text = "أبحث عن الكلمات داخل الشبكة"
        targetTextView.text = solutionWords.description
        
        randomCharGrid = RandomCharacterGrid(gridWords:solutionWords)
        randomCharGrid.fillGridRandomly()
        characterGridView.characterGrid = randomCharGrid.characterGrid
    }
    
    // to strike through target label
    func updateTargetLabel() {
        var text = NSMutableAttributedString()
        defer {
            targetTextView.text = solutionWords.description
            targetTextView.attributedText = text
        }
        
        //guard let puzzle = puzzle else { return }
        let strikeThroughAttributes = [
            NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleThick.rawValue,
            NSAttributedStringKey.strikethroughColor: highlightColor
            ] as [NSAttributedStringKey: Any]
//        for wordLocation in puzzle.wordLocations {
//            if text.length > 0 {
//                text.append(NSAttributedString(string: " "))
//            }
//            if matchedWordLocations.contains(wordLocation) {
                text.append(NSAttributedString(string: solutionWords.description, attributes: strikeThroughAttributes))
//            } else {
//                text.append(NSAttributedString(string: wordLocation.word))
//            }
//        }

    }

// rewrite the next two functions to fit Qafelah
    func checkCompleteness() {
    }


    // MARK: - CharacterGridViewDelegate
    func shouldHighlight(_ highlight: Highlight) -> Bool {
        
        //specify the Highlighted Word by knowing the start point(x,y) and end point (x,y) of highlighted line
        var wordDirection: WordDirection = .horizontal
        //x is coooool, y is rooooow
        var startX = highlight.startCoordinate.x
        var startY = highlight.startCoordinate.y
        var endX = highlight.endCoordinate.x
        var endY = highlight.endCoordinate.y
        
        //determine the dirction of word by compare startX, endX, startY, endY
        if(startX == endX){
            if(startY < endY){
                wordDirection = .vertical
            } else if(startY > endY){
                let temp = startY
                startY = endY
                endY = temp
                wordDirection = .vertical
            }
        } else if(startY == endY){
            if(startX < endX){
                wordDirection = .horizontal
            } else if(startX > endX){
                let temp = startX
                startX = endX
                endX = temp
                wordDirection = .horizontal
            }
        } // if both x and y increase or decrease then it is not reversed
        else if ((startX < endX && startY < endY) || (startX > endX && startY > endY)){
            wordDirection = .diagonal
            if (startX > endX && startY > endY) {
                let tempX = startX
                startX = endX
                endX = tempX
                let tempY = startY
                startY = endY
                endY = tempY
            }
        } else if ((startX < endX && startY > endY) || (startX > endX && startY < endY)){
            wordDirection = .reversedDiagonal
        }
        
        //After knowing the direction of word, we can determine the letters of highlighted Word
        if (wordDirection != .vertical && wordDirection != .reversedDiagonal){
            for i in startX...endX {
                highlightedWord += randomCharGrid.characterGrid[startY][i]
                if(wordDirection == .diagonal){
                    startY += 1
                }
            }
        } else if (wordDirection == .vertical){
            for i in startY...endY {
                highlightedWord += randomCharGrid.characterGrid[i][startX]
            }
        } else if (wordDirection == .reversedDiagonal){
            //mean the direction is: reversedDiagonal AND up to down
            if (startY < endY){
                for i in startY...endY {
                    highlightedWord += randomCharGrid.characterGrid[i][startX]
                    startX -= 1
                }
            } //mean the direction is: reversedDiagonal AND bottom to up
            else if (startY > endY) {
                //both are same result
                //                    for i in startX...endX {
                //                        selectedWord += characterGrid![startY][i]
                //                        startY -= 1
                //                    }
                for i in endY...startY {
                    highlightedWord += randomCharGrid.characterGrid[i][endX]
                    endX -= 1
                }
                
            }
        }
        let isMatchingTheSolutionWords = solutionWords.contains(highlightedWord) || solutionWords.contains(String(highlightedWord.reversed()))
        
        //clear highlightedWord to use it agian (reselect another word)
        highlightedWord = ""
        
        return isMatchingTheSolutionWords
    }
    
    func didHighlight(_ highlight: Highlight) {
        updateTargetLabel()
        checkCompleteness()
    }

}

