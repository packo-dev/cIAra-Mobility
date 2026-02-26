-- ============================================
-- QUÊTE 5.4 : Afficher les véhicules n'ayant jamais été loués
-- Notions : SELECT, LEFT JOIN, WHERE IS NULL
-- ============================================

SELECT 
    v.id_vehicule,
    CONCAT(v.marque, ' ', v.modele) AS Vehicule,
    v.immatriculation AS Immatriculation,
    v.localisation AS Ville
FROM vehicule v
LEFT JOIN location l ON v.id_vehicule = l.id_vehicule
WHERE l.id_location IS NULL;
