/*
CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra
FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;
*/

IF OBJECT_ID('CoachRoster', 'U') IS NOT NULL
    DROP TABLE CoachRoster;

IF OBJECT_ID('PlayerPosition', 'U') IS NOT NULL
    DROP TABLE PlayerPosition;

IF OBJECT_ID('QBStats', 'U') IS NOT NULL
    DROP TABLE QBStats;

IF OBJECT_ID('RBStats', 'U') IS NOT NULL
    DROP TABLE RBStats;

IF OBJECT_ID('DefenderStats', 'U') IS NOT NULL
    DROP TABLE DefenderStats;

IF OBJECT_ID('ReturnerStats', 'U') IS NOT NULL
    DROP TABLE ReturnerStats;

IF OBJECT_ID('KickerStats', 'U') IS NOT NULL
    DROP TABLE KickerStats;

IF OBJECT_ID('PunterStats', 'U') IS NOT NULL
    DROP TABLE PunterStats;

IF OBJECT_ID('PlayerStats', 'U') IS NOT NULL
    DROP TABLE PlayerStats;

IF OBJECT_ID('GamePrediction', 'U') IS NOT NULL
    DROP TABLE GamePrediction;

IF OBJECT_ID('WeeklyPredictionResults', 'U') IS NOT NULL
    DROP TABLE WeeklyPredictionResults;

IF OBJECT_ID('Coach', 'U') IS NOT NULL
    DROP TABLE Coach;

IF OBJECT_ID('Player', 'U') IS NOT NULL
    DROP TABLE Player;

IF OBJECT_ID('Position', 'U') IS NOT NULL
    DROP TABLE Position;

IF OBJECT_ID('Roster', 'U') IS NOT NULL
    DROP TABLE Roster;

IF OBJECT_ID('AppUser', 'U') IS NOT NULL
    DROP TABLE AppUser;

IF OBJECT_ID('Game', 'U') IS NOT NULL
    DROP TABLE Game;

IF OBJECT_ID('Team', 'U') IS NOT NULL
    DROP TABLE Team;

IF OBJECT_ID('Stadium', 'U') IS NOT NULL
    DROP TABLE Stadium;

IF OBJECT_ID('Conference', 'U') IS NOT NULL
    DROP TABLE Conference;

GO

CREATE TABLE Conference (
    ConferenceID INT NOT NULL IDENTITY(1,1),
    ConferenceName VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Conference PRIMARY KEY (ConferenceID),
    CONSTRAINT UQ_ConferenceName UNIQUE (ConferenceName)
);

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
    CONSTRAINT CK_TypeOfField CHECK (TypeOfField IN ('Turf', 'Grass')),
    CONSTRAINT CK_StadiumCapacity CHECK (StadiumCapacity > 0)
);

GO

CREATE TABLE Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName VARCHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    ConferenceID INT NOT NULL,
    StadiumID INT NOT NULL,
    CONSTRAINT PK_Team PRIMARY KEY (TeamID),
    CONSTRAINT UQ_UniversityName UNIQUE (UniversityName),
    CONSTRAINT FK_Team_Conference FOREIGN KEY (ConferenceID)
        REFERENCES Conference(ConferenceID),
    CONSTRAINT FK_Team_Stadium FOREIGN KEY (StadiumID)
        REFERENCES Stadium(StadiumID)
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
    CONSTRAINT FK_Game_HomeTeam FOREIGN KEY (HomeTeamID)
        REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_AwayTeam FOREIGN KEY (AwayTeamID)
        REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID)
        REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_Stadium FOREIGN KEY (StadiumID)
        REFERENCES Stadium(StadiumID),
    CONSTRAINT CK_Game_Teams CHECK (HomeTeamID <> AwayTeamID),
    CONSTRAINT CK_Game_Scores CHECK (
        (HomeScore IS NULL OR HomeScore >= 0)
        AND (AwayScore IS NULL OR AwayScore >= 0)
    ),
    CONSTRAINT CK_Game_Winner CHECK (
        WinnerTeamID IS NULL
        OR WinnerTeamID = HomeTeamID
        OR WinnerTeamID = AwayTeamID
    )
);

GO

CREATE TABLE AppUser (
    AppUserID INT NOT NULL IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    AppUserEmail VARCHAR(50) NOT NULL,
    AppUserPassword VARCHAR(255) NOT NULL,
    AppUserRole VARCHAR(50) NOT NULL,
    TeamID INT NULL,
    CONSTRAINT PK_AppUser PRIMARY KEY (AppUserID),
    CONSTRAINT UQ_AppUser UNIQUE (AppUserEmail),
    CONSTRAINT FK_AppUser_Team FOREIGN KEY (TeamID)
        REFERENCES Team(TeamID)
);

GO

