-- ============================================
-- QUÊTE 5.2 : Afficher la ville possédant le plus de véhicules disponibles
-- Notions : SELECT, WHERE, COUNT, GROUP BY, ORDER BY, LIMIT
-- ============================================

SELECT 
    localisation AS "Ville",
    COUNT(*) AS "Nombre de véhicules disponibles"
FROM vehicule
WHERE etat = 'Disponible'
GROUP BY localisation
ORDER BY COUNT(*) DESC
LIMIT 1;
