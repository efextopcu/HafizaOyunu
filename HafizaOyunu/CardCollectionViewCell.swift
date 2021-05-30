//
//  CardCollectionViewCell.swift
//  HafizaOyunu
//
//  Created by Efe Topcu on 29.05.2021.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card){
        //Aktarılan kartların takibi
        self.card = card
        
        if card.isMatched == true{
            frontImageView.alpha = 0
            backImageView.alpha = 0
            
            return
        }
        else{
            frontImageView.alpha = 1
            backImageView.alpha = 1
            
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isFlipped == true{
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else{
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip(){
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView
                              , to: self.backImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        
        
    }
    
    func remove(){
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    }
}
