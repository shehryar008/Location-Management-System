USE LocationManagerDb;
GO

-- Seed data for the Location Management System

-- Insert Countries (only if they don't exist)
IF NOT EXISTS (SELECT 1 FROM Countries WHERE Name = 'United States')
BEGIN
    INSERT INTO Countries (Name, Code, CreatedAt, UpdatedAt) VALUES 
    ('United States', 'US', GETDATE(), GETDATE()),
    ('Canada', 'CA', GETDATE(), GETDATE()),
    ('United Kingdom', 'GB', GETDATE(), GETDATE()),
    ('Australia', 'AU', GETDATE(), GETDATE()),
    ('Germany', 'DE', GETDATE(), GETDATE()),
    ('Pakistan', 'PK', GETDATE(), GETDATE()),
    ('India', 'IN', GETDATE(), GETDATE()),
    ('France', 'FR', GETDATE(), GETDATE());
    
    PRINT 'Countries inserted successfully!';
END
ELSE
BEGIN
    PRINT 'Countries already exist, skipping insert.';
END
GO

-- Insert Provinces/States (only if they don't exist)
IF NOT EXISTS (SELECT 1 FROM Provinces WHERE Name = 'California')
BEGIN
    INSERT INTO Provinces (Name, Code, CountryId, CreatedAt, UpdatedAt) VALUES 
    -- United States
    ('California', 'CA', (SELECT Id FROM Countries WHERE Name = 'United States'), GETDATE(), GETDATE()),
    ('Texas', 'TX', (SELECT Id FROM Countries WHERE Name = 'United States'), GETDATE(), GETDATE()),
    ('New York', 'NY', (SELECT Id FROM Countries WHERE Name = 'United States'), GETDATE(), GETDATE()),
    ('Florida', 'FL', (SELECT Id FROM Countries WHERE Name = 'United States'), GETDATE(), GETDATE()),
    -- Canada
    ('Ontario', 'ON', (SELECT Id FROM Countries WHERE Name = 'Canada'), GETDATE(), GETDATE()),
    ('Quebec', 'QC', (SELECT Id FROM Countries WHERE Name = 'Canada'), GETDATE(), GETDATE()),
    ('British Columbia', 'BC', (SELECT Id FROM Countries WHERE Name = 'Canada'), GETDATE(), GETDATE()),
    -- United Kingdom
    ('England', 'ENG', (SELECT Id FROM Countries WHERE Name = 'United Kingdom'), GETDATE(), GETDATE()),
    ('Scotland', 'SCT', (SELECT Id FROM Countries WHERE Name = 'United Kingdom'), GETDATE(), GETDATE()),
    ('Wales', 'WLS', (SELECT Id FROM Countries WHERE Name = 'United Kingdom'), GETDATE(), GETDATE()),
    -- Australia
    ('New South Wales', 'NSW', (SELECT Id FROM Countries WHERE Name = 'Australia'), GETDATE(), GETDATE()),
    ('Victoria', 'VIC', (SELECT Id FROM Countries WHERE Name = 'Australia'), GETDATE(), GETDATE()), -- CORRECTED LINE
    ('Queensland', 'QLD', (SELECT Id FROM Countries WHERE Name = 'Australia'), GETDATE(), GETDATE()),
    -- Germany
    ('Bavaria', 'BY', (SELECT Id FROM Countries WHERE Name = 'Germany'), GETDATE(), GETDATE()),
    ('Berlin', 'BE', (SELECT Id FROM Countries WHERE Name = 'Germany'), GETDATE(), GETDATE()),
    ('Hamburg', 'HH', (SELECT Id FROM Countries WHERE Name = 'Germany'), GETDATE(), GETDATE()),
    -- Pakistan
    ('Punjab', 'PB', (SELECT Id FROM Countries WHERE Name = 'Pakistan'), GETDATE(), GETDATE()),
    ('Sindh', 'SD', (SELECT Id FROM Countries WHERE Name = 'Pakistan'), GETDATE(), GETDATE()),
    ('Khyber Pakhtunkhwa', 'KP', (SELECT Id FROM Countries WHERE Name = 'Pakistan'), GETDATE(), GETDATE()),
    -- India
    ('Maharashtra', 'MH', (SELECT Id FROM Countries WHERE Name = 'India'), GETDATE(), GETDATE()),
    ('Delhi', 'DL', (SELECT Id FROM Countries WHERE Name = 'India'), GETDATE(), GETDATE()),
    ('Karnataka', 'KA', (SELECT Id FROM Countries WHERE Name = 'India'), GETDATE(), GETDATE());
    
    PRINT 'Provinces inserted successfully!';
END
ELSE
BEGIN
    PRINT 'Provinces already exist, skipping insert.';
END
GO

-- Insert Cities (only if they don't exist)
IF NOT EXISTS (SELECT 1 FROM Cities WHERE Name = 'Los Angeles')
BEGIN
    INSERT INTO Cities (Name, Code, ProvinceId, CreatedAt, UpdatedAt) VALUES 
    -- California
    ('Los Angeles', 'LA', (SELECT Id FROM Provinces WHERE Name = 'California'), GETDATE(), GETDATE()),
    ('San Francisco', 'SF', (SELECT Id FROM Provinces WHERE Name = 'California'), GETDATE(), GETDATE()),
    ('San Diego', 'SD', (SELECT Id FROM Provinces WHERE Name = 'California'), GETDATE(), GETDATE()),
    -- Texas
    ('Houston', 'HOU', (SELECT Id FROM Provinces WHERE Name = 'Texas'), GETDATE(), GETDATE()),
    ('Dallas', 'DAL', (SELECT Id FROM Provinces WHERE Name = 'Texas'), GETDATE(), GETDATE()),
    ('Austin', 'AUS', (SELECT Id FROM Provinces WHERE Name = 'Texas'), GETDATE(), GETDATE()),
    -- Ontario
    ('Toronto', 'TOR', (SELECT Id FROM Provinces WHERE Name = 'Ontario'), GETDATE(), GETDATE()),
    ('Ottawa', 'OTT', (SELECT Id FROM Provinces WHERE Name = 'Ontario'), GETDATE(), GETDATE()),
    ('Hamilton', 'HAM', (SELECT Id FROM Provinces WHERE Name = 'Ontario'), GETDATE(), GETDATE()),
    -- England
    ('London', 'LON', (SELECT Id FROM Provinces WHERE Name = 'England'), GETDATE(), GETDATE()),
    ('Manchester', 'MAN', (SELECT Id FROM Provinces WHERE Name = 'England'), GETDATE(), GETDATE()),
    ('Birmingham', 'BIR', (SELECT Id FROM Provinces WHERE Name = 'England'), GETDATE(), GETDATE()),
    -- Punjab (Pakistan)
    ('Lahore', 'LHR', (SELECT Id FROM Provinces WHERE Name = 'Punjab'), GETDATE(), GETDATE()),
    ('Karachi', 'KHI', (SELECT Id FROM Provinces WHERE Name = 'Sindh'), GETDATE(), GETDATE()),
    ('Gujranwala', 'GRW', (SELECT Id FROM Provinces WHERE Name = 'Punjab'), GETDATE(), GETDATE()),
    ('Faisalabad', 'FSD', (SELECT Id FROM Provinces WHERE Name = 'Punjab'), GETDATE(), GETDATE());
    
    PRINT 'Cities inserted successfully!';
END
ELSE
BEGIN
    PRINT 'Cities already exist, skipping insert.';
END
GO

-- Insert sample Locations (only if they don't exist)
IF NOT EXISTS (SELECT 1 FROM Locations WHERE Name = 'Downtown Office')
BEGIN
    INSERT INTO Locations (Name, Address, Latitude, Longitude, CityId, CreatedAt, UpdatedAt) VALUES 
    ('Downtown Office', '123 Main St, Los Angeles, CA', 34.0522, -118.2437, (SELECT Id FROM Cities WHERE Name = 'Los Angeles'), GETDATE(), GETDATE()),
    ('Tech Hub', '456 Market St, San Francisco, CA', 37.7749, -122.4194, (SELECT Id FROM Cities WHERE Name = 'San Francisco'), GETDATE(), GETDATE()),
    ('Main Branch', '789 Yonge St, Toronto, ON', 43.6532, -79.3832, (SELECT Id FROM Cities WHERE Name = 'Toronto'), GETDATE(), GETDATE()),
    ('Regional Center', '321 Oxford St, London, UK', 51.5074, -0.1278, (SELECT Id FROM Cities WHERE Name = 'London'), GETDATE(), GETDATE()),
    ('Corporate Headquarters', '654 Commerce St, Houston, TX', 29.7604, -95.3698, (SELECT Id FROM Cities WHERE Name = 'Houston'), GETDATE(), GETDATE()),
    ('Lahore Office', 'Mall Road, Lahore, Punjab', 31.5204, 74.3587, (SELECT Id FROM Cities WHERE Name = 'Lahore'), GETDATE(), GETDATE()),
    ('Gujranwala Branch', 'GT Road, Gujranwala, Punjab', 32.1877, 74.1945, (SELECT Id FROM Cities WHERE Name = 'Gujranwala'), GETDATE(), GETDATE());
    
    PRINT 'Sample locations inserted successfully!';
END
ELSE
BEGIN
    PRINT 'Sample locations already exist, skipping insert.';
END
GO

PRINT 'Database seeding completed successfully!';
