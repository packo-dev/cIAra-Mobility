-- ============================================
-- QUÊTE 4.3 : Afficher l'autonomie moyenne des véhicules
-- Notions : SELECT, AVG
-- ============================================

SELECT ROUND(AVG(autonomie_km), 2) AS "Autonomie moyenne (km)"
FROM vehicule;
