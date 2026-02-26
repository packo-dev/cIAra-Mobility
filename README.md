# Projet SQL B1 - cIAra Mobility

**Membres du binôme :**
- Ethan BROSSIER (Bachelor 1)
- Elif YAKUT (Bachelor 1)

---

## Sommaire

1. Contexte du projet
2. Structure de la base de données
3. Rapport d'Analyse Technique
   - A. Organisation du travail en binôme
   - B. Analyse du Modèle de Données
   - C. Choix Techniques et Syntaxe SQL
   - D. Difficultés rencontrées et Solutions

---

## Contexte du projet

L'entreprise **cIAra Mobility** est une société spécialisée dans la location de véhicules électriques partagés (voitures, scooters, trottinettes et vélos électriques) dans plusieurs grandes villes françaises.

Notre mission en tant que techniciens data juniors consiste à interroger la base de données de l'entreprise pour répondre à des besoins métier concrets à travers **5 quêtes SQL** progressives.

---

## Structure de la base de données

### Vue d'ensemble

La base de données contient **4 tables principales** :

| Table | Description | Nombre d'enregistrements |
|-------|-------------|-------------------------|
| station | Stations de location/restitution | 23 stations |
| vehicule | Flotte de véhicules électriques | 200 véhicules |
| client | Clients inscrits | 20 clients |
| location | Historique des locations | 25 locations |

### Schéma des tables

#### Table `station`

```sql
CREATE TABLE station (
    id_station SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    ville VARCHAR(50) NOT NULL
);
```

**Villes couvertes :** Paris, Lyon, Marseille, Toulouse, Bordeaux, Lille, Nice, Montpellier, Strasbourg, Nantes

#### Table `vehicule`

```sql
CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    marque VARCHAR(50) NOT NULL,
    modele VARCHAR(50) NOT NULL,
    annee INTEGER NOT NULL,
    energie VARCHAR(20) NOT NULL,
    autonomie_km INTEGER NOT NULL,
    immatriculation VARCHAR(20) NOT NULL UNIQUE,
    etat VARCHAR(20) NOT NULL,
    localisation VARCHAR(50) NOT NULL
);
```

**Marques disponibles :** Tesla, Renault, Peugeot, Citroen, Mercedes, BMW, Volkswagen, Hyundai, Kia, Nissan, Toyota, Fiat
**États possibles :** Disponible, En service, En maintenance, Hors service

#### Table `client`

```sql
CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);
```

#### Table `location`

```sql
CREATE TABLE location (
    id_location SERIAL PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin DATE,
    id_client INTEGER NOT NULL,
    id_vehicule INTEGER NOT NULL,
    id_station_depart INTEGER NOT NULL,
    id_station_arrivee INTEGER,
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_vehicule) REFERENCES vehicule(id_vehicule),
    FOREIGN KEY (id_station_depart) REFERENCES station(id_station),
    FOREIGN KEY (id_station_arrivee) REFERENCES station(id_station)
);
```

### Relations entre les tables

```
┌─────────┐
│ client  │
└────┬────┘
     │
     │ id_client (FK)
     │
     ▼
┌──────────┐      id_vehicule (FK)     ┌──────────┐
│ location │◄─────────────────────────│ vehicule │
└────┬─────┘                          └──────────┘
     │
     │ id_station_depart (FK)
     │ id_station_arrivee (FK)
     │
     ▼
┌─────────┐
│ station │
└─────────┘
```

---

## Rapport d'Analyse Technique

### A. Organisation du travail en binôme

#### Méthodologie de travail

Nous avons adopté une approche de **travail en autonomie avec entraide ponctuelle** :

- **Travail individuel** : Chacun a réalisé ses quêtes de manière autonome
- **Entraide sur demande** : Nous nous sommes mutuellement aidés lorsque l'un rencontrait une erreur ou avait une question
- **Validation croisée** : Vérification des requêtes de l'autre membre

**Répartition des tâches :**
- **Ethan BROSSIER** : Quêtes 1, 2 et 4 (requêtes de base, filtres, tris, agrégations simples)
- **Elif YAKUT** : Quêtes 3 et 5 (jointures complexes, LEFT JOIN, HAVING) + création de la base de données

#### Gestion de version (Git/GitHub)

**Workflow Git :**
- **Fréquence des commits** : À la fin de chaque quête terminée
- **Nommage des commits** : Format standardisé "réalisation de la quête X"
- **Gestion des branches** : Travail directement sur la branche `main`
- **Synchronisation** : Commits réguliers après validation des requêtes

#### Environnement de travail

**Configuration technique :**
- **SGBD** : PostgreSQL
- **Interfaces** : pgAdmin 4 / SQL Tools (extension VS Code)
- **Éditeur** : Visual Studio Code
- **Système d'exploitation** : Windows

---

### B. Analyse du Modèle de Données (MCD)

#### Structure de la base

La base de données suit une **architecture relationnelle normalisée** avec 4 tables interconnectées :

