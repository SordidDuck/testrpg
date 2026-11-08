# TestRPG

Un RPG 3D fantasy low-poly en combat tour par tour, développé avec **Godot 3.5** et ciblé **PS Vita** (port Godot 3.5 de la scène homebrew).

## Caractéristiques

- **Overworld 3D** : village de Bourg-Feuille, forêt aux rencontres aléatoires, caméra 3ᵉ personne
- **Combat tour par tour** : Attaquer, Magie (Boule de feu), Objet (Potion), Fuir
- **Progression** : XP, niveaux, or, stats (PV/PM/ATK/DEF/MAG)
- **PNJ et dialogues** avec boîte de dialogue
- **Cristal de sauvegarde** au centre du village (sauvegarde sur `user://`)
- Rendu **GLES2**, résolution **960×544** (écran Vita), low-poly généré en code (aucun asset externe requis)

## Contrôles

| Action | Clavier | Vita |
|---|---|---|
| Déplacement | ZQSD / Flèches | Croix directionnelle |
| Tourner | Q / D (A / D) | Croix gauche / droite |
| Valider / Parler | E, Entrée, Espace | Croix |
| Annuler / Fuir menu | Échap, Retour | Rond |

## Structure du projet

```
project.godot           # Config GLES2, 960×544, autoloads
scenes/
  Main.tscn             # Écran-titre
  Overworld.tscn        # Monde extérieur
  Battle.tscn           # Arène de combat
scripts/
  input_setup.gd        # Mapping clavier + manette (autoload)
  game_state.gd         # Stats, inventaire, sauvegarde (autoload)
  main.gd               # Écran-titre
  overworld.gd          # Monde, PNJ, rencontres aléatoires
  player.gd             # Joueur, caméra 3ᵉ personne
  battle.gd             # Système de combat tour par tour
  dialogue.gd           # Boîte de dialogue
  enemies.gd            # Données des ennemis
  models.gd             # Modèles low-poly générés en code
  ui.gd                 # Helpers UI
```

## Tests

Un test headless simule un combat complet (attaque, tour ennemi, sauvegarde/chargement, victoire, XP) :

```
godot --headless --path . res://tests/TestBattle.tscn
```

Résultat attendu : `TEST OK`.

## Police

Le projet embarque **DejaVu Sans** (`assets/fonts/DejaVuSans.ttf`, licence libre — voir `assets/fonts/LICENSE`) pour garantir le rendu des accents français sur toutes les plateformes, y compris PS Vita.

## Lancer le projet

1. Ouvrir le dossier avec **Godot 3.5.x** (le port Vita ou la version standard).
2. Appuyer sur F5 (ou exporter vers la VITA via les modèles d'export du port).

## Notes PS Vita

- Le projet force **GLES2** (`rendering/quality/driver/driver_name`) : indispensable pour le port Vita.
- Les événements d'entrée sont mappés à la fois en clavier (flèches/Entrée, comme le fait le port Vita) et en boutons joypad (croix directionnelle, croix, rond).
- La sauvegarde utilise `user://`, redirigé par le port Vita vers les données de l'application.

## Roadmap

- [ ] Magies supplémentaires (soin, éclair)
- [ ] Boutique (acheter potions et équipement)
- [ ] Deuxième zone (grotte) avec boss
- [ ] Musique et sons
- [ ] Écran Game Over dédié
