import SQLite
import Foundation

/// Create an in-memory database
DatabaseManager.testSeam_useMemoryDB()

let testStr = "{\"gold\": 3,\"imgfilename\": null,\"link\": \"https://www.reddit.com/r/AskReddit/comments/110ec28/youre_dating_a_girl_and_you_really_like_her_and/j88tuhn\",\"noimg\": false,\"orig_content\": \">Sorry, but I want to be your only fan  - What say you? she said, when she'd shown him her site -  Her photos of frankly indecent delight -  Her legions of fans, like her own special tribe.  He said, with a tear of remorse:  =... *unsubscribe*.\",\"orig_submission_content\": \"\",\"parents\": [{\"author\": \"Indie2002\",\"gold\": 1,\"link\": \"https://www.reddit.com/r/AskReddit/comments/110ec28/youre_dating_a_girl_and_you_really_like_her_and/j88dw9n\",\"orig_body\": \"Sorry, but I want to be your only fan\",\"platinum\": 0,\"score\": 18978,\"silver\": 0,\"timestamp\": 1676204359.0}],\"platinum\": 0,\"score\": 8734,\"silver\": 0,\"submission_title\": \"You're dating a girl and you really like her and then you find out she has OF how do you react?\",\"submission_url\": null,\"submission_user\": \"SlightlyNaughty03\", \"timestamp\": 1676213487.0}"

let jsonData = try JSONDecoder().decode(SprogJson.self, from: testStr.data(using: .utf8)!)

PoemLoader.loadPoem(jsonData)

let poem = Poem.get(id: 1)!
poem.parents()
poem.submission()

