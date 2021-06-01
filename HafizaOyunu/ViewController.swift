//
//  ViewController.swift
//  HafizaOyunu
//
//  Created by Efe Topcu on 29.05.2021.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var geriBtnOyun: UIButton!
    var model = CardModel()
    var cardArray = [Card]()
    var timer:Timer?
    var milliseconds:Float = 180 * 1000 // 180 saniye
    var firstFlippedCardIndex:IndexPath?
    var secondFlippedCardIndex:IndexPath?
    var thirdFlippedCardIndex:IndexPath?
    var level = Int()
    var moveCount = 0
    var audioPlayer:AVAudioPlayer?
    var username = String()
    
    @IBAction func geriDon(_ sender: Any) {
        self.performSegue(withIdentifier: "backToMainMenu", sender: nil)
    }
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardArray = model.getCards(level: level)
        let shuffle =  Bundle.main.path(forResource: "shuffle", ofType: "wav")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: shuffle!))

        }
        catch{
            
        }
        audioPlayer?.play()
        timer = Timer.init(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)

        
    }
    
    @objc func timerElapsed(){
        milliseconds -= 1
        
        let minutes = String(format: "%.2f", (milliseconds/1000) / 60)
        timerLabel.text = "Kalan Zaman \(minutes)"
        
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
                    moveCount += 1
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
                    moveCount += 1
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
                    moveCount += 1
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
            
            infoLabel.textColor = .green
            infoLabel.text = "Bir eş buldun!"
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            checkGameEnded()
        }
        else{
            //Kart yanlış eşleştirildi
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            infoLabel.textColor = .red
            infoLabel.text = "Bir eş değil!"
            
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
            
            infoLabel.textColor = .green
            infoLabel.text = "Bir eş buldun!"
            
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
            
            infoLabel.textColor = .red
            infoLabel.text = "Bir eş değil!"
            
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
            
            infoLabel.textColor = .green
            infoLabel.text = "Bir eş buldun!"
            
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
            
            infoLabel.textColor = .red
            infoLabel.text = "Bir eş değil!"
            
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
        var skor = 0
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
            if level == 1{
                if moveCount == 5{
                    skor = 100
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                }
                else if moveCount == 6{
                    skor = 90
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                }
                else if moveCount == 7{
                    skor = 80
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                }
                else if moveCount == 8{
                    skor = 70
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                }
                else if moveCount == 9{
                    skor = 60
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
                }
                else if moveCount == 10{
                    skor = 50
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
                }
                else if moveCount == 11{
                    skor = 40
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
                }
                else if moveCount == 12{
                    skor = 30
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
            }
                else if moveCount == 13{
                    skor = 20
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
               }
                else{
                    skor = 10
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
             }

            }
            else if level == 2 {
                if moveCount == 6{
                    skor = 100
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                 }
                else if moveCount == 7{
                    skor = 90
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                 }
                else if moveCount == 8{
                    skor = 80
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                 }
                else if moveCount == 9{
                    skor = 70
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                 }
                else if moveCount == 10{
                    skor = 60
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                 }
                else if moveCount == 11{
                    skor = 50
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                 }
                else if moveCount == 12{
                    skor = 40
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                 }
                else if moveCount == 13{
                    skor = 30
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                 }
                else if moveCount == 14{
                    skor = 20
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
                }
                else{
                    skor = 10
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
                }
            }
            else{
                if moveCount == 5{
                    skor = 100
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                }
                else if moveCount == 6{
                    skor = 90
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                }
                else if moveCount == 7{
                    skor = 80
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                }
                else if moveCount == 8{
                    skor = 70
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)                }
                else if moveCount == 9{
                    skor = 60
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
                }
                else if moveCount == 10{
                    skor = 50
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
                }
                else if moveCount == 11{
                    skor = 40
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
                }
                else if moveCount == 12{
                    skor = 30
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
            }
                else if moveCount == 13{
                    skor = 20
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
               }
                else{
                    skor = 10
                    message = "Oyunu kazandınız, Level: " + String(level) + "\n Skor: " + String(skor * level)
             }

            }
            let success =  Bundle.main.path(forResource: "success", ofType: "wav")
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: success!))

            }
            catch{
                
            }
            audioPlayer?.play()
        }
        else{
            if milliseconds > 0
            {
                return
            }
            else{
                title = "Kaybettin!"
                message = "Oyunu zamanında bitiremedin."
                let fail =  Bundle.main.path(forResource: "fail", ofType: "wav")
                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fail!))

                }
                catch{
                    
                }
                audioPlayer?.play()
            }
        }
        showAlert(title, message)
        }
    
    func showAlert(_ title:String, _ message:String){
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "backToMainMenu", sender: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