CREATE TABLE WeeklyPredictionResults (
    WeeklyPredictionResultsID INT NOT NULL IDENTITY(1,1),
    StartDate DATE NOT NULL,
    NumberOfCorrectPredictions INT NOT NULL,
    TotalDifferenceFromPredictedMargins INT NOT NULL,
    AppUserID INT NOT NULL,
    CONSTRAINT PK_WeeklyPredictionResults
        PRIMARY KEY (WeeklyPredictionResultsID),
    CONSTRAINT FK_WeeklyPredictionResults_AppUser
        FOREIGN KEY (AppUserID)
        REFERENCES AppUser(AppUserID),
    CONSTRAINT UQ_WeeklyPredictionResults
        UNIQUE (AppUserID, StartDate),
    CONSTRAINT CK_WeeklyPredictionResults_Correct
        CHECK (NumberOfCorrectPredictions >= 0),
    CONSTRAINT CK_WeeklyPredictionResults_Margin
        CHECK (TotalDifferenceFromPredictedMargins >= 0)
);

GO

CREATE TABLE Position (
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Position PRIMARY KEY (PositionID),
    CONSTRAINT UQ_PositionName UNIQUE (PositionName),
    CONSTRAINT CK_PositionName CHECK (
        PositionName IN (
            'QB',
            'RB',
            'Defender',
            'Returner',
            'Kicker',
            'Punter'
        )
    )
);

GO

CREATE TABLE Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    PlayerName VARCHAR(50) NOT NULL,
    PlayerDateOfBirth DATE NOT NULL,
    CONSTRAINT PK_Player PRIMARY KEY (PlayerID)
);

GO

CREATE TABLE Coach (
    CoachID INT NOT NULL IDENTITY(1,1),
    CoachName VARCHAR(100) NOT NULL,
    TeamID INT NOT NULL,
    CONSTRAINT PK_Coach PRIMARY KEY (CoachID),
    CONSTRAINT FK_Coach_Team FOREIGN KEY (TeamID)
        REFERENCES Team(TeamID)
);

GO

CREATE TABLE Roster (
    RosterID INT NOT NULL IDENTITY(1,1),
    [Year] INT NOT NULL,
    SeasonWins INT NOT NULL,
    SeasonLosses INT NOT NULL,
    SeasonTies INT NOT NULL,
    TeamID INT NOT NULL,
    CONSTRAINT PK_Roster PRIMARY KEY (RosterID),
    CONSTRAINT UQ_Roster UNIQUE (TeamID, [Year]),
    CONSTRAINT FK_Roster_Team FOREIGN KEY (TeamID)
        REFERENCES Team(TeamID),
    CONSTRAINT CK_Roster_Record CHECK (
        SeasonWins >= 0
        AND SeasonLosses >= 0
        AND SeasonTies >= 0
    )
);

GO

CREATE TABLE GamePrediction (
    GamePredictionID INT NOT NULL IDENTITY(1,1),
    PredictionDateTime DATETIME2 NOT NULL,
    PredictedMargin INT NOT NULL,
    AppUserID INT NOT NULL,
    GameID INT NOT NULL,
    PredictedTeamID INT NOT NULL,
    CONSTRAINT PK_GamePrediction PRIMARY KEY (GamePredictionID),
    CONSTRAINT FK_GamePrediction_AppUser
        FOREIGN KEY (AppUserID)
        REFERENCES AppUser(AppUserID),
    CONSTRAINT FK_GamePrediction_Game
        FOREIGN KEY (GameID)
        REFERENCES Game(GameID),
    CONSTRAINT FK_GamePrediction_PredictedTeam
        FOREIGN KEY (PredictedTeamID)
        REFERENCES Team(TeamID),
    CONSTRAINT UQ_GamePrediction UNIQUE (AppUserID, GameID),
    CONSTRAINT CK_GamePrediction_Margin
        CHECK (PredictedMargin >= 0)
);

GO

CREATE TABLE PlayerStats (
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    Position VARCHAR(50) NOT NULL,
    CONSTRAINT PK_PlayerStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_PlayerStats_Player
        FOREIGN KEY (PlayerID)
        REFERENCES Player(PlayerID),
    CONSTRAINT FK_PlayerStats_Roster
        FOREIGN KEY (RosterID)
        REFERENCES Roster(RosterID),
    CONSTRAINT UQ_PlayerStats_PlayerRosterPosition
        UNIQUE (PlayerID, RosterID, Position)
);

GO

CREATE TABLE QBStats (
    PlayerStatsID INT NOT NULL,
    Attempts INT NOT NULL,
    Completions INT NOT NULL,
    Yards INT NOT NULL,
    TDs INT NOT NULL,
    INTs INT NOT NULL,
    CONSTRAINT PK_QBStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_QBStats_PlayerStats
        FOREIGN KEY (PlayerStatsID)
        REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_QBStats CHECK (
        Attempts >= 0
        AND Completions >= 0
        AND Completions <= Attempts
        AND TDs >= 0
        AND INTs >= 0
    )
);

