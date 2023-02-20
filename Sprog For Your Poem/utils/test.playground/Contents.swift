import SQLite
import Compression

/// Create an in-memory database
let test = """
>This is a test string

With a lot of lines with multiple things

"""



let cleaned = test.replacingOccurrences(of: "^>.*\n*", with: "", options: [.regularExpression])

if cleaned.split(separator: "\n").count > 3 {
    cleaned.split(separator: "\n")[0...3].joined(separator: "\n")
}
print(cleaned.split(separator: "\n").dropLast(-3).joined(separator: "\n"))
