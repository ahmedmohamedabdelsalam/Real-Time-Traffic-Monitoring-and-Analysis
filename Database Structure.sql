create database Traffic;
use Traffic;

-- Table for traffic sensors and their details
CREATE TABLE Traffic_Sensors (
    SensorID VARCHAR(50) PRIMARY KEY, 
    RoadwayID VARCHAR(50) NOT NULL, 
    City VARCHAR(100) NOT NULL, 
    SensorType VARCHAR(50) NOT NULL,
    Status VARCHAR(20) NOT NULL, 
    CONSTRAINT UQ_RoadwayID UNIQUE (RoadwayID)
);

-- Table to log traffic data collected by the sensors
CREATE TABLE Traffic_Logs (
    LogID INT PRIMARY KEY, 
    SensorID VARCHAR(50), 
    LogDate DATE NOT NULL, 
    LogTime TIME NOT NULL,
    VehicleCount INT, 
    AverageSpeed DECIMAL(5, 2),
    FOREIGN KEY (SensorID) REFERENCES Traffic_Sensors(SensorID)
);

-- Table for incident reports and their related information
CREATE TABLE Incidents (
    IncidentID INT PRIMARY KEY, 
    Agency VARCHAR(50) NOT NULL, 
    City VARCHAR(100) NOT NULL, 
    IncidentDate DATE NOT NULL, 
    IncidentTime TIME NOT NULL, 
    VehiclesInvolved INT, 
    Injuries INT, 
    Fatalities INT, 
    RoadwayID VARCHAR(50),
    LightingCondition VARCHAR(50), 
    WeatherCondition VARCHAR(50), 
    SurfaceCondition VARCHAR(50), 
    RoadCharacteristics VARCHAR(50), 
    PrimaryFactor VARCHAR(100), 
    TrafficIncidentSpeed DECIMAL(5, 2), 
    FOREIGN KEY (RoadwayID) REFERENCES Traffic_Sensors(RoadwayID) 
);
