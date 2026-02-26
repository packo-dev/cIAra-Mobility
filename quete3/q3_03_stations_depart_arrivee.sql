-- ============================================
-- QUÊTE 3.3 : Afficher la station de départ et la station d'arrivée pour chaque location
-- Notions : SELECT, FROM, JOIN (multiple sur même table), alias de tables
-- ============================================

SELECT 
    l.id_location,
    l.date_debut,
    l.date_fin,
    CONCAT(d.nom, ' - ', d.ville) AS Station_Depart,
    CONCAT(a.nom, ' - ', a.ville) AS Station_Arrivee
FROM location l
JOIN station d ON l.id_station_depart = d.id_station
LEFT JOIN station a ON l.id_station_arrivee = a.id_station;
