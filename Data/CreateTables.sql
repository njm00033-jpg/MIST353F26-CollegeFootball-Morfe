/*
CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra
FOR LOGIN NandaSurendra;
ALTER ROLE db_owner ADD MEMBER NandaSurendra;
*/
IF OBJECT_ID('GamePrediction') IS NOT NULL
    DROP TABLE GamePrediction;

IF OBJECT_ID('WeeklyPredictionResults') IS NOT NULL
    DROP TABLE WeeklyPredictionResults;

IF OBJECT_ID('Coach') IS NOT NULL
    DROP TABLE Coach;

IF OBJECT_ID('Roster') IS NOT NULL
    DROP TABLE Roster;

IF OBJECT_ID('Player') IS NOT NULL
    DROP TABLE Player;

IF OBJECT_ID('Position') IS NOT NULL
    DROP TABLE Position;

IF OBJECT_ID('AppUser') IS NOT NULL
    DROP TABLE AppUser;

IF OBJECT_ID('Game') IS NOT NULL
    DROP TABLE Game;

IF OBJECT_ID('Team') IS NOT NULL
    DROP TABLE Team;

IF OBJECT_ID('Stadium') IS NOT NULL
    DROP TABLE Stadium;

GO

CREATE TABLE Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumStreetAddress VARCHAR(100) NOT NULL,
    StadiumCity VARCHAR(50) NOT NULL,
    StadiumState CHAR(2) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeOfField VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Stadium PRIMARY KEY (StadiumID),
    CONSTRAINT UQ_Stadium UNIQUE (StadiumName, StadiumCity, StadiumState),
    CONSTRAINT CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

GO

CREATE TABLE Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName VARCHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    CONSTRAINT PK_Team PRIMARY KEY (TeamID),
    CONSTRAINT UQ_UniversityName UNIQUE (UniversityName),
    CONSTRAINT FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

GO

CREATE TABLE Game (
    GameID INT NOT NULL IDENTITY(1,1),
    GameDate DATE NOT NULL,
    GameTime TIME NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    WinnerTeamID INT NULL,
    StadiumID INT NOT NULL,
    CONSTRAINT PK_Game PRIMARY KEY (GameID),
    CONSTRAINT UQ_Game UNIQUE (HomeTeamID, GameDate, GameTime),
    CONSTRAINT FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

GO

CREATE TABLE AppUser (
    AppUserID INT NOT NULL IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    AppUserEmail VARCHAR(50) NOT NULL,
    AppUserPassword VARCHAR(50) NOT NULL,
    CONSTRAINT PK_AppUser PRIMARY KEY (AppUserID),
    CONSTRAINT UQ_AppUser UNIQUE (AppUserEmail)
);

GO

CREATE TABLE WeeklyPredictionResults (
    WeeklyPredictionResultsID INT NOT NULL IDENTITY(1,1),
    StartDate DATE NOT NULL,
    NumberOfCorrectPredictions INT NOT NULL,
    AppUserID INT NOT NULL,
    CONSTRAINT PK_WeeklyPredictionResults PRIMARY KEY (WeeklyPredictionResultsID),
    CONSTRAINT FK_WeeklyPredictionResults_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);

GO

CREATE TABLE Position (
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Position PRIMARY KEY (PositionID),
    CONSTRAINT CK_PositionName CHECK (
        PositionName IN (
            'Quarterback',
            'Running Back',
            'Returner',
            'Defender',
            'Kicker',
            'Punter',
            'Wide Receiver'
        )
    )
);

GO

CREATE TABLE Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    PlayerName VARCHAR(50) NOT NULL,
    PlayerDateOfBirth DATE NOT NULL,
    PositionID INT NOT NULL,
    CONSTRAINT PK_Player PRIMARY KEY (PlayerID),
    CONSTRAINT FK_Player_Position FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
);

GO

CREATE TABLE Coach (
    CoachID INT NOT NULL IDENTITY(1,1),
    CoachName VARCHAR(100) NOT NULL,
    TeamID INT NOT NULL,
    CONSTRAINT PK_Coach PRIMARY KEY (CoachID),
    CONSTRAINT UQ_Coach_Team UNIQUE (TeamID),
    CONSTRAINT FK_Coach_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

GO

CREATE TABLE Roster (
    RosterID INT NOT NULL IDENTITY(1,1),
    Year INT NOT NULL,
    SeasonWins INT NOT NULL,
    SeasonLosses INT NOT NULL,
    SeasonTies INT NOT NULL,
    TeamID INT NOT NULL,
    CONSTRAINT PK_Roster PRIMARY KEY (RosterID),
    CONSTRAINT UQ_Roster UNIQUE (TeamID, Year),
    CONSTRAINT FK_Roster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

GO

CREATE TABLE GamePrediction (
    GamePredictionID INT NOT NULL IDENTITY(1,1),
    PredictionDateTime DATETIME2 NOT NULL,
    AppUserID INT NOT NULL,
    GameID INT NOT NULL,
    PredictedTeamID INT NOT NULL,
    CONSTRAINT PK_GamePrediction PRIMARY KEY (GamePredictionID),
    CONSTRAINT FK_GamePrediction_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
    CONSTRAINT FK_GamePrediction_Game FOREIGN KEY (GameID) REFERENCES Game(GameID),
    CONSTRAINT FK_GamePrediction_PredictedTeam FOREIGN KEY (PredictedTeamID) REFERENCES Team(TeamID),
    CONSTRAINT UQ_GamePrediction UNIQUE (AppUserID, GameID)
);

GO