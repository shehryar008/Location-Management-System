-- Create the database if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'LocationManagerDb')
BEGIN
    CREATE DATABASE LocationManagerDb;
END
GO

USE LocationManagerDb;
GO

-- Create the database schema for the Location Management System

-- Countries table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Countries' AND xtype='U')
BEGIN
    CREATE TABLE Countries (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL UNIQUE,
        Code NVARCHAR(10) NULL,
        CreatedAt DATETIME2 DEFAULT GETDATE(),
        UpdatedAt DATETIME2 DEFAULT GETDATE()
    );
END
GO

-- Provinces/States table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Provinces' AND xtype='U')
BEGIN
    CREATE TABLE Provinces (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL,
        Code NVARCHAR(10) NULL,
        CountryId INT NOT NULL,
        CreatedAt DATETIME2 DEFAULT GETDATE(),
        UpdatedAt DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (CountryId) REFERENCES Countries(Id) ON DELETE CASCADE,
        UNIQUE(Name, CountryId)
    );
END
GO

-- Cities table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Cities' AND xtype='U')
BEGIN
    CREATE TABLE Cities (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL,
        Code NVARCHAR(10) NULL,
        ProvinceId INT NOT NULL,
        CreatedAt DATETIME2 DEFAULT GETDATE(),
        UpdatedAt DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (ProvinceId) REFERENCES Provinces(Id) ON DELETE CASCADE,
        UNIQUE(Name, ProvinceId)
    );
END
GO

-- Locations table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Locations' AND xtype='U')
BEGIN
    CREATE TABLE Locations (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        Address NVARCHAR(500) NULL,
        Latitude DECIMAL(18,6) NULL,
        Longitude DECIMAL(18,6) NULL,
        CityId INT NOT NULL,
        CreatedAt DATETIME2 DEFAULT GETDATE(),
        UpdatedAt DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (CityId) REFERENCES Cities(Id) ON DELETE CASCADE
    );
END
GO

-- Create indexes for better performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Provinces_CountryId')
BEGIN
    CREATE INDEX IX_Provinces_CountryId ON Provinces(CountryId);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Cities_ProvinceId')
BEGIN
    CREATE INDEX IX_Cities_ProvinceId ON Cities(ProvinceId);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Locations_CityId')
BEGIN
    CREATE INDEX IX_Locations_CityId ON Locations(CityId);
END
GO

PRINT 'Database schema created successfully!';
