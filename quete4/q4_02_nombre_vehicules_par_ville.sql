-- ============================================
-- QUÊTE 4.2 : Afficher le nombre de véhicules par ville
-- Notions : SELECT, COUNT, GROUP BY
-- ============================================

SELECT 
    localisation AS "Ville",
    COUNT(*) AS "Nombre de véhicules"
FROM vehicule
GROUP BY localisation
ORDER BY COUNT(*) DESC;
