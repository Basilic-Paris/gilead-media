puts 'Destroying'
# User.destroy_all
DocumentFolder.destroy_all
Folder.destroy_all
Document.destroy_all

# FOLDERS
puts "Seeding Folders"
folders_attributes = [
  { title: "Finance" },
  { title: "Marketing" },
  { title: "Identité visuelle" }
]
Folder.create! folders_attributes
puts "Folders done"


# DOCUMENTS
puts "Seeding Documents"
img = Document.new(title: "Visuel film On Boarding", language: "FR", usage: "Interne", validation_at: DateTime.now)
img.attachment.attach(io: File.open("/Users/alice/Desktop/TEST/Visuel_film_On_Boarding.jpg"), filename: "Visuel_film_On_Boarding.jpg")
img.save

img2 = Document.new(title: "Logo Gilead Média noir", language: "FR", usage: "Interne")
img2.attachment.attach(io: File.open("/Users/alice/Desktop/TEST/Logo_Gilead_Média_Noir.png"), filename: "Logo_Gilead_Média_Noir.png")
img2.save

video = Document.new(title: "What's Politique - Episode 1", language: "FR", usage: "Interne\nExterne", validation_at: DateTime.now)
video.attachment.attach(io: File.open("/Users/alice/Desktop/TEST/.Whats_Politique_Episode_un.mp4.icloud"), filename: "Whats_Politique_Episode_un.mp4")
video.save

numbers = Document.new(title: "Communication financière numbers", language: "FR", usage: "Interne", validation_at: DateTime.now)
numbers.attachment.attach(io: File.open("/Users/alice/Desktop/TEST/Communication_financiere_numbers.numbers"), filename: "Communication_financiere_numbers.numbers")
numbers.save

pdf = Document.new(title: "Communication financière pdf", language: "FR", usage: "Interne", validation_at: DateTime.now)
pdf.attachment.attach(io: File.open("/Users/alice/Desktop/TEST/Communication_financiere_pdf.pdf"), filename: "Communication_financiere_pdf.pdf")
pdf.save

xls = Document.new(title: "Communication financière excel", language: "FR", usage: "Interne")
xls.attachment.attach(io: File.open("/Users/alice/Desktop/TEST/Communication_financiere_xls.xlsx"), filename: "Communication_financiere_xls.xlsx")
xls.save

ppt = Document.new(title: "Nos chefs", language: "FR")
ppt.attachment.attach(io: File.open("/Users/alice/Desktop/TEST/.Nos_chefs.pptx.icloud"), filename: "Nos_chefs.pptx")
ppt.save

word = Document.new(title: "Notes word", language: "FR", validation_at: DateTime.now)
word.attachment.attach(io: File.open("/Users/alice/Desktop/TEST/Notes.docx"), filename: "Notes.docx")
word.save
puts "Documents done"


# DOCUMENT FOLDER
puts "Seeding DocumentFolders"
document_folders_attributes = [
  { folder: Folder.first, document: Document.find_by(title: "Communication financière numbers") },
  { folder: Folder.first, document: Document.find_by(title: "Communication financière pdf") },
  { folder: Folder.first, document: Document.find_by(title: "Communication financière excel") },
  { folder: Folder.second, document: Document.find_by(title: "Visuel film On Boarding") },
  { folder: Folder.second, document: Document.find_by(title: "Logo Gilead Média noir") },
  { folder: Folder.second, document: Document.find_by(title: "What's Politique - Episode 1") },
  { folder: Folder.third, document: Document.find_by(title: "Visuel film On Boarding") },
  { folder: Folder.third, document: Document.find_by(title: "Logo Gilead Média noir") },
  { folder: Folder.third, document: Document.find_by(title: "What's Politique - Episode 1") },
]
DocumentFolder.create! document_folders_attributes
puts "DocumentFolders done"

# puts "Seeding Users"
# users_attributes = [
#   { email: 'alice.fabre@hotmail.fr', first_name: 'Alice', last_name: 'Fabre', password: 'plopplop', admin: true },
#   { email: 'gregory@cookoon.fr', first_name: 'Grégory', last_name: 'Escure', password: 'plopplop' },
# ]
# User.create! users_attributes
# puts "Users done"
