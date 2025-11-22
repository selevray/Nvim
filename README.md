# ZELOXX Neovim Configuration

Configuration Neovim personnalisée pour le développement, optimisée pour les étudiants 42 et le développement général.

## 📋 Table des matières

- [Installation](#installation)
- [Configuration Dual-Boot](#configuration-dual-boot)
- [Fonctionnalités](#fonctionnalités)
- [Raccourcis clavier](#raccourcis-clavier)

## 🚀 Installation

### Prérequis

- Neovim >= 0.9.0
- Git
- Un terminal avec support des couleurs vraies (true color)
- [Nerd Font](https://www.nerdfonts.com/) (recommandé pour les icônes)

### Installation rapide

```bash
# Cloner la configuration
git clone https://github.com/selevray/Nvim.git ~/.config/nvim

# Lancer Neovim
nvim
```

Au premier lancement, lazy.nvim téléchargera et installera automatiquement tous les plugins.

## 🖥️ Configuration Dual-Boot

### Pourquoi un dual-boot ?

Un dual-boot Windows/Linux est idéal pour :
- **Développement** : Profiter de l'environnement Linux pour coder (meilleurs outils, performance, workflow)
- **Gaming** : Garder Windows pour les jeux avec anti-cheat
- **Flexibilité** : Le meilleur des deux mondes

### Le problème Valorant et la solution

**Le problème** : Valorant utilise Vanguard, un anti-cheat au niveau kernel qui :
- Ne fonctionne PAS sur Linux (même avec Wine/Proton)
- Nécessite Windows pour jouer

**La solution : Dual-Boot** 🎯

Un dual-boot vous permet de :
1. **Booter sur Linux** pour travailler/coder avec cette config Neovim
2. **Redémarrer sur Windows** quand vous voulez jouer à Valorant

### Guide de mise en place du Dual-Boot

#### Étape 1 : Préparation Windows

1. **Sauvegardez vos données importantes** (disque externe, cloud)
2. Ouvrez "Gestion des disques" (`diskmgmt.msc`)
3. Réduisez votre partition Windows (au minimum 50-100 GB pour Linux)
   - Clic droit sur C: → "Réduire le volume"
   - Laissez au moins 150 GB pour Windows + jeux

#### Étape 2 : Installation Linux

Recommandations de distributions :
- **Ubuntu 22.04 LTS** ou **24.04 LTS** : Facile, stable, bien documenté
- **Pop!_OS** : Basé sur Ubuntu, optimisé pour gaming et développement
- **Fedora** : Moderne, à jour, excellent pour le développement

1. Téléchargez l'ISO de votre distribution
2. Créez une clé USB bootable avec [Rufus](https://rufus.ie/) (Windows) ou [balenaEtcher](https://www.balena.io/etcher/)
3. Redémarrez et bootez sur la clé USB (F12, F2, ou DEL selon votre PC)
4. Suivez l'installation, choisissez "Installer à côté de Windows" ou "Autre chose"
5. Créez vos partitions :
   - `/` (root) : 40-60 GB minimum
   - `/home` : Le reste de l'espace
   - `swap` : Égal à votre RAM si < 8GB, sinon 8GB suffisent

#### Étape 3 : Configuration post-installation

```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y  # Ubuntu/Debian
# ou
sudo dnf update -y  # Fedora

# Installation de Neovim
sudo apt install neovim git build-essential -y  # Ubuntu
# ou
sudo dnf install neovim git @development-tools -y  # Fedora

# Cloner cette configuration
git clone https://github.com/selevray/Nvim.git ~/.config/nvim
```

### Basculer entre OS

Au démarrage de votre PC, le bootloader GRUB apparaît automatiquement :
- **Par défaut** : Linux démarre
- **Pour Windows** : Sélectionnez "Windows Boot Manager" dans le menu GRUB
- **Pour changer le défaut** : Éditez `/etc/default/grub` et changez `GRUB_DEFAULT`

### Partage de fichiers entre Windows et Linux

```bash
# Linux peut lire les partitions Windows (NTFS)
# Monter automatiquement la partition Windows
sudo mkdir /mnt/windows
sudo mount /dev/nvme0n1p3 /mnt/windows  # Adaptez selon votre partition

# Ou ajoutez dans /etc/fstab pour montage automatique
```

**Astuce** : Créez une partition NTFS séparée pour vos projets et documents partagés !

### Optimisations pour le développement sous Linux

```bash
# Installation d'outils de développement supplémentaires
sudo apt install curl wget ripgrep fd-find fzf -y

# Configuration de Git (si pas déjà fait)
git config --global user.name "Votre Nom"
git config --global user.email "votre@email.com"
```

## ✨ Fonctionnalités

Cette configuration Neovim inclut :

- **Dashboard personnalisé** avec ASCII art ZELOXX
- **Catppuccin Mocha theme** pour une interface élégante
- **Neo-tree** : Explorateur de fichiers avec icônes
- **Telescope** : Recherche fuzzy de fichiers et contenu
- **Treesitter** : Coloration syntaxique avancée et indentation
- **42norm.nvim** : Intégration complète des normes 42
  - Header automatique
  - Formatage sur sauvegarde
  - Vérification de la norminette
- **Undotree** : Historique d'annulation visuel
- **Autopairs** : Fermeture automatique des parenthèses/quotes
- **Which-key** : Affichage des raccourcis disponibles
- **Indent Blankline** : Guides d'indentation visuels
- **Fonction list** : Panneau latéral listant les fonctions du fichier courant

## ⌨️ Raccourcis clavier

### Dashboard (écran d'accueil)

| Touche | Action |
|--------|--------|
| `f` | Rechercher des fichiers |
| `e` | Ouvrir Neo-tree (explorateur) |
| `n` | Nouveau fichier |
| `r` | Fichiers récents |
| `s` | Raccourcis personnalisés |
| `c` | Ouvrir le dossier de configuration Neovim |
| `l` | Ouvrir Lazy (gestionnaire de plugins) |
| `q` | Quitter |

### Édition

| Raccourci | Action |
|-----------|--------|
| `<Tab><Tab>` | Toggle Neo-tree (fichiers C, C++, Lua, Python, JS) |
| `<F1>` | Insérer header 42 |
| `<F2>` | Formater selon 42norm |
| `<F5>` | Lancer la norminette |
| `<C-f>` | Formater le buffer avec 42norm |
| `<leader>u` | Toggle Undotree |
| `<leader>U` | Ouvrir et focus Undotree |

### 42norm

Cette configuration utilise [42norm.nvim](https://github.com/MoulatiMehdi/42norm.nvim) avec :
- Header automatique sur nouveau fichier (désactivable)
- Formatage automatique à la sauvegarde
- Vérification en temps réel

## 🎮 FAQ Dual-Boot & Gaming

### Puis-je jouer à d'autres jeux sous Linux ?

Oui ! Grâce à **Proton** (intégré à Steam), de nombreux jeux Windows fonctionnent sur Linux :
- La plupart des jeux Steam
- [ProtonDB](https://www.protondb.com/) liste la compatibilité

**Exceptions** : Jeux avec anti-cheat kernel (Valorant, League of Legends ranked, etc.)

### Quelle quantité d'espace pour Linux ?

- **Minimum** : 40 GB (système + config Neovim + outils de base)
- **Recommandé** : 100-150 GB (pour vos projets 42, compilations, etc.)
- **Idéal** : 200 GB+ si vous voulez installer quelques jeux Linux

### Le dual-boot ralentit-il mon PC ?

Non ! Chaque OS utilise ses propres ressources. Seul l'espace disque est partagé.

### Comment désinstaller le dual-boot si besoin ?

1. Bootez sur Windows
2. Utilisez "Gestion des disques" pour supprimer les partitions Linux
3. Étendez la partition Windows pour récupérer l'espace
4. Réparez le bootloader Windows avec une clé USB d'installation Windows

## 🔧 Dépannage

### Neovim ne démarre pas

```bash
# Réinstaller les plugins
rm -rf ~/.local/share/nvim
nvim
```

### Les icônes ne s'affichent pas

Installez une Nerd Font :
```bash
# Exemple avec JetBrainsMono Nerd Font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv
```

Puis configurez votre terminal pour utiliser cette police.

### GRUB ne montre pas Windows

```bash
sudo update-grub  # Ubuntu/Debian
# ou
sudo grub2-mkconfig -o /boot/grub2/grub.cfg  # Fedora
```

## 📝 Licence

Configuration personnelle - Libre d'utilisation et de modification.

## 🤝 Contribution

N'hésitez pas à ouvrir des issues ou des pull requests pour améliorer cette configuration !

---

**Bon code et bon gaming ! 🚀🎮**
