# Guide de Dual Boot : Windows/Linux et Compatibilité Valorant

## Le Problème

Vous souhaitez configurer un dual boot (probablement Windows/Linux) pour mieux travailler, mais vous êtes préoccupé par la compatibilité avec Valorant à cause de l'anti-cheat Vanguard.

## La Solution

Oui, il existe des solutions ! Voici vos options :

### Option 1 : Dual Boot Windows/Linux (Recommandé)

**Configuration idéale :**
- Windows 11 (pour Valorant)
- Linux (pour le développement et le travail)

**Étapes pour maintenir la compatibilité Valorant :**

1. **Installer Windows en premier**
   - Activez Secure Boot dans le BIOS/UEFI
   - Activez TPM 2.0 (requis par Vanguard)
   - Installez Windows normalement

2. **Installer Linux en second**
   - Utilisez une distribution compatible avec Secure Boot (Ubuntu 22.04 LTS+, Fedora, etc.)
   - Installez Linux en mode UEFI (pas Legacy)
   - Le bootloader (GRUB) s'installera automatiquement

3. **Configuration du Secure Boot pour Linux**
   - La plupart des distributions modernes supportent Secure Boot
   - Ubuntu et Fedora ont des shims signés par Microsoft
   - Pas besoin de désactiver Secure Boot !

**Avantages :**
- Valorant fonctionne parfaitement sur Windows
- Environnement Linux complet pour le développement
- Neovim avec toutes ses fonctionnalités sur Linux

### Option 2 : Machine Virtuelle

**Pour le travail :**
- Installez VirtualBox ou VMware sur Windows
- Créez une VM Linux pour le développement
- Utilisez Neovim dans la VM Linux

**Avantages :**
- Pas besoin de redémarrer entre systèmes
- Valorant reste fonctionnel sur Windows
- Peut être plus lent qu'un dual boot natif

**Inconvénients :**
- Performance réduite dans la VM
- Consommation mémoire plus élevée

### Option 3 : WSL2 (Windows Subsystem for Linux)

**Solution moderne et pratique :**
```bash
# Sur Windows, installer WSL2
wsl --install
```

**Avantages :**
- Pas de dual boot nécessaire
- Linux et Windows en même temps
- Neovim fonctionne parfaitement dans WSL2
- Valorant fonctionne sur Windows hôte
- Performance proche du natif

**Configuration Neovim dans WSL2 :**
```bash
# Dans WSL2
sudo apt update
sudo apt install neovim
# Clonez cette configuration Neovim
git clone https://github.com/selevray/Nvim ~/.config/nvim
```

**Inconvénients :**
- Pas un "vrai" Linux (mais très proche)
- Quelques limitations pour les applications GUI (résolu avec WSLg)

## Recommandation Finale

**Pour votre cas (travail + Valorant) :**

Je recommande **WSL2** comme première option :
- Pas besoin de redémarrer
- Valorant fonctionne sans problème
- Excellent environnement de développement
- Neovim fonctionne parfaitement

**Si WSL2 ne suffit pas**, optez pour un **dual boot Windows/Linux** :
- Gardez Secure Boot et TPM activés
- Utilisez Ubuntu 22.04 LTS ou Fedora (compatible Secure Boot)
- Valorant fonctionnera sur Windows
- Linux pour le développement sérieux

## Configuration Post-Installation

### Pour WSL2
```bash
# Installer les dépendances Neovim
sudo apt install git curl build-essential

# Cloner cette configuration
cd ~
git clone https://github.com/selevray/Nvim ~/.config/nvim

# Lancer Neovim
nvim
```

### Pour Dual Boot
1. Démarrez sur Windows quand vous voulez jouer à Valorant
2. Démarrez sur Linux pour travailler avec Neovim
3. Le changement se fait au démarrage via GRUB

## Vérification de Compatibilité Valorant

Sur Windows, vérifiez que :
- Secure Boot est activé : `msinfo32` → cherchez "État du démarrage sécurisé"
- TPM 2.0 est activé : `tpm.msc`
- Vanguard fonctionne : Lancez Valorant

## Ressources Supplémentaires

- [Documentation WSL2](https://learn.microsoft.com/en-us/windows/wsl/)
- [Guide Ubuntu Dual Boot](https://ubuntu.com/tutorials/install-ubuntu-desktop)
- [Valorant Vanguard Requirements](https://support-valorant.riotgames.com/)

## Questions Fréquentes

**Q : Est-ce que je peux jouer à Valorant sur Linux ?**
A : Non, Valorant ne fonctionne pas sur Linux à cause de Vanguard (anti-cheat kernel-level).

**Q : Le dual boot va-t-il casser Valorant ?**
A : Non, tant que vous gardez Secure Boot et TPM activés et que vous utilisez un bootloader compatible (GRUB avec shim signé).

**Q : WSL2 est-il suffisant pour le développement ?**
A : Oui ! WSL2 offre un environnement Linux complet et est excellent pour le développement.

---

*Ce guide fait partie de la configuration Neovim. Pour des questions spécifiques, consultez la documentation de votre distribution Linux.*
