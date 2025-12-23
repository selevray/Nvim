# Configuration Neovim

Configuration personnalisée de Neovim avec lazy.nvim et fonctionnalités avancées.

## Installation

### Prérequis
- Neovim >= 0.8.0
- Git

### Installation rapide

```bash
# Cloner la configuration
git clone https://github.com/selevray/Nvim ~/.config/nvim

# Lancer Neovim (les plugins s'installeront automatiquement)
nvim
```

## Fonctionnalités

- **Gestionnaire de plugins** : lazy.nvim
- **Liste de fonctions** : Affichage automatique des fonctions du fichier courant
- **Configuration personnalisée** : Raccourcis et options optimisés
- **Dashboard personnalisé** : Interface d'accueil

## Structure

```
nvim/
├── init.lua                    # Point d'entrée principal
├── lazy-lock.json             # Versions des plugins
└── lua/
    ├── myspace/               # Configuration personnalisée
    │   ├── dashboard.lua      # Dashboard d'accueil
    │   ├── function_list.lua  # Gestion de la liste des fonctions
    │   ├── function_lines.lua # Analyse des lignes de fonctions
    │   ├── keymaps.lua        # Raccourcis clavier
    │   └── zlx_shortcuts.lua  # Raccourcis supplémentaires
    └── plugins/
        └── init.lua           # Configuration des plugins
```

## Configuration

Les options de base sont définies dans `init.lua` :
- Numéros de ligne activés
- Tabulation : 4 espaces
- Mise à jour automatique de la liste des fonctions

## Dual Boot et Compatibilité

Si vous souhaitez installer un dual boot pour travailler avec Linux tout en conservant la possibilité de jouer à Valorant, consultez le [Guide de Dual Boot](DUAL_BOOT_GUIDE.md).

## Contribution

N'hésitez pas à ouvrir une issue ou une pull request pour améliorer cette configuration.

## Licence

Cette configuration est libre d'utilisation et de modification.
