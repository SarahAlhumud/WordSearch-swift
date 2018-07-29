//
//  CharacterGridView.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/8/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

/**
 Displays a word search letter grid.
 
 I would normally use an AutoLayout wrapper (such as PureLayout) to tidy up constraints, but I didn't want
 to use 3rd party librarys in this example.
 */
@IBDesignable
class CharacterGridView: UIView {
    
    // One day, maybe we can set fonts via IBInspectable
    @IBInspectable var font: UIFont? {
        didSet {
            updateGrid()
        }
    }
    
    var delegate: CharacterGridViewDelegate?
    
    /// The puzzle that the view displays.
    var characterGrid: [[String]]? {
        didSet {
            highlights.removeAll()
            //sarah
            selectedWord = ""
            selectedPoints.removeAll()
            draggingHighlight = nil
            updateGrid()
            setNeedsDisplay()
        }
    }
    
    var highlightColor = UIColor.random()
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    fileprivate func initialize() {
        isOpaque = false
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CharacterGridView.recognizePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        addGestureRecognizer(panGestureRecognizer)
    }
    
    override func prepareForInterfaceBuilder() {
        characterGrid = [
            ["a", "b", "c", "d", "e"],
            ["f", "g", "h", "i", "j"],
            ["k", "l", "m", "n", "o"],
            ["p", "q", "r", "s", "t"],
            ["u", "v", "w", "x", "y"]]
    }
    
    // MARK: - Touch handling
    
    /// The array of highlights currently displayed
    fileprivate var highlights = [Highlight]()
    fileprivate var draggingHighlight: Highlight?
    
    /// The two-dimensional array of labels representing the puzzle's character grid.
    fileprivate var startPoint: CGPoint?
    fileprivate var selectedPoints: [CGPoint] = [CGPoint]()
    
