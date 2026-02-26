-- ============================================
-- QUÊTE 3.1 : Afficher la liste des locations avec le nom et le prénom du client
-- Notions : SELECT, FROM, JOIN
-- ============================================

SELECT 
    l.id_location,
    l.date_debut,
    l.date_fin,
    CONCAT(c.prenom, ' ', c.nom) AS Client
FROM location l
JOIN client c ON l.id_client = c.id_client;
