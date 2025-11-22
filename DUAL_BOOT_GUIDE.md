# Guide Dual-Boot : Solution pour Valorant et Développement

## 🎯 Votre problème

Vous voulez :
- ✅ Bien travailler avec Linux et cette config Neovim
- ✅ Continuer à jouer à Valorant

**Le problème** : Valorant ne fonctionne PAS sur Linux à cause de Vanguard (anti-cheat)

**La solution** : DUAL-BOOT Windows + Linux ! 🚀

## 💡 Pourquoi c'est LA solution

Le dual-boot vous permet de :
1. **Travailler sur Linux** - Meilleur environnement de dev, cette config Neovim fonctionne parfaitement
2. **Jouer sur Windows** - Valorant fonctionne normalement, aucun problème avec Vanguard
3. **Choisir au démarrage** - Vous décidez quel OS lancer à chaque boot

### Vous ne perdez RIEN :
- ❌ Pas de virtualisation lente
- ✅ Dual-boot fiable et performant
- ✅ Performance native sur les deux OS
- ✅ Accès à tous vos fichiers depuis les deux OS

## 📝 Installation rapide du Dual-Boot

### Avant de commencer

⚠️ **IMPORTANT** : Sauvegardez vos données importantes !

### Étape 1 : Libérer de l'espace sur Windows (10 min)

1. Appuyez sur `Win + X` → "Gestion des disques"
2. Clic droit sur votre disque C: → "Réduire le volume"
3. Entrez la quantité à libérer :
   - **Minimum** : 50 000 MB (50 GB)
   - **Recommandé** : 100 000 MB (100 GB)
   - **Confortable** : 150 000 MB (150 GB)
4. Cliquez sur "Réduire"

Vous avez maintenant de l'espace "Non alloué" pour Linux !

### Étape 2 : Télécharger Linux (5 min)

Je recommande **Ubuntu 24.04 LTS** (facile, stable, bien documenté) :