**1. Tables de référence** (données relativement stables) :
- **`station`** : 23 points de retrait/dépôt répartis dans 10 villes
- **`vehicule`** : 200 véhicules électriques de différentes marques
- **`client`** : 20 clients enregistrés avec leurs informations de contact

**2. Table transactionnelle** (données évolutives) :
- **`location`** : Enregistre chaque transaction de location avec ses dates, véhicule, client et stations

#### Relations entre les tables

**Clés primaires :**
- Chaque table possède une clé primaire auto-incrémentée (`id_*`) générée par `SERIAL`
- Garantit l'unicité de chaque enregistrement

**Clés étrangères dans la table `location` :**

1. **`id_client`** → `client.id_client`
   - *Répond à la question* : Quel client a effectué cette location ?

2. **`id_vehicule`** → `vehicule.id_vehicule`
   - *Répond à la question* : Quel véhicule a été loué ?

3. **`id_station_depart`** → `station.id_station`
   - *Répond à la question* : Où le véhicule a-t-il été récupéré ?

4. **`id_station_arrivee`** → `station.id_station` *(peut être NULL)*
   - *Répond à la question* : Où le véhicule a-t-il été déposé ?
   - **Valeur NULL** : Indique que la location est **toujours en cours**

**Cardinalités :**
- Un client peut avoir **plusieurs locations** (relation 1:N)
- Un véhicule peut être loué **plusieurs fois** (relation 1:N)
- Une station peut être **point de départ ou d'arrivée** pour plusieurs locations (relation 1:N)

---

### C. Choix Techniques et Syntaxe SQL

#### Stratégie de construction des requêtes

Nous avons adopté une **approche progressive et méthodique** :

1. **Analyse du besoin métier** : Comprendre exactement ce qui est demandé
2. **Identification des tables** : Déterminer quelles tables contiennent les informations nécessaires
3. **Requête de base** : Commencer par un `SELECT * FROM table` simple
4. **Ajout des filtres** : Utiliser `WHERE` pour filtrer les données
5. **Jointures si nécessaire** : Ajouter les `JOIN` pour relier plusieurs tables
6. **Agrégations et groupements** : Utiliser `GROUP BY` et fonctions d'agrégation
7. **Tri et limitation** : Ajouter `ORDER BY` et `LIMIT`
8. **Tests et validation** : Vérifier que les résultats correspondent au besoin

#### Justification des commandes SQL utilisées

##### 1. Types de JOIN utilisés

**INNER JOIN (Quête 3)** :

Utilisé pour **relier les locations aux clients et véhicules** car nous voulions uniquement afficher les locations qui ont **effectivement** un client **ET** un véhicule associés.

```sql
SELECT 
    (prenom || ' ' || nom) AS Client,
    location.*
FROM client   
JOIN location ON client.id_client = location.id_client;
```

**LEFT JOIN (Quête 5)** :

Pour trouver les **véhicules jamais loués**, nous avons utilisé `LEFT JOIN` car nous voulions **TOUS les véhicules**, même ceux qui n'ont **aucune location** correspondante.

```sql
SELECT 
    vehicule.id_vehicule, 
    (vehicule.marque || ' ' || vehicule.modele) AS "Véhicule"
FROM vehicule 
LEFT JOIN location ON vehicule.id_vehicule = location.id_vehicule
WHERE location.id_location IS NULL;
```

**Différence critique :**
- `INNER JOIN` → Seulement ce qui existe dans **les deux tables**
- `LEFT JOIN` → Tout ce qui existe dans la **table de gauche**, même sans correspondance

##### 2. Utilisation d'alias de tables

Pour afficher les **stations de départ ET d'arrivée** d'une location, nous devions joindre la table `station` **deux fois** :

```sql
SELECT
    d.nom || ' - ' || d.ville AS "Station de Départ",
    a.nom || ' - ' || a.ville AS "Station d'Arrivée"
FROM location
JOIN station AS d ON d.id_station = location.id_station_depart
LEFT JOIN station AS a ON a.id_station = location.id_station_arrivee;
```

- `d` et `a` sont des **alias différents** pour la même table `station`
- `d` (départ) se joint sur `id_station_depart`
- `a` (arrivée) se joint sur `id_station_arrivee`

##### 3. GROUP BY et Fonctions d'agrégation

**GROUP BY (Quête 4/5)** :

```sql
SELECT 
    localisation AS Ville, 
    COUNT(*) AS "Nombre de Véhicule Disponible"
FROM vehicule
WHERE etat = 'Disponible'
GROUP BY localisation
ORDER BY "Nombre de Véhicule Disponible" DESC
LIMIT 1;
```

**HAVING (Quête 5)** :

Contrairement à `WHERE` qui filtre les **lignes individuelles**, `HAVING` filtre les **groupes** après agrégation.

```sql
SELECT 
    client.id_client, 
    (client.prenom || ' ' || client.nom) AS "Client",
    COUNT(location.id_location) AS "Nombre de Location"
FROM client 
JOIN location ON client.id_client = location.id_client
GROUP BY client.id_client, client.nom, client.prenom
HAVING COUNT(location.id_location) >= 2
ORDER BY COUNT(location.id_location) DESC;
```

