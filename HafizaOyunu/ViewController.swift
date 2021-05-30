//
//  ViewController.swift
//  HafizaOyunu
//
//  Created by Efe Topcu on 29.05.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var model = CardModel()
    var cardArray = [Card]()
    var timer:Timer?
    var milliseconds:Float = 180 * 1000 // 180 saniye
    var firstFlippedCardIndex:IndexPath?
    var secondFlippedCardIndex:IndexPath?
    var thirdFlippedCardIndex:IndexPath?
    var level = 1
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardArray = model.getCards(level: 1)
        timer = Timer.init(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc func timerElapsed(){
        milliseconds -= 1
        
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        timerLabel.text = "Kalan Zaman \(seconds)"
        
        if milliseconds <= 0{
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            checkGameEnded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        cell.setCard(card)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliseconds <= 0{
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        if card.isFlipped == false && card.isMatched == false{
            cell.flip()
            card.isFlipped = true
            
            if level == 1{
                if firstFlippedCardIndex == nil{
                    //İlk çevirilen kart
                    firstFlippedCardIndex = indexPath
                }
                else{
                    //İkinci çevirilen kart
                    
                    checkForMatches(indexPath)
                }
            }
            else if level == 2 {
                if firstFlippedCardIndex == nil{
                    //İlk çevirilen kart
                    firstFlippedCardIndex = indexPath
                }
                else if secondFlippedCardIndex == nil{
                    //İkinci çevirilen kart
                    
                    secondFlippedCardIndex = indexPath
                }
                else{
                    checkForMatches3(indexPath)
                }
            }
            else if level == 3 {
                if firstFlippedCardIndex == nil{
                    //İlk çevirilen kart
                    firstFlippedCardIndex = indexPath
                }
                else if secondFlippedCardIndex == nil{
                    //İkinci çevirilen kart
                    
                    secondFlippedCardIndex = indexPath
                }
                else if thirdFlippedCardIndex == nil{
                    //İkinci çevirilen kart
                    
                    thirdFlippedCardIndex = indexPath
                }
                else{
                    checkForMatches4(indexPath)
                }
            }
            
        }
    }
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName{
            //Kart doğru eşleştirildi
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            checkGameEnded()
        }
        else{
            //Kart yanlış eşleştirildi
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        if cardOneCell == nil{
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        firstFlippedCardIndex = nil
    }
    
    func checkForMatches3(_ thirdFlippedCardIndex:IndexPath){
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex!) as? CardCollectionViewCell
        let cardThreeCell = collectionView.cellForItem(at: thirdFlippedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex!.row]
        let cardThree = cardArray[thirdFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName && cardOne.imageName == cardThree.imageName{
            //Kart doğru eşleştirildi
            cardOne.isMatched = true
            cardTwo.isMatched = true
            cardThree.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            cardThreeCell?.remove()
            checkGameEnded()
        }
        else{
            //Kart yanlış eşleştirildi
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            cardThree.isFlipped = false
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            cardThreeCell?.flipBack()
        }
        if cardOneCell == nil{
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        else if cardTwoCell == nil{
            collectionView.reloadItems(at: [secondFlippedCardIndex!])
        }
        
        firstFlippedCardIndex = nil
        secondFlippedCardIndex = nil
    }
    
    func checkForMatches4(_ fourthFlippedCardIndex:IndexPath){
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex!) as? CardCollectionViewCell
        let cardThreeCell = collectionView.cellForItem(at: thirdFlippedCardIndex!) as? CardCollectionViewCell
        let cardFourCell = collectionView.cellForItem(at: fourthFlippedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex!.row]
        let cardThree = cardArray[thirdFlippedCardIndex!.row]
        let cardFour = cardArray[fourthFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName && cardOne.imageName == cardThree.imageName && cardOne.imageName == cardFour.imageName{
            //Kart doğru eşleştirildi
            cardOne.isMatched = true
            cardTwo.isMatched = true
            cardThree.isMatched = true
            cardFour.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            cardThreeCell?.remove()
            cardFourCell?.remove()
            checkGameEnded()
        }
        else{
            //Kart yanlış eşleştirildi
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            cardThree.isFlipped = false
            cardFour.isFlipped = false
            
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            cardThreeCell?.flipBack()
            cardFourCell?.flipBack()
        }
        if cardOneCell == nil{
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        else if cardTwoCell == nil{
            collectionView.reloadItems(at: [secondFlippedCardIndex!])
        }
        else if cardThreeCell == nil{
            collectionView.reloadItems(at: [thirdFlippedCardIndex!])
        }
        
        firstFlippedCardIndex = nil
        secondFlippedCardIndex = nil
        thirdFlippedCardIndex = nil
    }
    func checkGameEnded(){
        var title = ""
        var message = ""
        var isWon = true
        for card in cardArray{
            if card.isMatched == false{
                isWon = false
                break
            }
        }
        if isWon == true{
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Tebrikler!"
            message = "Oyunu kazandınız."
        }
        else{
            if milliseconds > 0
            {
                return
            }
            else{
                title = "Kaybettin!"
                message = "Oyunu zamanında bitiremedin."
            }
        }
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String){
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
}

