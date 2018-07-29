//
//  PuzzleViewController.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

var selectedWord = ""
var solutionWords = ["الله","محمد","الإسلام","ركعتان","سارة","الظهر","العصر","المغرب","العشاء","الفجر","الضحى"]
var solutionWord = "فوزية"

enum CaseOfWord: Int {
    case vertical = 0
    case horizontal = 1
    case diagonal = 2
    case reversedDiagonal = 3
    
    static func randomCaseOfWord() -> CaseOfWord {
        // pick and return a new value
        let rand = Int(arc4random_uniform(UInt32(4)))
        return CaseOfWord(rawValue: rand) ?? .vertical
    }
}

class PuzzleViewController: UIViewController, CharacterGridViewDelegate {

    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var characterGridView: CharacterGridView!
    @IBOutlet weak var targetTextView: UITextView!
    
    fileprivate var matchedWordLocations = [WordLocation]()
    fileprivate let highlightColor = UIColor.random()
    var randomCharGrid = RandomCharacterGrid()
    
    var puzzles: [Puzzle]? {
        didSet {
            if let puzzles = puzzles, let puzzle = puzzles.first {
                loadPuzzle(puzzle)
            }
        }
    }

    var puzzleIndex = 0

    var puzzle: Puzzle? {
        didSet {
            sourceLabel.text = "أبحث عن الكلمات داخل الشبكة"
//            characterGridView.characterGrid = [["f", "t", "v", "s", "a", "r", "s", "h"], ["h", "j", "e", "t", "e", "t", "a", "z"], ["x", "e", "o", "i", "e", "l", "r", "h"], ["q", "t", "i", "u", "q", "s", "a", "s"], ["c", "u", "m", "y", "v", "l", "h", "x"], ["n", "l", "m", "m", "o", "t", "e", "k"], ["a", "g", "r", "n", "n", "x", "s", "m"]]
            
//            sourceLabel.text = puzzle?.word
//            characterGridView.characterGrid = puzzle?.characterGrid
            self.updateTargetLabel()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.alpha = 0

        // Can't link this in IB ¯\_(ツ)_/¯
        characterGridView.delegate = self
        characterGridView.highlightColor = highlightColor

        Network.requestPuzzles { puzzles, error in
            if let puzzles = puzzles {
                DispatchQueue.main.async(execute: {
                    self.puzzles = puzzles
                })
            }
        }
//        randomCharGrid.generateVerticalGrid()
//        randomCharGrid.generateHorizontalGrid()
//        randomCharGrid.generateDiameterGrid()
//        randomCharGrid.generateReversedDiagonalGrid()
        randomCharGrid.fillGridRandomly()
        characterGridView.characterGrid = randomCharGrid.characterGrid
        
    }

    func updateTargetLabel() {
        var text = NSMutableAttributedString()
        defer {
//            targetLabel.text = solutionWords.description
//            targetLabel.attributedText = text
//            targetTextView.text = "من ربك ؟\n" + "من نبيك ؟\n" + "ما دينك ؟\n" + "كم عدد ركعات صلاة الفجر؟\n" + "سارة"
            targetTextView.text = solutionWords.description
        
        }
        guard let puzzle = puzzle else { return }
        let strikeThroughAttributes = [
            NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleThick.rawValue,
            NSAttributedStringKey.strikethroughColor: highlightColor
            ] as [NSAttributedStringKey: Any]
        for wordLocation in puzzle.wordLocations {
            if text.length > 0 {
                text.append(NSAttributedString(string: " "))
            }
            if matchedWordLocations.contains(wordLocation) {
                text.append(NSAttributedString(string: wordLocation.word, attributes: strikeThroughAttributes))
            } else {
                text.append(NSAttributedString(string: wordLocation.word))
            }
        }
    }

    func checkCompleteness() {
        guard let puzzle = puzzle else { return }
        if Set(puzzle.wordLocations) == Set(matchedWordLocations) {
            // we're done! on to the next!
            let delayTime = DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                self.transitionToNextPuzzle()
            })
        }
    }

    func transitionToNextPuzzle() {
        let nextPuzzleIndex = (puzzleIndex + 1) % puzzles!.count
        self.unloadPuzzle({ () -> Void in
            self.loadPuzzle(self.puzzles![nextPuzzleIndex])
            self.puzzleIndex = nextPuzzleIndex
        })
    }

    func loadPuzzle(_ puzzle: Puzzle, completionHandler: (() -> Void)? = nil) {
        self.puzzle = puzzle
        UIView.animate(withDuration: 0.35,
            animations: {
                self.view.alpha = 1
            }, completion: { _ in
                self.view.isUserInteractionEnabled = true
                completionHandler?()
        })
    }

    func unloadPuzzle(_ completionHandler: (() -> Void)? = nil) {
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.35,
            animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.puzzle = nil
                self.matchedWordLocations.removeAll()
                completionHandler?()
        })
    }

    // MARK: - CharacterGridViewDelegate
    
    func shouldHighlight(_ highlight: Highlight) -> Bool {
        guard let puzzle = puzzle else { return false }
        // find matching words, regardless of which direction the highlight was dragged in
        let matchingWordLocation = puzzle.wordLocations.find({
            ($0.coordinates.first! == highlight.startCoordinate && $0.coordinates.last! == highlight.endCoordinate) ||
                ($0.coordinates.first! == highlight.endCoordinate && $0.coordinates.last! == highlight.startCoordinate)
        })
        //sarah
        return (solutionWords.contains(selectedWord) || solutionWords.contains(String(selectedWord.reversed())))
        //return matchingWordLocation != nil
    }
    
    func didHighlight(_ highlight: Highlight) {
        guard let puzzle = puzzle else { return }
        // find matching words, regardless of which direction the highlight was dragged in
        if let matchingWordLocation = puzzle.wordLocations.find({
            ($0.coordinates.first! == highlight.startCoordinate && $0.coordinates.last! == highlight.endCoordinate) ||
                ($0.coordinates.first! == highlight.endCoordinate && $0.coordinates.last! == highlight.startCoordinate)
        }) {
            matchedWordLocations.append(matchingWordLocation)
        }
        updateTargetLabel()
        checkCompleteness()
    }

}

