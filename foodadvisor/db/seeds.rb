# Trova alcuni utenti e competizioni esistenti
user1 = User.find(1)
user2 = User.find(2)
competizione1 = Competizione.find(1)
competizione2 = Competizione.find(2)

# Crea partecipazioni di prova
UserCompetition.create!(
  user: user1,
  competizione: competizione1,
  punti: 10
)

UserCompetition.create!(
  user: user1,
  competizione: competizione2,
  punti: 15
)

UserCompetition.create!(
  user: user2,
  competizione: competizione1,
  punti: 20
)

UserCompetition.create!(
  user: user2,
  competizione: competizione2,
  punti: 25
)

puts "Created #{UserCompetition.count} user competitions"
