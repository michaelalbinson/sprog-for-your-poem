//
//  PoemListItem.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/19/23.
//

import Foundation
import UIKit

class PoemListItem: UITableViewCell {
    var poem: Poem?
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var poemSnippet: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        StatusCircleUtil.setupCircle(circleView: self.statusCircle, diameter: 25)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        StatusCircleUtil.setColor(circleView: self.statusCircle, by: athlete.status)
        // Configure the view for the selected state
    }
    
    func setPoem(poem: Poem) {
        self.poem = poem
        subTitle.text = poem.submission()?.title ?? ""
        poemSnippet.text = trimmedContent(content: poem.content)
    }
    
    private func trimmedContent(content: String) -> String {
        let cleaned = content.replacingOccurrences(of: "^>.*\n*", with: "", options: [.regularExpression])
        
        let splitLines = cleaned.split(separator: "\n");
        if splitLines.count < 3 {
            return cleaned
        }
        return splitLines[0...1].joined(separator: "\n") + "\n..."
    }
}
