# Food-Advisor
Progetto di Architetture e Sicurezza Software, La Sapienza 2023/2024

# Clonare il repository (solo se non l'hai già fatto):
git clone https://github.com/username/nome-repository.git
cd nome-repository

# Creare e spostarsi su un nuovo branch:
git checkout -b feature/nome-branch

# Sincronizzare con il branch principale:
git fetch origin
git checkout main  # O master
git pull origin main
git checkout feature/nome-branch
git rebase main

# Eseguire modifiche e commit:
# Effettua le modifiche ai file...
git add .
git commit -m "Descrizione delle modifiche effettuate"

# Pushare le modifiche al branch remoto:
git push -u origin feature/nome-branch

# Sincronizzare nuovamente se necessario:
git fetch origin
git rebase origin/main
git push -u origin feature/nome-branch
