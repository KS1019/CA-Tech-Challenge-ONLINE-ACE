import Danger

let danger = Danger()
let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

if allSourceFiles.first(where: { $0.fileType == .swift }) {
  SwiftLint.lint()
} else {
  message("No .swift file was added")
}