1. Allez sur [ubuntu.com/download/desktop](https://ubuntu.com/download/desktop)
2. Téléchargez Ubuntu 24.04 LTS (environ 5 GB)

**Alternatives** :
- Pop!_OS : Excellent pour dev et gaming
- Linux Mint : Très ressemblant à Windows
- Fedora : Plus moderne, très bon pour le dev

### Étape 3 : Créer une clé USB bootable (5 min)

1. Téléchargez [Rufus](https://rufus.ie/)
2. Insérez une clé USB (8 GB minimum, sera effacée !)
3. Ouvrez Rufus :
   - Sélectionnez votre clé USB
   - Cliquez sur "SÉLECTION" et choisissez l'ISO Ubuntu
   - Laissez les autres paramètres par défaut
   - Cliquez sur "DÉMARRER"

### Étape 4 : Installer Linux (20-30 min)

1. **Redémarrez** votre PC avec la clé USB insérée
2. **Entrez dans le BIOS/Boot Menu** :
   - Appuyez sur `F12`, `F2`, `DEL`, ou `ESC` au démarrage (dépend de votre PC)
   - Marques courantes : Dell (F12), HP (ESC puis F9), Asus (F2/DEL), MSI (DEL)
3. **Sélectionnez** la clé USB dans le menu de boot
4. **Choisissez** "Try or Install Ubuntu"
5. **Suivez l'installation** :
   - Langue : Français
   - Disposition clavier : Français
   - **Type d'installation** : "Installer Ubuntu à côté de Windows Boot Manager" ⚠️ IMPORTANT
   - Utilisez le curseur pour répartir l'espace entre Windows et Linux
   - Créez votre utilisateur et mot de passe
   - Attendez l'installation

6. **Redémarrez** - GRUB (le menu de boot) s'affichera maintenant à chaque démarrage !

### Étape 5 : Configuration de Neovim sur Linux (5 min)

```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation de Neovim et outils nécessaires
sudo apt install neovim git build-essential curl wget ripgrep fd-find -y

# Installation de cette config Neovim
git clone https://github.com/selevray/Nvim.git ~/.config/nvim

# Lancer Neovim (les plugins s'installeront automatiquement)
nvim
```

## 🎮 Utilisation quotidienne

### Au démarrage du PC

Le menu **GRUB** s'affiche automatiquement :

```
GNU GRUB version 2.06

Ubuntu
Options avancées pour Ubuntu
Windows Boot Manager    ← Pour jouer à Valorant
UEFI Firmware Settings
```

- **Par défaut** : Ubuntu démarre après 10 secondes
- **Pour Windows** : Utilisez les flèches ↓↑ et appuyez sur Entrée sur "Windows Boot Manager"

### Workflow recommandé

**Pour coder/travailler** :
1. Démarrez sur Ubuntu (Linux)
2. Ouvrez votre terminal
3. `nvim` pour lancer Neovim avec cette config
4. Travaillez dans un environnement Linux optimal

**Pour jouer à Valorant** :
1. Redémarrez votre PC
2. Sélectionnez "Windows Boot Manager" dans GRUB
3. Lancez Valorant normalement

## 📁 Partager des fichiers entre Windows et Linux

### Option 1 : Accéder à Windows depuis Linux (automatique)

Linux peut lire vos fichiers Windows :

```bash
# Dans le gestionnaire de fichiers, vos partitions Windows apparaissent automatiquement
# Elles sont généralement montées dans /media/votre_utilisateur/
ls /media/$USER/  # Pour voir les partitions disponibles

# Ou trouvez votre partition Windows manuellement
lsblk -f  # Liste toutes les partitions
```

Dans le gestionnaire de fichiers Ubuntu (Files/Nautilus), vous verrez vos disques Windows automatiquement dans la barre latérale !

### Option 2 : Partition partagée (recommandé pour projets)

1. Sous Windows, créez une nouvelle partition NTFS de 50 GB
2. Nommez-la "Shared" ou "Projets"
3. Sous Linux ET Windows, mettez vos projets de code ici

Avantages : Accès depuis les deux OS sans redémarrer !

## 🔧 Configurations utiles

### Changer l'OS par défaut au démarrage

Si vous voulez que Windows démarre par défaut :

```bash
# Sous Linux
# D'abord, trouvez la position de Windows dans GRUB
grep -i windows /boot/grub/grub.cfg | grep menuentry
# Comptez les entrées depuis le début (la première est 0, la deuxième est 1, etc.)

# Éditez la configuration
sudo nano /etc/default/grub

# Trouvez la ligne GRUB_DEFAULT=0
# Changez-la en utilisant le nom exact ou le numéro de position
# Option 1 (recommandé) : GRUB_DEFAULT="Windows Boot Manager"
# Option 2 : GRUB_DEFAULT=N  (N est la position comptée ci-dessus, 0-indexed)
#   Exemple: si Windows est la 3ème entrée, utilisez GRUB_DEFAULT=2

# Sauvegardez (Ctrl+O, Entrée, Ctrl+X)
# Appliquez les changements
sudo update-grub
```

### Désactiver le timeout pour choisir à chaque fois

```bash
sudo nano /etc/default/grub

# Changez GRUB_TIMEOUT=10 en GRUB_TIMEOUT=-1
# Sauvegardez et exécutez :
sudo update-grub
```

## ❓ FAQ

### Est-ce que le dual-boot ralentit mon PC ?

**Non !** Chaque OS fonctionne de manière indépendante. Performances natives sur les deux.

### Puis-je supprimer le dual-boot plus tard ?

Oui, facilement :
1. Bootez sur Windows
2. Ouvrez "Gestion des disques"
3. Supprimez les partitions Linux
4. Étendez la partition Windows pour récupérer l'espace

### Combien d'espace pour Linux ?

- **42 + dev web** : 50-80 GB suffisent
- **42 + projets perso** : 100 GB recommandé
- **Dev + gaming Linux** : 150+ GB

### Valorant détecte-t-il que j'ai Linux installé ?

**Non.** Vanguard ne voit que Windows quand vous êtes sur Windows. Le dual-boot est transparent.

### Et les autres jeux avec anti-cheat ?

Même situation que Valorant :
- **Ne marchent PAS sur Linux** : Valorant, LoL ranked, Escape from Tarkov, Destiny 2
- **Marchent sur Linux** : La plupart des jeux Steam (CS2, Dota 2, Apex Legends, etc.)
- **Solution** : Jouez-y sur Windows avec le dual-boot !

### Puis-je aussi jouer sous Linux ?

Oui ! Steam avec Proton permet de jouer à des milliers de jeux Windows sur Linux.
Vérifiez la compatibilité sur [ProtonDB](https://www.protondb.com/).

### Le Secure Boot pose-t-il problème ?

Ubuntu gère le Secure Boot automatiquement. Si vous avez des soucis, désactivez-le dans le BIOS.

## 🚨 Dépannage

### GRUB ne s'affiche pas / Windows démarre directement

```bash
# Bootez sur la clé USB Ubuntu en mode "Try Ubuntu"
# Ouvrez un terminal et exécutez :
sudo add-apt-repository ppa:yannubuntu/boot-repair
sudo apt update
sudo apt install -y boot-repair
boot-repair
```

### Windows n'apparaît pas dans GRUB

```bash
sudo apt install os-prober
sudo os-prober
sudo update-grub
```

### "Échec du démarrage" après installation

Vérifiez que vous avez bien installé en mode UEFI ou BIOS (doit être cohérent avec Windows).
Utilisez Boot-Repair (voir ci-dessus).

## 🎓 Ressources supplémentaires

- [Documentation Ubuntu Française](https://doc.ubuntu-fr.org/)
- [Guide dual-boot détaillé](https://lecrabeinfo.net/installer-ubuntu-22-04-lts-en-dual-boot-avec-windows.html)
- [Forum Ubuntu-fr](https://forum.ubuntu-fr.org/)

## ✅ Récapitulatif

1. ✅ Libérez 50-150 GB sur Windows
2. ✅ Téléchargez Ubuntu (ou autre distro)
3. ✅ Créez une clé USB bootable avec Rufus
4. ✅ Installez Linux "à côté de Windows"
5. ✅ Au démarrage, choisissez Linux ou Windows dans GRUB
6. ✅ Installez cette config Neovim sur Linux
7. ✅ Codez sur Linux, jouez à Valorant sur Windows !

**C'est la meilleure solution pour avoir un environnement de dev optimal tout en gardant vos jeux !** 🚀

---

Besoin d'aide ? Ouvrez une issue sur ce repo !
