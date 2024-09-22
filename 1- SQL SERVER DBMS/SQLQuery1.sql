-- =========================================
-- 1. Retrieval Operations (READ) 
-- =========================================

SELECT * FROM Traffic_Sensors
WHERE Status = 'Active';

SELECT * FROM Traffic_Logs
WHERE SensorID = 'sensor_2' AND LogDate = '2014-01-01'


SELECT * FROM Incidents
WHERE City = 'BLOOMINGTON' AND RoadwayID = '  1ST AVE';

SELECT ts.RoadwayID, SUM(tl.VehicleCount) AS TotalVehicles
FROM Traffic_Sensors ts
JOIN Traffic_Logs tl ON ts.SensorID = tl.SensorID
GROUP BY ts.RoadwayID;

SELECT ts.SensorID, AVG(tl.AverageSpeed) AS AvgSpeed
FROM Traffic_Sensors ts
JOIN Traffic_Logs tl ON ts.SensorID = tl.SensorID
GROUP BY ts.SensorID;

SELECT PrimaryFactor, COUNT(*) AS IncidentCount
FROM Incidents
GROUP BY PrimaryFactor
ORDER BY IncidentCount DESC;

-- =========================================
-- 2. Update Operations (UPDATE) 
-- =========================================

UPDATE Traffic_Sensors
SET Status = 'Inactive'
WHERE SensorID = 'Sensr_3';

UPDATE Traffic_Logs
SET AverageSpeed = 48.0
WHERE LogID = 1;

UPDATE Incidents
SET Injuries = Injuries + 1
WHERE IncidentID = 2;

-- =========================================
-- 3. Deletion Operations (DELETE) 
-- =========================================

DELETE FROM Traffic_Sensors
WHERE SensorID = 'Sensor_3';

DELETE FROM Traffic_Logs
WHERE LogDate < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

DELETE FROM Incidents
WHERE Injuries = 0 AND Fatalities = 0;

-- =========================================
-- 4. Advanced Queries 
-- =========================================

SELECT ts.RoadwayID, SUM(tl.VehicleCount) AS TotalVehicles
FROM Traffic_Sensors ts
JOIN Traffic_Logs tl ON ts.SensorID = tl.SensorID
GROUP BY ts.RoadwayID
ORDER BY TotalVehicles DESC
LIMIT 5;

SELECT City, HOUR(LogTime) AS Hour, SUM(VehicleCount) AS TotalVehicles
FROM Traffic_Sensors ts
JOIN Traffic_Logs tl ON ts.SensorID = tl.SensorID
GROUP BY City, Hour
ORDER BY City, TotalVehicles DESC;

SELECT WeatherCondition, COUNT(*) AS IncidentCount
FROM Incidents
GROUP BY WeatherCondition
ORDER BY IncidentCount DESC;

SELECT ts.SensorID, ts.RoadwayID, COUNT(tl.LogID) AS LogCount
FROM Traffic_Sensors ts
JOIN Traffic_Logs tl ON ts.SensorID = tl.SensorID
WHERE tl.LogDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
GROUP BY ts.SensorID, ts.RoadwayID
HAVING LogCount < 10;

SELECT Agency, AVG(Injuries + Fatalities) AS AvgSeverity
FROM Incidents
GROUP BY Agency
ORDER BY AvgSeverity DESC;

-- =========================================
-- 5. Stored Procedures and Functions  
-- =========================================

DELIMITER //
CREATE PROCEDURE AddTrafficSensor (
    IN p_SensorID VARCHAR(50),
    IN p_RoadwayID VARCHAR(50),
    IN p_City VARCHAR(100),
    IN p_SensorType VARCHAR(50),
    IN p_Status VARCHAR(20)
)
BEGIN
    INSERT INTO Traffic_Sensors (SensorID, RoadwayID, City, SensorType, Status)
    VALUES (p_SensorID, p_RoadwayID, p_City, p_SensorType, p_Status);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION TotalIncidents(city_name VARCHAR(100)) RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Incidents
    WHERE City = city_name;
    RETURN total;
END //
DELIMITER ;

-- =========================================
-- 6. Transactions Example 
-- =========================================

START TRANSACTION;

    UPDATE Traffic_Sensors
    SET Status = 'Inactive'
    WHERE SensorID = 'S002';

    INSERT INTO Status_Logs (SensorID, ChangeDate, OldStatus, NewStatus, ChangedBy)
    VALUES ('S002', NOW(), 'Active', 'Inactive', 'Admin');

COMMIT;

-- =========================================
-- 10. Views for Simplified Data Access
-- =========================================

CREATE VIEW SensorLatestLog AS
SELECT ts.SensorID, ts.RoadwayID, ts.City, ts.SensorType, ts.Status,
       tl.LogDate, tl.LogTime, tl.VehicleCount, tl.AverageSpeed
FROM Traffic_Sensors ts
JOIN Traffic_Logs tl ON ts.SensorID = tl.SensorID
WHERE (ts.SensorID, tl.LogDate, tl.LogTime) IN (
    SELECT SensorID, MAX(LogDate), MAX(LogTime)
    FROM Traffic_Logs
    GROUP BY SensorID
);

CREATE VIEW IncidentSummaryByCity AS
SELECT City, COUNT(*) AS TotalIncidents,
       SUM(VehiclesInvolved) AS TotalVehiclesInvolved,
       SUM(Injuries) AS TotalInjuries,
       SUM(Fatalities) AS TotalFatalities
FROM Incidents
GROUP BY City;