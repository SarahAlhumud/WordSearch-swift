//
//  PuzzleViewController.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

var highlightedWord = ""

//TODO:- transfer the following statements to Puzzle class
var solutionWords = ["الله","محمد","الإسلام","ركعتان","سارة","الظهر","العصر","المغرب","العشاء","الفجر","الضحى"]
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
    
    fileprivate var matchedWordLocations = [WordLocation]()
    fileprivate let highlightColor = UIColor.random()
    //transfer the following statement to Puzzle class
    var randomCharGrid = RandomCharacterGrid()
    //
    
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
            targetTextView.text = solutionWords.description
            randomCharGrid.fillGridRandomly()
            characterGridView.characterGrid = randomCharGrid.characterGrid
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.alpha = 0

        // Can't link this in IB ¯\_(ツ)_/¯
        characterGridView.delegate = self
        characterGridView.highlightColor = highlightColor

        //rewrite network class
        Network.requestPuzzles { puzzles, error in
            if let puzzles = puzzles {
                DispatchQueue.main.async(execute: {
                    self.puzzles = puzzles
                })
            }
        }
    }

// rewrite the next two functions to fit Qafelah
    func checkCompleteness() {
        guard let puzzle = puzzle else { return }
        if Set(puzzle.wordLocations) == Set(matchedWordLocations) {
            // we're done! on to the next!
//            let delayTime = DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
//            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
//                self.transitionToNextPuzzle()
//            })
        }
    }

//    func transitionToNextPuzzle() {
//        let nextPuzzleIndex = (puzzleIndex + 1) % puzzles!.count
//        self.unloadPuzzle({ () -> Void in
//            self.loadPuzzle(self.puzzles![nextPuzzleIndex])
//            self.puzzleIndex = nextPuzzleIndex
//        })
//    }

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
//        guard let puzzle = puzzle else { return false }
//        // find matching words, regardless of which direction the highlight was dragged in
//        let matchingWordLocation = puzzle.wordLocations.find({
//            ($0.coordinates.first! == highlight.startCoordinate && $0.coordinates.last! == highlight.endCoordinate) ||
//                ($0.coordinates.first! == highlight.endCoordinate && $0.coordinates.last! == highlight.startCoordinate)
//        })
        
        //
        return (solutionWords.contains(highlightedWord) || solutionWords.contains(String(highlightedWord.reversed())))
        //return matchingWordLocation != nil
    }
    
    func didHighlight(_ highlight: Highlight) {
//        guard let puzzle = puzzle else { return }
//        // find matching words, regardless of which direction the highlight was dragged in
//        if let matchingWordLocation = puzzle.wordLocations.find({
//            ($0.coordinates.first! == highlight.startCoordinate && $0.coordinates.last! == highlight.endCoordinate) ||
//                ($0.coordinates.first! == highlight.endCoordinate && $0.coordinates.last! == highlight.startCoordinate)
//        }) {
//            matchedWordLocations.append(matchingWordLocation)
//        }
//        updateTargetLabel()
//        checkCompleteness()
    }

}