**Différence WHERE vs HAVING :**

| Critère | WHERE | HAVING |
|---------|-------|--------|
| **Moment d'application** | AVANT le regroupement | APRÈS le regroupement |
| **Filtre sur** | Lignes individuelles | Groupes agrégés |
| **Peut utiliser fonctions d'agrégation** | NON | OUI |
| **Position dans la requête** | Avant GROUP BY | Après GROUP BY |

**Ordre d'exécution SQL :**

1. `FROM` / `JOIN` → Récupération et jonction des tables
2. `WHERE` → Filtrage des lignes
3. `GROUP BY` → Regroupement
4. `HAVING` → Filtrage des groupes
5. `SELECT` → Sélection des colonnes
6. `ORDER BY` → Tri
7. `LIMIT` → Limitation du nombre de résultats

---

### D. Difficultés rencontrées et Solutions

#### Difficulté 1 : Confusion WHERE vs HAVING

**Problème rencontré :**

```sql
SELECT client.nom, COUNT(*) 
FROM location 
JOIN client ON location.id_client = client.id_client
WHERE COUNT(*) >= 2  -- ERREUR
GROUP BY client.nom;
```

**Message d'erreur :**
```
ERROR: aggregate functions are not allowed in WHERE
```

**Solution :**

Utiliser `HAVING` pour filtrer sur des **fonctions d'agrégation** :

```sql
SELECT client.nom, COUNT(*) 
FROM location 
JOIN client ON location.id_client = client.id_client
GROUP BY client.nom
HAVING COUNT(*) >= 2;  -- CORRECT
```

#### Difficulté 2 : Jointure double sur la même table

**Problème :**

Pour afficher la **station de départ** ET la **station d'arrivée**, comment joindre la même table deux fois ?

**Solution :**

Utiliser des **alias de table** :

```sql
SELECT 
    d.nom AS "Station de Départ",
    a.nom AS "Station d'Arrivée"
FROM location l
JOIN station AS d ON l.id_station_depart = d.id_station
LEFT JOIN station AS a ON l.id_station_arrivee = a.id_station;
```

#### Difficulté 3 : Ordre des clauses SQL

**Problème :**

```sql
-- ERREUR : ORDER BY avant GROUP BY
SELECT localisation, COUNT(*) 
FROM vehicule
ORDER BY COUNT(*) DESC
GROUP BY localisation;
```

**Solution :**

Respecter l'**ordre obligatoire** des clauses SQL :

```sql
SELECT     -- 1
FROM       -- 2
JOIN       -- 3
WHERE      -- 4
GROUP BY   -- 5
HAVING     -- 6
ORDER BY   -- 7
LIMIT      -- 8
```

---

## Organisation du dépôt

```
cIAra-Mobility/
├── README.md
├── BDD/
│   └── 01_creation_base_donnees.sql
├── quete1/
│   ├── q1_01_tous_les_vehicules.sql
│   ├── q1_02_vehicules_disponibles.sql
│   ├── q1_03_vehicules_ville.sql
│   └── q1_04_vehicules_autonomie_400.sql
├── quete2/
│   ├── q2_01_vehicules_par_autonomie.sql
│   ├── q2_02_vehicules_disponibles_tries.sql
│   └── q2_03_clients_ordre_alphabetique.sql
├── quete3/
│   ├── q3_01_locations_avec_client.sql
│   ├── q3_02_locations_avec_vehicule.sql
│   └── q3_03_stations_depart_arrivee.sql
├── quete4/
│   ├── q4_01_nombre_total_vehicules.sql
│   ├── q4_02_nombre_vehicules_par_ville.sql
│   ├── q4_03_autonomie_moyenne.sql
│   └── q4_04_nombre_locations_par_client.sql
└── quete5/
    ├── q5_01_top3_autonomie_disponible.sql
    ├── q5_02_ville_plus_vehicules_disponibles.sql
    ├── q5_03_clients_min_2_locations.sql
    └── q5_04_vehicules_jamais_loues.sql
```

---

## Compétences développées

### Compétences SQL

- Compréhension d'un modèle relationnel normalisé
- Maîtrise des requêtes `SELECT` de base avec projections et filtres
- Utilisation des opérateurs de comparaison et logiques (`=`, `>`, `>=`, `AND`, `OR`)
- Utilisation des clauses de tri (`ORDER BY ASC/DESC`)
- Limitation des résultats avec `LIMIT`
- Réalisation de jointures internes (`INNER JOIN`)
- Réalisation de jointures externes (`LEFT JOIN`)
- Utilisation d'alias de tables pour jointures multiples sur la même table
- Utilisation des fonctions d'agrégation (`COUNT`, `AVG`)
- Regroupement de données avec `GROUP BY`
- Filtrage des groupes avec `HAVING`
- Concaténation de chaînes avec l'opérateur `||`
- Création d'alias de colonnes avec `AS`

### Compétences transversales

- Gestion de versions avec Git (commits, push, pull)
- Organisation du travail en binôme
- Rédaction de documentation technique
- Résolution de problèmes par la recherche
- Tests et débogage de requêtes SQL

---


