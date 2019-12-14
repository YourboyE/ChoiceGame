//
//  GameScene.swift
//  ChoiceGame
//
//  Created by YBE on 12/14/19.
//  Copyright © 2019 DreamDev. All rights reserved.
//

import SpriteKit
import GameplayKit

@objcMembers
class GameScene: SKScene {
    
   var level = 1
    
    
    override func didMove(to view: SKView) {
        
        let backrdImg = SKSpriteNode(imageNamed: "background-leaves")
        backrdImg.name = "backround"
        backrdImg.zPosition = -1
        addChild(backrdImg)
      
        createGrid()
        createLevel()
        
    }
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else{return}
        
        if tapped.name == "correct" {
            correctAnswer(node: tapped)
        } else if tapped.name == "wrong" {
            print("wrong!")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    //MARK: FUNCTIONS
    
    func createGrid() {
        
        let xOffset = -290
        let yOffset = -120
        
        // 5
        // 11 
        for row in 0 ..< 4  {
            for col in 0 ..< 9 {
                let item = SKSpriteNode(imageNamed: "elephant")
                item.setScale(1)
                //this give the spacing between the rows and cols
                item.position = CGPoint(x: xOffset + (col * 75), y: yOffset + (row * 75))
                addChild(item)
            }
        }
        
    } //
    
    func createLevel() {
        
        var itemsToShow = 5 + (level * 4)
        
        // find all nodes that belong to our scene that are not called "Backround"
        let items = children.filter {$0.name != "backround"}
         
        //shuffle those nodes so they are in a random order
        let shuffled = (items as NSArray).shuffled() as! [SKSpriteNode]
       
        //loop over them
        for item in shuffled {
            // and hide each one
            item.alpha = 0
        }
        
        //create and shuffle an array of animals
        let animals = ["elephant", "giraffe", "hippo", "monkey", "panda", "parrot", "penguin", "pig", "rabbit", "snake"]
        
        var shuffledAnimals = (animals as NSArray).shuffled() as! [String]
        
        // remove one for the correct answers
        let correct = shuffledAnimals.removeLast()
        
        var showAnimals = [String]()
        var placingAnimal = 0
        var numUsed = 0
        
        for _ in 1 ..< itemsToShow {
            // mark that we've used this animal
            numUsed += 1
            
            //place it
            showAnimals.append(shuffledAnimals[placingAnimal])
            
            // if we've used this animal twice, go to the next one
            if numUsed == 2 {
                numUsed = 0
                placingAnimal += 1
            }
            
            //if we've gone through all animals, restart
            if placingAnimal == shuffledAnimals.count {
                placingAnimal = 0
            }
        }
        
        for (index, animal) in showAnimals.enumerated() {
            //pull out the matching item
            let item = shuffled[index]
            
            // assign the correct texture
            item.texture = SKTexture(imageNamed: animal)
            
            //show it
            item.alpha = 1
            
            //mark it as wrong
            item.name = "wrong"
        }
        
        shuffled.last?.texture = SKTexture(imageNamed: correct)
        shuffled.last?.alpha = 1
        shuffled.last?.name = "correct"

    }
 
 

    func correctAnswer(node: SKNode) {
        
        let sound = SKAction.playSoundFileNamed("CoinSound.wav", waitForCompletion: true)
        run(sound)
        
        if let sparks = SKEmitterNode(fileNamed: "Sparks.sks") {
            sparks.position = node.position
            addChild(sparks)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                sparks.removeFromParent()
                self.level += 1
                self.createLevel()
            }
        }
        
    }
    
}
