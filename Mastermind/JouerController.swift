//
//  JouerController.swift
//  Mastermind
//
//  Created by etudiant on 05/04/2019.
//  Copyright © 2019 etudiant. All rights reserved.
//

import UIKit

class JouerController: UIViewController {

    var col0 : [UIButton] = []
    var col1 : [UIButton] = []
    var col2 : [UIButton] = []
    var col3 : [UIButton] = []
    
    var colS0 : [UIButton] = []
    var colS1 : [UIButton] = []
    var colS2 : [UIButton] = []
    var colS3 : [UIButton] = []
    
    
    let tabCouleur : [UIColor] = [.yellow , .cyan , .magenta , .green , .red , .black , .blue   ]
    
    
    var manche : Int = 0
    
    var count = 0
    var min = 0
    
    var timer = Timer()
    
    
    
    @IBOutlet weak var valider: UIButton!
    
    @IBOutlet weak var pionJ0: UIButton!
    @IBOutlet weak var pionJ1: UIButton!
    @IBOutlet weak var pionJ2: UIButton!
    @IBOutlet weak var pionJ4: UIButton!
    @IBOutlet weak var counterTimer: UILabel!
    
    var combinaison : [UIColor] = []
    
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(JouerController.counter), userInfo: nil, repeats: true)
    }
    
    @objc func counter() {
        
        count += 1
        
        
        
        if count == 60 {
            count = 0
            min += 1
            
            
            
            
        }
        else {
            if (min > 9 && count > 9 ){
                
                counterTimer.text = String(min) + ":"+String(count)}
                
            if (min > 9 && count < 10 ){
                 
                    counterTimer.text = String(min) + ":0" + String(count)
                }
                
            if (min < 10 && count > 9 ){
                
                counterTimer.text = "0"+String(min) + ":" + String(count)
                
            }
                
            else {
                
                counterTimer.text = "0"+String(min) + ":0"+String(count)
            }
           
        }
    }
    
    func pause(){
        
        timer.invalidate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setJouerPIOn()
        col0 = setTabButton(col: col0 , pos: 10)
        col1 = setTabButton(col: col1 , pos: 60)
        col2 = setTabButton(col: col2 , pos: 110)
        col3 = setTabButton(col: col3 , pos: 160)
        
        colS0 = setTabScoreButton(col: colS0 , pos: 300)
        colS1 = setTabScoreButton(col: colS1 , pos: 330)
        colS2 = setTabScoreButton(col: colS2 , pos: 360)
        colS3 = setTabScoreButton(col: colS3 , pos: 390)
        
        start()
        setCombinaison()
        showCombinaison()
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()}
    
    
    
    func setTabScoreButton ( col : [UIButton] , pos : Int) -> [UIButton] {
        
        var col = col
        for i in 0...10{
            
            col.append(createButton())
            col[i].frame = CGRect(x: pos, y: 80 +  50*i, width: 20, height: 20)
            setupButtonStyle(button: col[i], color: .gray)
            self.view.addSubview(col[i])
            }
        
        return col
        
    }
    
    
    func setTabButton ( col : [UIButton] , pos : Int) -> [UIButton] {
        
        var col = col
        for i in 0...10{
            
            col.append(createButton())
            col[i].frame = CGRect(x: pos, y: 70 +  50*i, width: 40, height: 40)
            setupButtonStyle(button: col[i], color: .yellow)
            self.view.addSubview(col[i])
            }
        
        return col
    
    }
    
    
    func setJouerPIOn (){
        
        setupButtonStyle(button: pionJ0, color: .blue)
        setupButtonStyle(button: pionJ1, color: .blue)
        setupButtonStyle(button: pionJ2, color: .blue)
        setupButtonStyle(button: pionJ4, color: .blue)
        
    }

    func createButton () -> UIButton {
        var button = UIButton();
        button.setTitle("0", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
       
        return button
    }
    
    func setupButtonStyle(button : UIButton, color: UIColor){
        // Customizing Menu Button Style
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = color
        button.setTitleColor(color, for: .normal)
        
        
    }
    
    
    @IBAction func changeColor(_ sender: UIButton) {
        
        var compteur: Int = (sender.titleLabel!.text! as NSString).integerValue
        
        compteur = compteur+1
        sender.setTitle(String(compteur), for: .normal)
        sender.backgroundColor = tabCouleur[compteur%7]
        sender.setTitleColor(tabCouleur[compteur%7], for: .normal)
        
        
    }
    
    func setGrilleManche(){
        
        col0[10-manche].backgroundColor = pionJ0.backgroundColor
        col0[10-manche].setTitle("", for: .normal)
        
        col1[10-manche].backgroundColor = pionJ1.backgroundColor
        col1[10-manche].setTitle("", for: .normal)
        
        col2[10-manche].backgroundColor = pionJ2.backgroundColor
        col2[10-manche].setTitle("", for: .normal)
        
        col3[10-manche].backgroundColor = pionJ4.backgroundColor
        col3[10-manche].setTitle("", for: .normal)
        
        
        
    }
    
    @IBAction func jouerManche(_ sender: Any) {
        
        setGrilleManche()
        arbitrageManche()
        manche = manche+1
        print(isInCombinaison(button: pionJ0))
        if (manche == 12){
            
            exit(0)
            
        }
        
        
        if (isWin()){
            
            pause()
            
            performSegue(withIdentifier: "segue1", sender: nil)
            
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1" {
            
            
            let dest  = segue.destination as! ScoreController
            dest.temps = counterTimer.text!
            
        }
    }
    
    
    
    func arbitrageManche(){ //a faire (pas optimisé) car problème avec tableaux deux entrées
        
        
        /* Si le pion est dans la combinaison et bien placé  */
        if (isInCombinaison(button: pionJ0)){
            
            for i in 0...3{
                
                if (pionJ0.backgroundColor == combinaison[i]){
                    
                    switch i {
                        
                    case 0 :
                        colS0[10-manche].backgroundColor = UIColor.black
                        break
                    case 1 :
                        colS1[10-manche].backgroundColor = UIColor.black
                        break
                    case 2 :
                        colS2[10-manche].backgroundColor = UIColor.black
                        break
                    case 3 :
                        colS3[10-manche].backgroundColor = UIColor.black
                        break
                    default :
                        break
                    }}
                
                if (pionJ1.backgroundColor == combinaison[i]){
                    
                    switch i {
                        
                    case 0 :
                        colS0[10-manche].backgroundColor = UIColor.black
                        break
                    case 1 :
                        colS1[10-manche].backgroundColor = UIColor.black
                        break
                    case 2 :
                        colS2[10-manche].backgroundColor = UIColor.black
                        break
                    case 3 :
                        colS3[10-manche].backgroundColor = UIColor.black
                        break
                    default :
                        break
                    }}
                if (pionJ2.backgroundColor == combinaison[i]){
                    
                    switch i {
                        
                    case 0 :
                        colS0[10-manche].backgroundColor = UIColor.black
                        break
                    case 1 :
                        colS1[10-manche].backgroundColor = UIColor.black
                        break
                    case 2 :
                        colS2[10-manche].backgroundColor = UIColor.black
                        break
                    case 3 :
                        colS3[10-manche].backgroundColor = UIColor.black
                        break
                    default :
                        break
                    }}
                
                if (pionJ4.backgroundColor == combinaison[i]){
                    
                    switch i {
                        
                    case 0 :
                        colS0[10-manche].backgroundColor = UIColor.black
                        break
                    case 1 :
                        colS1[10-manche].backgroundColor = UIColor.black
                        break
                    case 2 :
                        colS2[10-manche].backgroundColor = UIColor.black
                        break
                    case 3 :
                        colS3[10-manche].backgroundColor = UIColor.black
                        break
                    default :
                        break
                    }}
                
            }}
        
        
        
        
        /* Si le pion n'est pas dans la combinaison -> blanc  */
        
        if (!isInCombinaison(button: pionJ0)){
            
            colS0[10-manche].backgroundColor = UIColor.white
            
        }
        
        if (!isInCombinaison(button: pionJ1)){
            
            colS1[10-manche].backgroundColor = UIColor.white
            
        }
        
        if (!isInCombinaison(button: pionJ2)){
            
            colS2[10-manche].backgroundColor = UIColor.white
            
        }
        
        if (!isInCombinaison(button: pionJ4)){
            
            colS3[10-manche].backgroundColor = UIColor.white
            
        }
        
    }
    
    func setCombinaison(){
        
        /*temporaire car c'est une trop vieille version de swift, impossibilité d'utiliser random(*/
        
        let number0 = Int(arc4random_uniform(7))
        let number1 = Int(arc4random_uniform(7))
        let number2 = Int(arc4random_uniform(7))
        let number3 = Int(arc4random_uniform(7))
        
        combinaison.append(tabCouleur[number0])
        combinaison.append(tabCouleur[number1])
        combinaison.append(tabCouleur[number2])
        combinaison.append(tabCouleur[number3])

    }
    
    func showColorString(color : UIColor) -> String {
        
        var scolor : String = ""
        
        var colorHash : Int = color.hashValue
        
        switch colorHash {
        case 144900096:
            scolor = "Majenta"
            break
        
        case 11141120:
            scolor = "Vert"
            break
            
        case 144048128 :
            scolor = "Rouge"
            break
            
        case 65536 :
            scolor="Noir"
            
        case 917504 :
            scolor = "Bleu"
            
        case 11993088:
            scolor = "Cyan"
            
        case 155123712:
            scolor="Jaune"
            
        default :
            scolor = "inconnu"
            }
        
        return scolor
        
    }
    
    func showCombinaison(){
        print("[")
        for i in 0...3{
            
            print(showColorString(color: combinaison[i]) + " , " )
            
        }
        print("]")
    }
    
    func isInCombinaison (button : UIButton) -> Bool {
        
        for i in 0...3 {
            
            if (button.backgroundColor?.isEqual(combinaison[i]))!{
                
                return true
            }
            
        }
        
        return false
        }
    
    
    
    func isWin() -> Bool {
        
        if ((pionJ0.backgroundColor != combinaison[0]) || (pionJ1.backgroundColor != combinaison[1])
            || (pionJ2.backgroundColor != combinaison[2]) || (pionJ4.backgroundColor != combinaison[3])  ){
            
            return false
        }
        
        return true
        
        
        
    }
    
    
    




}
