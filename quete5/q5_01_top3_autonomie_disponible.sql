-- ============================================
-- QUÊTE 5.1 : Afficher les trois véhicules les plus autonomes actuellement disponibles
-- Notions : SELECT, WHERE, ORDER BY, LIMIT
-- ============================================

SELECT 
    CONCAT(marque, ' ', modele) AS Vehicule,
    immatriculation AS Immatriculation,
    autonomie_km AS Autonomie_km,
    localisation AS Ville
FROM vehicule
WHERE etat = 'Disponible'
ORDER BY autonomie_km DESC
LIMIT 3;
