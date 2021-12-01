//
//  ViewController.swift
//  TinderDemo
//
//  Created by 佐藤勇太 on 2021/07/27.
//

import UIKit

class ViewController: UIViewController {
    //basicCardの宣言
    @IBOutlet weak var basicCard: UIView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    
    var centerOfCard:CGPoint!
    //配列に入れるところ
    var pepole = [UIView]()
    var selectedCardCount: Int = 0
    
    let name = ["ほのか", "あかね", "みほ", "カルロス"]
    var likedName = [String]()
    
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        //cardOfCenterにbasicCardの真ん中の情報を代入している
        centerOfCard = basicCard.center
        
        //配列の追加
        pepole.append(person1)
        pepole.append(person2)
        pepole.append(person3)
        pepole.append(person4)
    }
    
    
    //元に戻す処理の関数
    func resetCard() {
        //カードを初期値の真ん中に戻す //クラスの直下にはselfをつける
        basicCard.center = self.centerOfCard
        //カードの角度を戻す .identtity　で元に戻る
        basicCard.transform = .identity
    }
    
    //PushListの時だけ
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushList" {
            //vcの定数に対してPushListコントローラー自体
            let vc = segue.destination as! ListViewController
            vc.likedName = likedName
        }
    }
    
    
    //ボタンでの処理
    
    @IBAction func likedbuttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.resetCard()
            self.pepole[self.selectedCardCount].center = CGPoint(x: self.pepole[self.selectedCardCount].center.x + 500, y: self.pepole[self.selectedCardCount].center.y)
        })
        likeImageView.alpha = 0
        likedName.append(name[selectedCardCount])
        selectedCardCount += 1
        if selectedCardCount >= pepole.count {
            //繊維支える処理
            performSegue(withIdentifier: "PushList", sender: self)
        }
    }
    
    
    @IBAction func dislikebuttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.resetCard()
            self.pepole[self.selectedCardCount].center = CGPoint(x: self.pepole[self.selectedCardCount].center.x - 500, y: self.pepole[self.selectedCardCount].center.y)
        })
        likeImageView.alpha = 0
        selectedCardCount += 1
        if selectedCardCount >= pepole.count {
            //遷移させる処理
            performSegue(withIdentifier: "PushList", sender: self)
        }
    }
    
    
    
    //bascicardをスワイプした時の処理
    @IBAction func swipCard(_ sender: UIPanGestureRecognizer) {
        //ドラッグされている値の情報をcardに代入している
        let card = sender.view!
        //ドラッグ&ドロップをどのくらい動いたかの値
        let point = sender.translation(in: view)
        //cardがスワイプした分ついてくる
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        //pepoleの位置を変える
        pepole[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        //右に行ったらプラス左に行ったらマイナス
        let xFromCenter = card.center.x - view.center.x
        //角度を変える 0.785は-45度
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        //pepoleの角度も同じにする
        pepole[selectedCardCount].transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        
         
        //右側にスワイプしたらgood 色を青
        if xFromCenter > 0 {
            likeImageView.image = UIImage(named: "good")
            likeImageView.alpha = 1
            likeImageView.tintColor = UIColor.blue
        //右側にスワイプしたらbad　色を赤
        } else if xFromCenter < 0 {
            likeImageView.image = UIImage(named: "bad")
            likeImageView.alpha = 1
            likeImageView.tintColor = UIColor.red
        }
        
        
        
        
        //指が離れた状態ならの処理
        if sender.state == UIGestureRecognizer.State.ended {
            
            //左に大きくスワイプ
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.resetCard()
                    self.pepole[self.selectedCardCount].center = CGPoint(x: self.pepole[self.selectedCardCount].center.x - 250, y: self.pepole[self.selectedCardCount].center.y)
                })
                likeImageView.alpha = 0
                selectedCardCount += 1
                if selectedCardCount >= pepole.count {
                    //遷移させる処理
                    performSegue(withIdentifier: "PushList", sender: self)
                }
                //IBActionの関数から抜ける
                return
            //右に大きくスワイプ
            } else if card.center.x > self.view.frame.width - 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.resetCard()
                    self.pepole[self.selectedCardCount].center = CGPoint(x: self.pepole[self.selectedCardCount].center.x + 250, y: self.pepole[self.selectedCardCount].center.y)
                })
                likeImageView.alpha = 0
                likedName.append(name[selectedCardCount])
                selectedCardCount += 1
                if selectedCardCount >= pepole.count {
                    //繊維支える処理
                    performSegue(withIdentifier: "PushList", sender: self)
                }
                //忘れずに
                return
            }
            
            //元に戻る処理
            UIView.animate(withDuration: 0.2, animations: {
                self.resetCard()
                self.pepole[self.selectedCardCount].center = self.centerOfCard
                self.pepole[self.selectedCardCount].transform = .identity
            })
            //どっちにもスワイプしていない時にimageのalphaを0に戻す
            likeImageView.alpha = 0

        }
    }
    
}

