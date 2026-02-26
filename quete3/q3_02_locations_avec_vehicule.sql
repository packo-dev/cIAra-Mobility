-- ============================================
-- QUÊTE 3.2 : Afficher la liste des locations avec la marque et le modèle du véhicule
-- Notions : SELECT, FROM, JOIN
-- ============================================

SELECT 
    l.id_location,
    l.date_debut,
    l.date_fin,
    CONCAT(v.marque, ' ', v.modele) AS Vehicule,
    v.immatriculation
FROM location l
JOIN vehicule v ON l.id_vehicule = v.id_vehicule;
