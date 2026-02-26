-- ============================================
-- QUÊTE 4.4 : Afficher le nombre de locations effectuées par client
-- Notions : SELECT, COUNT, JOIN, GROUP BY
-- ============================================

SELECT 
    c.id_client,
    CONCAT(c.prenom, ' ', c.nom) AS Client,
    COUNT(l.id_location) AS Nombre_de_locations
FROM client c
JOIN location l ON c.id_client = l.id_client
GROUP BY c.id_client, c.nom, c.prenom
ORDER BY COUNT(l.id_location) DESC;
