-- ============================================
-- QUÊTE 2.2 : Afficher les véhicules disponibles, triés par ville puis par marque
-- Notions : SELECT, FROM, WHERE, ORDER BY (multiple)
-- ============================================

SELECT *
FROM vehicule
WHERE etat = 'Disponible'
ORDER BY localisation, marque;