GO

CREATE TABLE RBStats (
    PlayerStatsID INT NOT NULL,
    Carries INT NOT NULL,
    Yards INT NOT NULL,
    TDs INT NOT NULL,
    [Long] INT NOT NULL,
    Fumbles INT NOT NULL,
    CONSTRAINT PK_RBStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_RBStats_PlayerStats
        FOREIGN KEY (PlayerStatsID)
        REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_RBStats CHECK (
        Carries >= 0
        AND TDs >= 0
        AND [Long] >= 0
        AND Fumbles >= 0
    )
);

GO

CREATE TABLE DefenderStats (
    PlayerStatsID INT NOT NULL,
    Tackles INT NOT NULL,
    Sacks DECIMAL(5,1) NOT NULL,
    Interceptions INT NOT NULL,
    DefensiveTDs INT NOT NULL,
    CONSTRAINT PK_DefenderStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_DefenderStats_PlayerStats
        FOREIGN KEY (PlayerStatsID)
        REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_DefenderStats CHECK (
        Tackles >= 0
        AND Sacks >= 0
        AND Interceptions >= 0
        AND DefensiveTDs >= 0
    )
);

GO

CREATE TABLE ReturnerStats (
    PlayerStatsID INT NOT NULL,
    KickOffAttempts INT NOT NULL,
    KickOffYards INT NOT NULL,
    KickOffLong INT NOT NULL,
    KickOffTDs INT NOT NULL,
    PuntReturnAttempts INT NOT NULL,
    PuntReturnYards INT NOT NULL,
    PuntReturnLong INT NOT NULL,
    PuntReturnTDs INT NOT NULL,
    CONSTRAINT PK_ReturnerStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_ReturnerStats_PlayerStats
        FOREIGN KEY (PlayerStatsID)
        REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_ReturnerStats CHECK (
        KickOffAttempts >= 0
        AND KickOffLong >= 0
        AND KickOffTDs >= 0
        AND PuntReturnAttempts >= 0
        AND PuntReturnLong >= 0
        AND PuntReturnTDs >= 0
    )
);

GO

CREATE TABLE KickerStats (
    PlayerStatsID INT NOT NULL,
    FieldGoalAttempts INT NOT NULL,
    FieldGoalsMade INT NOT NULL,
    [Long] INT NOT NULL,
    ExtraPointAttempts INT NOT NULL,
    ExtraPointsMade INT NOT NULL,
    CONSTRAINT PK_KickerStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_KickerStats_PlayerStats
        FOREIGN KEY (PlayerStatsID)
        REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_KickerStats CHECK (
        FieldGoalAttempts >= 0
        AND FieldGoalsMade >= 0
        AND FieldGoalsMade <= FieldGoalAttempts
        AND [Long] >= 0
        AND ExtraPointAttempts >= 0
        AND ExtraPointsMade >= 0
        AND ExtraPointsMade <= ExtraPointAttempts
    )
);

GO

CREATE TABLE PunterStats (
    PlayerStatsID INT NOT NULL,
    Punts INT NOT NULL,
    Yards INT NOT NULL,
    [Long] INT NOT NULL,
    CONSTRAINT PK_PunterStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_PunterStats_PlayerStats
        FOREIGN KEY (PlayerStatsID)
        REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_PunterStats CHECK (
        Punts >= 0
        AND Yards >= 0
        AND [Long] >= 0
    )
);

GO

CREATE TABLE PlayerPosition (
    PlayerPositionID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    PositionID INT NOT NULL,
    CONSTRAINT PK_PlayerPosition PRIMARY KEY (PlayerPositionID),
    CONSTRAINT FK_PlayerPosition_Player
        FOREIGN KEY (PlayerID)
        REFERENCES Player(PlayerID),
    CONSTRAINT FK_PlayerPosition_Position
        FOREIGN KEY (PositionID)
        REFERENCES Position(PositionID),
    CONSTRAINT UQ_PlayerPosition UNIQUE (PlayerID, PositionID)
);

GO

CREATE TABLE CoachRoster (
    CoachRosterID INT NOT NULL IDENTITY(1,1),
    CoachID INT NOT NULL,
    RosterID INT NOT NULL,
    CONSTRAINT PK_CoachRoster PRIMARY KEY (CoachRosterID),
    CONSTRAINT FK_CoachRoster_Coach
        FOREIGN KEY (CoachID)
        REFERENCES Coach(CoachID),
    CONSTRAINT FK_CoachRoster_Roster
        FOREIGN KEY (RosterID)
        REFERENCES Roster(RosterID),
    CONSTRAINT UQ_CoachRoster UNIQUE (CoachID, RosterID)
);

GO