    // NOTE: Overriding touchesBegan was necessary to find where the pan gesture actually began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            startPoint = touch.location(in: self)
        }
    }
    
    
    @objc fileprivate func recognizePanGesture(_ recognizer: UIPanGestureRecognizer) {
        var highlight: Highlight?
        defer {
            if recognizer.state == .changed {
                if let highlight = highlight {
                    draggingHighlight = highlight
                }
            } else if recognizer.state == .ended || recognizer.state == .cancelled {
                if let highlight = highlight ?? draggingHighlight, let delegate = delegate {
                    if delegate.shouldHighlight(highlight) {
                        highlights.append(highlight)
                        delegate.didHighlight(highlight)
                    }
                }
                draggingHighlight = nil
                //sarah
                selectedWord = ""
                selectedPoints.removeAll()
            }
            setNeedsDisplay()
        }
        guard recognizer.state == .changed || recognizer.state == .ended else { return }
        guard let startPoint = startPoint else { return }
        let endPoint = recognizer.location(in: self)
        guard let startLabel = hitTest(startPoint, with: nil) as? CharacterLabel else { return }
        guard let endLabel = hitTest(endPoint, with: nil) as? CharacterLabel else { return }
        guard startLabel.coordinate.isCardinalToCoordinate(endLabel.coordinate) else { return }
        highlight = Highlight(
            startCoordinate: startLabel.coordinate,
            endCoordinate: endLabel.coordinate,
            startPoint: startLabel.center,
            endPoint: endLabel.center)
        
        //sarah
        if (recognizer.state == .ended){
            //TODO: Arrage this pices of code
            var caseOfSelectedWord: CaseOfWord = .horizontal
            //x is coooool, y is rooooow
            var startX = startLabel.coordinate.x
            var startY = startLabel.coordinate.y
            var endX = endLabel.coordinate.x
            var endY = endLabel.coordinate.y
            
            if(startX == endX){
                if(startY < endY){
                   caseOfSelectedWord = .vertical
                } else if(startY > endY){
                    let temp = startY
                    startY = endY
                    endY = temp
                    caseOfSelectedWord = .vertical
                }
            } else if(startY == endY){
                if(startX < endX){
                    caseOfSelectedWord = .horizontal
                } else if(startX > endX){
                    let temp = startX
                    startX = endX
                    endX = temp
                    caseOfSelectedWord = .horizontal
                }
            } // if both x and y increase or decrease then it is not reversed
            else if ((startX < endX && startY < endY) || (startX > endX && startY > endY)){
                caseOfSelectedWord = .diagonal
                if (startX > endX && startY > endY) {
                    let tempX = startX
                    startX = endX
                    endX = tempX
                    let tempY = startY
                    startY = endY
                    endY = tempY
                }
            } else if ((startX < endX && startY > endY) || (startX > endX && startY < endY)){
                caseOfSelectedWord = .reversedDiagonal
//                if(startX > endX){
//                    let temp = startX
//                    startX = endX
//                    endX = temp
//                }
//                if(startY > endY){
//                    let temp = startY
//                    startY = endY
//                    endY = temp
//                }
            }
            
            if (caseOfSelectedWord != .vertical && caseOfSelectedWord != .reversedDiagonal){
                for i in startX...endX {
                    selectedWord += characterGrid![startY][i]
                    if(caseOfSelectedWord == .diagonal){
                        startY += 1
                    }
                }
            } else if (caseOfSelectedWord == .vertical){
                for i in startY...endY {
                    selectedWord += characterGrid![i][startX]
                }
            } else if (caseOfSelectedWord == .reversedDiagonal){
                if (startY < endY){
                for i in startY...endY {
                    selectedWord += characterGrid![i][startX]
                    startX -= 1
//                    if(startX > endX){
//                        startX -= 1
//                    } else if(startX < endX){
//                        startX += 1
//                    }
                }
                } else if (startY > endY) {
                    //both are same result
//                    for i in startX...endX {
//                        selectedWord += characterGrid![startY][i]
//                        startY -= 1
//                    }
                    for i in endY...startY {
                        selectedWord += characterGrid![i][endX]
                        endX -= 1
                    }

                }
            }

            
            print(caseOfSelectedWord)
            print("startLabel \(startLabel.text ?? "") endLabel \(endLabel.text ?? "")")
            print("selected word: \(selectedWord)")
            print("startPoint x: \(startLabel.coordinate.x) startPoint y: \(startLabel.coordinate.y)")
            print("endPoint x: \(endLabel.coordinate.x) endPoint y: \(endLabel.coordinate.y)")
            

        }
        //
    }
    
    fileprivate func coordinateOfLabelAtPoint(_ point: CGPoint) -> Coordinate? {
        guard let label = hitTest(point, with: nil) as? CharacterLabel else {
            return nil
        }
        return label.coordinate
    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        highlightColor.setStroke()
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineWidth = 30
        for highlight in highlights {
            path.move(to: highlight.startPoint)
            path.addLine(to: highlight.endPoint)
        }
        if let highlight = draggingHighlight {
            path.move(to: highlight.startPoint)
            path.addLine(to: highlight.endPoint)
        }
        path.stroke()
    }
    
    // MARK: - Subviews and layout
    
    /// The two-dimensional array of labels representing the puzzle's character grid.
    fileprivate var labelGrid = [[CharacterLabel]]()
    
    /// Clears and recreates grid labels. Calls `applyConstraints()` if `puzzle` is not nil.
    fileprivate func updateGrid() {
        labelGrid.forEach({ row in
            row.forEach({ label in
                label.removeFromSuperview()
            })
        })
        labelGrid.removeAll()
        
        guard let characterGrid = characterGrid else {
            return
        }
        
        for (y, characterRow) in characterGrid.enumerated() {
            var labelRow = [CharacterLabel]()
            for (x, character) in characterRow.enumerated() {
                let coordinate = Coordinate(x, y)
                let label = CharacterLabel(character: character, coordinate: coordinate)
                if let font = font {
                    label.font = font
                }
                label.isUserInteractionEnabled = true
                labelRow.append(label)
            }
            labelGrid.append(labelRow)
        }
        
        applyConstraints()
    }
    
    /// Applies constraints to layout grid
    fileprivate func applyConstraints() {
        for (i, row) in labelGrid.enumerated() {
            for (j, label) in row.enumerated() {
                addSubview(label)
                if j > 0 {
                    let leftLabel = row[j-1]
                    applyLeftRightConstraintsForLabels(leftLabel, rightLabel: label)
                }
                if i > 0 {
                    let topLabel = labelGrid[i-1][j]
                    applyTopBottomConstraintsForLabels(topLabel, bottomLabel: label)
                }
            }
        }
        
        if let firstRow = labelGrid.first, let firstLabel = firstRow.first {
            applyTopLeftCornerConstraintsForLabel(firstLabel)
        }
        
        if let lastRow = labelGrid.last, let lastLabel = lastRow.last {
            applyBottomRightCornerConstraintsForLabel(lastLabel)
        }
    }
    
    // MARK: - Constraints
    
    /// Applies top left corner constraints
    fileprivate func applyTopLeftCornerConstraintsForLabel(_ label: UILabel) {
        addConstraint(NSLayoutConstraint(
            item: label,
            attribute: .left,
            relatedBy: .equal,
            toItem: self,
            attribute: .left,
            multiplier: 1,
            constant: 0))
        
        addConstraint(NSLayoutConstraint(
            item: label,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0))
    }
    
    /// Applies bottom right corner constraints
    fileprivate func applyBottomRightCornerConstraintsForLabel(_ label: UILabel) {
        addConstraint(NSLayoutConstraint(
            item: label,
            attribute: .right,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1,
            constant: 0))
        
        addConstraint(NSLayoutConstraint(
            item: label,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: 0))
    }
    
    /// Applies left-right constraints between labels
    fileprivate func applyLeftRightConstraintsForLabels(_ leftLabel: UILabel, rightLabel: UILabel) {
        addConstraint(NSLayoutConstraint(
            item: rightLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: leftLabel,
            attribute: .width,
            multiplier: 1,
            constant: 0))
        
        addConstraint(NSLayoutConstraint(
            item: rightLabel,
            attribute: .height,
            relatedBy: .equal,
            toItem: leftLabel,
            attribute: .height,
            multiplier: 1,
            constant: 0))
        
        addConstraint(NSLayoutConstraint(
            item: rightLabel,
            attribute: .left,
            relatedBy: .equal,
            toItem: leftLabel,
            attribute: .right,
            multiplier: 1,
            constant: 5))
        
        addConstraint(NSLayoutConstraint(
            item: rightLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: leftLabel,
            attribute: .top,
            multiplier: 1,
            constant: 0))
        
        addConstraint(NSLayoutConstraint(
            item: rightLabel,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: leftLabel,
            attribute: .bottom,
            multiplier: 1,
            constant: 0))
    }
    
    /// Applies top-bottom constraints between labels
    fileprivate func applyTopBottomConstraintsForLabels(_ topLabel: UILabel, bottomLabel: UILabel) {
        addConstraint(NSLayoutConstraint(
            item: bottomLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: topLabel,
            attribute: .width,
            multiplier: 1,
            constant: 0))
        
        addConstraint(NSLayoutConstraint(
            item: bottomLabel,
            attribute: .height,
            relatedBy: .equal,
            toItem: topLabel,
            attribute: .height,
            multiplier: 1,
            constant: 0))
        
        addConstraint(NSLayoutConstraint(
            item: bottomLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: topLabel,
            attribute: .bottom,
            multiplier: 1,
            constant: 5))
        
        addConstraint(NSLayoutConstraint(
            item: bottomLabel,
            attribute: .left,
            relatedBy: .equal,
            toItem: topLabel,
            attribute: .left,
            multiplier: 1,
            constant: 0))
        
        addConstraint(NSLayoutConstraint(
            item: bottomLabel,
            attribute: .right,
            relatedBy: .equal,
            toItem: topLabel,
            attribute: .right,
            multiplier: 1,
            constant: 0))
    }
}
