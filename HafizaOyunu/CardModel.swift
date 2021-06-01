//
//  CardModel.swift
//  HafizaOyunu
//
//  Created by Efe Topcu on 29.05.2021.
//

import Foundation

class CardModel{
    func getCards(level:Int) -> [Card] {
        var generatedNumbersArray = [Int]()
        
        var generatedCardsArray = [Card]()
        //TODO: Buraya bir if gelecek, level değişkenine göre kartlar oluşturulacak.
        if level == 1{
            while generatedNumbersArray.count < 5 {
                
                let randomNumber = arc4random_uniform(13) + 1
                
                if generatedNumbersArray.contains(Int(randomNumber)) == false{
                    
                    generatedNumbersArray.append(Int(randomNumber))

                    let cardOne = Card()
                    cardOne.imageName = "card\(randomNumber)"
                    generatedCardsArray.append(cardOne)
                    
                    let cardTwo = Card()
                    cardTwo.imageName = "card\(randomNumber)"
                    
                    generatedCardsArray.append(cardTwo)
                }
                
            }
        }
        else if level == 2{
            while generatedNumbersArray.count < 6 {
                
                let randomNumber = arc4random_uniform(6) + 1
                
                if generatedNumbersArray.contains(Int(randomNumber)) == false{
                    
                    generatedNumbersArray.append(Int(randomNumber))

                    let cardOne = Card()
                    cardOne.imageName = "animal\(randomNumber)"
                    generatedCardsArray.append(cardOne)
                    
                    let cardTwo = Card()
                    cardTwo.imageName = "animal\(randomNumber)"
                    generatedCardsArray.append(cardTwo)
                    
                    let cardThree = Card()
                    cardThree.imageName = "animal\(randomNumber)"
                    generatedCardsArray.append(cardThree)
                }
                
            }
        }
        else if level == 3{
            while generatedNumbersArray.count < 5 {
                
                let randomNumber = arc4random_uniform(5) + 1
                
                if generatedNumbersArray.contains(Int(randomNumber)) == false{
                    
                    generatedNumbersArray.append(Int(randomNumber))

                    let cardOne = Card()
                    cardOne.imageName = "ball\(randomNumber)"
                    generatedCardsArray.append(cardOne)
                    
                    let cardTwo = Card()
                    cardTwo.imageName = "ball\(randomNumber)"
                    generatedCardsArray.append(cardTwo)
                    
                    let cardThree = Card()
                    cardThree.imageName = "ball\(randomNumber)"
                    generatedCardsArray.append(cardThree)
                    
                    let cardFour = Card()
                    cardFour.imageName = "ball\(randomNumber)"
                    generatedCardsArray.append(cardFour)
                }
                
            }
        }
        for i in 0...generatedCardsArray.count - 1{
            let randomNumber = arc4random_uniform(UInt32(generatedCardsArray.count))
            
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[Int(randomNumber)]
            generatedCardsArray[Int(randomNumber)] = temporaryStorage
        }

        return generatedCardsArray
    }
    
}
