//
//  ViewController.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2021-07-10.
//

import UIKit

class LandingPageVC: UIViewController {
    @IBOutlet weak var randomPoemBox: UITextView!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var seeContextButton: UIButton!
    
    private var poem: Poem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.poem = Poem.getRandom()
        if let poem = self.poem {
            randomPoemBox.text = poem.content
        } else {
            randomPoemBox.text = "Neat!"
        }
        setupPoemLoaders()
    }
    
    func setupPoemLoaders() {
        // add some skew to reload time
        Timer.scheduledTimer(withTimeInterval: PoemLoader.RELOAD_TIME + 3, repeats: true) { _ in
            PoemLoader.peekPoems()
        }
        
        // if we have some poems we can assume tbe most poems are loaded
        guard let _ = Poem.get(id: 1) else {
            PoemLoader.getFull()
            return
        }
    }
    
    @IBAction func seeContextAction(_ sender: Any) {
        if sender as? UIButton != seeContextButton {
            return
        }
        
        self.performSegue(withIdentifier: "homeToDetail", sender: self)
    }
    
    @IBAction func shufflePoem(_ sender: Any) {
        if sender as? UIButton != shuffleButton {
            return
        }
        
        self.poem = Poem.getRandom()
        if let poem = self.poem {
            randomPoemBox.text = poem.content
        } else {
            randomPoemBox.text = "Neat!"
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PoemContentVC {
            dest.setPoem(poem: self.poem!)
        }
    }
}

