-- ============================================
-- QUÊTE 5.3 : Afficher les clients ayant effectué au moins deux locations
-- Notions : SELECT, JOIN, GROUP BY, HAVING, COUNT
-- ============================================

SELECT 
    c.id_client,
    CONCAT(c.prenom, ' ', c.nom) AS Client,
    COUNT(l.id_location) AS Nombre_de_locations
FROM client c
JOIN location l ON c.id_client = l.id_client
GROUP BY c.id_client, c.nom, c.prenom
HAVING COUNT(l.id_location) >= 2
ORDER BY COUNT(l.id_location) DESC;
