//
//  ViewController.swift
//  TableTennis_Scoreboard
//
//  Created by Adam Chen on 2024/8/6.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var leftGameScoreLabel: UILabel!
    @IBOutlet weak var rightGameScoreLabel: UILabel!
    @IBOutlet weak var leftTeamNameLabel: UILabel!
    @IBOutlet weak var rightTeamNameLabel: UILabel!
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    @IBOutlet weak var leftServeImageView: UIImageView!
    @IBOutlet weak var rightServeImageView: UIImageView!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var changeSideButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var backgroundSetButton: UIButton!
    @IBOutlet weak var backgroundSetLabel: UILabel!
    
    var leftScore = 0
    var rightScore = 0
    var leftGameScore = 0
    var rightGameScore = 0
    var scoreDifference = 0
    var totalScore = 0
    var scoreHistory: [(player1: Int, player2: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetAll()
        backgroundChange(backgroundColor: nil,textColor: nil,tag: 1)
    }
    
    @IBAction func addScorePressed(_ sender: UIButton) {
        switch sender.tag{
        case 0 :
            leftScore += 1
            leftScoreLabel.text = "\(leftScore)"
            scoreHistory.append((leftScore,rightScore))
            
            checkServe()
            checkWin(scoreA: leftScore, scoreB: rightScore, tag: 0)
        case 1 :
            rightScore += 1
            rightScoreLabel.text = "\(rightScore)"
            scoreHistory.append((leftScore,rightScore))
            
            checkServe()
            checkWin(scoreA: rightScore, scoreB: leftScore, tag: 1)
        default:
            return
        }
    }
    
    @IBAction func teamNameEdited(_ sender: UIButton) {
        var label = UILabel()
        var teamName = ""
        if sender.tag == 0 {
            label = leftTeamNameLabel
            teamName = "Player A"
        }else{
            label = rightTeamNameLabel
            teamName = "Player B"
        }
        
        let controller = UIAlertController(title: "請輸入名稱", message: nil, preferredStyle: .alert)
        controller.addTextField { textField in
            textField.text = label.text
            textField.keyboardType = UIKeyboardType.phonePad
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned controller] _ in
        let name = controller.textFields?[0].text
            if name != ""{
                label.text = name
            }else{
                label.text = teamName
            }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    
    @IBAction func rewind(_ sender: Any) {
        if scoreHistory.count > 1 {
            scoreHistory.removeLast()
            let previousScores = scoreHistory.last!
            leftScore = previousScores.player1
            rightScore = previousScores.player2
            
            leftScoreLabel.text = "\(leftScore)"
            rightScoreLabel.text = "\(rightScore)"
            
            totalScore = leftScore + rightScore
            if totalScore % 2 != 0 || totalScore >= 20 {
                if leftServeImageView.isHidden {
                    leftServeImageView.isHidden = false
                    rightServeImageView.isHidden = true
                }else{
                    leftServeImageView.isHidden = true
                    rightServeImageView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func changeSide(_ sender: Any) {
        let teamName = leftTeamNameLabel.text
        leftTeamNameLabel.text! = rightTeamNameLabel.text!
        rightTeamNameLabel.text! = teamName!
        
        let gameScore = leftGameScore
        leftGameScore = rightGameScore
        rightGameScore = gameScore
        leftGameScoreLabel.text = "\(leftGameScore)"
        rightGameScoreLabel.text = "\(rightGameScore)"
        
        let Score = leftScore
        leftScore = rightScore
        rightScore = Score
        leftScoreLabel.text = "\(leftScore)"
        rightScoreLabel.text = "\(rightScore)"
        
        if leftServeImageView.isHidden {
            leftServeImageView.isHidden = false
            rightServeImageView.isHidden = true
        }else{
            leftServeImageView.isHidden = true
            rightServeImageView.isHidden = false
        }
        
        var tempHistory: [(player1: Int, player2: Int)] = []
        for item in scoreHistory {
            tempHistory.append((item.player2,item.player1))
        }
        scoreHistory = tempHistory
    }
    
    @IBAction func reset(_ sender: Any) {
        resetAll()
    }
    
    @IBAction func setBackgroundStyle(_ sender: UIAction){
        var backgroundColor = UIColor()
        var textColor = UIColor()
        switch sender.title {
        case "Dark" :
            backgroundColor = .darkGray
            textColor = .white
        case "Light" :
            backgroundColor = .systemBackground
            textColor = .systemBlue
        case "Blue" :
            backgroundColor = UIColor(red: 48/255, green: 124/255, blue: 245/255, alpha: 1)
            textColor = .white
        case "Orange" :
            backgroundColor = UIColor(red: 221/255, green: 100/255, blue: 63/255, alpha: 1)
            textColor = .white
        case "Green" :
            backgroundColor = UIColor(red: 105/255, green: 155/255, blue: 64/255, alpha: 1)
            textColor = .white
        default:
            return
        }
        
        backgroundChange(backgroundColor: backgroundColor,textColor: textColor,tag: 0)
    }
    
    //背景更換
    func backgroundChange(backgroundColor: UIColor?,textColor: UIColor?,tag: Int) {
        var bgColor = UIColor()
        var txtColor = UIColor()
        if tag == 1 {
            bgColor = .darkGray
            txtColor = .white
        }else{
            bgColor = backgroundColor!
            txtColor = textColor!
        }
        backgroundImageView.backgroundColor = bgColor
        leftScoreLabel.textColor = txtColor
        leftGameScoreLabel.textColor = txtColor
        leftTeamNameLabel.textColor = txtColor
        rightScoreLabel.textColor = txtColor
        rightGameScoreLabel.textColor = txtColor
        rightTeamNameLabel.textColor = txtColor
        rewindButton.tintColor = txtColor
        changeSideButton.tintColor = txtColor
        resetButton.tintColor = .red
        backgroundSetButton.tintColor = txtColor
        leftServeImageView.tintColor = txtColor
        rightServeImageView.tintColor = txtColor
        backgroundSetLabel.textColor = txtColor
    }
    
    //判斷發球
    func checkServe() {
        totalScore = leftScore + rightScore
        if totalScore % 2 == 0 || totalScore >= 20 {
            if leftServeImageView.isHidden {
                leftServeImageView.isHidden = false
                rightServeImageView.isHidden = true
            }else{
                leftServeImageView.isHidden = true
                rightServeImageView.isHidden = false
            }
        }
    }
    
    //判斷獲勝
    func checkWin(scoreA: Int, scoreB: Int, tag: Int) {
        scoreDifference = scoreA-scoreB
        if scoreA >= 11 && scoreDifference >= 2{
            switch tag{
            case 0 :
                leftGameScore += 1
                leftGameScoreLabel.text = "\(leftGameScore)"
                winGameAlert(winner: leftTeamNameLabel.text!)
            case 1 :
                rightGameScore += 1
                rightGameScoreLabel.text = "\(rightGameScore)"
                winGameAlert(winner: rightTeamNameLabel.text!)
            default:
                return
            }
            leftScore = 0
            leftScoreLabel.text = "\(leftScore)"
            rightScore = 0
            rightScoreLabel.text = "\(rightScore)"
            scoreHistory.removeAll()
            scoreHistory = [(0, 0)]
        }
    }
    
    //獲勝彈窗通知
    func winGameAlert(winner:String){
        let controller = UIAlertController(title: "比賽結束!", message: "\n恭喜\(winner)獲勝", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        controller.addAction(okAction)
        present(controller, animated: true)
            
    }
    
    //全部重置
    func resetAll() {
        leftScore = 0
        leftScoreLabel.text = "\(leftScore)"
        rightScore = 0
        rightScoreLabel.text = "\(rightScore)"
        leftGameScore = 0
        leftGameScoreLabel.text = "\(leftGameScore)"
        rightGameScore = 0
        rightGameScoreLabel.text = "\(rightGameScore)"
        scoreHistory.removeAll()
        scoreHistory = [(0, 0)]
        leftServeImageView.isHidden = false
        rightServeImageView.isHidden = true
    }


}

