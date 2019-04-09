//
//  ScoreController.swift
//  Mastermind
//
//  Created by etudiant on 09/04/2019.
//  Copyright © 2019 etudiant. All rights reserved.
//

import UIKit


class ScoreController : UIViewController {
    
    var temps = ""
    
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var nom: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time.textColor = UIColor.cyan
        time.text = temps
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func valider(_ sender: Any) {
        
        performSegue(withIdentifier: "segue2", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue2"{
            
            let dest2 = segue.destination as! ListScoreController
            
            dest2.nom = nom.text!
            dest2.score = temps
            
        }
    }
    
    
    
    
}
