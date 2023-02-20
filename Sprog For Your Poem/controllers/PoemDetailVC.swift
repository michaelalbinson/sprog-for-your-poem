//
//  PoemDetailVC.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/19/23.
//

import Foundation
import UIKit

class PoemContentVC: UIViewController {
    @IBOutlet weak var submissionTitle: UITextView!
    @IBOutlet weak var submissionContent: UITextView!
    @IBOutlet weak var poemContent: UITextView!
    
    var poem: Poem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let poem = self.poem {
            poemContent.text = poem.content
            submissionTitle.text = poem.submission()?.title ?? ""
            submissionContent.text = poem.submission()?.content ?? ""
        }
    }
    
    func setPoem(poem: Poem) {
        self.poem = poem
    }
}
