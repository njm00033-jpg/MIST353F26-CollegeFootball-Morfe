if object_id('WRStats', 'U') is not null drop table WRStats;
if object_id('GamePrediction', 'U') is not null drop table GamePrediction;
if object_id('CoachRoster', 'U') is not null drop table CoachRoster;
if object_id('Coach', 'U') is not null drop table Coach;
if object_id('ReturnerStats', 'U') is not null drop table ReturnerStats;
if object_id('PunterStats', 'U') is not null drop table PunterStats;
if object_id('KickerStats', 'U') is not null drop table KickerStats;
if object_id('DefenderStats', 'U') is not null drop table DefenderStats;
if object_id('RBStats', 'U') is not null drop table RBStats;
if object_id('QBStats', 'U') is not null drop table QBStats;
if object_id('PlayerStats', 'U') is not null drop table PlayerStats;
if object_id('WeeklyPredictionResults', 'U') is not null drop table WeeklyPredictionResults;
if object_id('Game', 'U') is not null drop table Game;
if object_id('WeeklyGamesOfInterest', 'U') is not null drop table WeeklyGamesOfInterest;
if object_id('AppUserTeam') is not null drop table AppUserTeam;
if object_id('AppUser') is not null drop table AppUser;
if object_id('Roster') is not null drop table Roster;
if object_id('Team') is not null drop table Team;
if object_id('Stadium') is not null drop table Stadium;
if object_id('PlayerPosition') is not null drop table PlayerPosition;
if object_id('Player') is not null drop table Player;
if object_id('Position') is not null drop table Position;
if object_id('Conference') is not null drop table Conference;

go

create table Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName NVARCHAR(50) NOT NULL,
    StadiumCity NVARCHAR(50) NOT NULL,
    StadiumState CHAR(2) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeOfField NVARCHAR(50) NOT NULL,
    constraint PK_Stadium PRIMARY KEY (StadiumID),
    constraint UQ_Stadium UNIQUE (StadiumName, StadiumCity, StadiumState),
    constraint CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

go

create table Conference (
    ConferenceID INT NOT NULL IDENTITY(1,1),
    ConferenceName NVARCHAR(50) NOT NULL,
    constraint PK_Conference PRIMARY KEY (ConferenceID),
    constraint UQ_Conference UNIQUE (ConferenceName)
);

go

create table Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName NVARCHAR(50) NOT NULL,
    TeamName NVARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    ConferenceID INT NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamID),
    constraint UQ_UniversityName UNIQUE (UniversityName),
    constraint FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID),
    constraint FK_Team_Conference FOREIGN KEY (ConferenceID) REFERENCES Conference(ConferenceID)
);

go

create table WeeklyGamesOfInterest(
    WeeklyGamesOfInterestID INT NOT NULL IDENTITY(1,1),
    WeekStartDate Date,
    constraint PK_WeeklyGamesOfInterest PRIMARY KEY (WeeklyGamesOfInterestID),
    constraint UQ_WeeklyGamesOfInterest UNIQUE (WeekStartDate)
);

go

CREATE table Game (
    GameID INT NOT NULL IDENTITY(1,1),
    GameDate Date NOT NULL,
    GameTime Time NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    WinnerTeamID INT NULL,
    StadiumID INT NOT NULL,
    WeeklyGamesOfInterestID INT NOT NULL,
    constraint PK_Game PRIMARY KEY (GameID),
    constraint UQ_Game UNIQUE (HomeTeamID, GameDate, GameTime),
    constraint FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID),
    constraint FK_Game_WeeklyGamesOfInterest FOREIGN KEY (WeeklyGamesOfInterestID) REFERENCES WeeklyGamesOfInterest(WeeklyGamesOfInterestID)
);

go

CREATE TABLE AppUser (
    AppUserID INT NOT NULL IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    AppUserEmail NVARCHAR(50) NOT NULL,
    AppUserPassword NVARCHAR(50) NOT NULL,
    AppUserRole NVARCHAR(50) NOT NULL default 'User',
    Constraint CK_AppUserRole CHECK (AppUserRole IN ('Admin', 'User')),
    CONSTRAINT PK_AppUser PRIMARY KEY (AppUserID),
    CONSTRAINT UQ_AppUser UNIQUE (AppUserEmail)
);

go

create table AppUserTeam (
    AppUserTeamID INT NOT NULL IDENTITY(1,1),
    TeamID INT NOT NULL,
    AppUserID INT NOT NULL,
    constraint PK_AppUserTeam Primary Key (AppUserTeamID),
    constraint UQ_AppUserTeam UNIQUE (TeamID, AppUserID),
    constraint FK_AppUserTeam_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    constraint FK_AppUserTeam_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);

go

CREATE table WeeklyPredictionResults (
    WeeklyPredictionResultsID INT NOT NULL IDENTITY(1,1),
    StartDate DATE NOT NULL default GETDATE(),
    NumberOfCorrectPredictions INT NOT NULL default 0,
    AppUserID INT NOT NULL,
    constraint PK_WeeklyPredictionResults PRIMARY KEY (WeeklyPredictionResultsID), 
    constraint FK_WeeklyPredictionResults_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
    constraint UQ_WeeklyPredictionResults UNIQUE (AppUserID, StartDate)
);

go

create table Player (
    PlayerID int not null identity(1,1),
    PlayerName NVARCHAR(100) not NULL,
    constraint PK_Player primary key (PlayerID),
    constraint UQ_Player UNIQUE (PlayerName)
);

go

create table Position(
    PositionID int not null identity(1,1),
    PositionName NVARCHAR(50) not null,
    constraint PK_Position primary key (PositionID),
    constraint UQ_Position UNIQUE (PositionName),
    constraint CK_Position CHECK (PositionName IN ('QB', 'RB', 'WR', 'TE', 'OL', 'DL', 'LB', 'CB', 'S', 'K', 'P'))
)

go

create table PlayerPosition (
    PlayerPositionID int not null identity(1,1),
    PlayerID int not null,
    PositionID int not null,
    constraint PK_PlayerPosition primary key (PlayerPositionID),
    constraint UQ_PlayerPosition UNIQUE (PlayerID, PositionID),
    constraint FK_PlayerPosition_Player foreign key (PlayerID) references Player(PlayerID),
    constraint FK_PlayerPosition_Position foreign key (PositionID) references Position(PositionID)
);

go
 
create table Roster (
    RosterID int not null identity(1,1),
    RosterYear int not NULL,
    SeasonWins int not NULL,
    SeasonLosses int not NULL,
    SeasonTies int not NULL,
    TeamID int not NULL,
    constraint PK_Roster primary key (RosterID),
    constraint UQ_Roster UNIQUE (TeamID, RosterYear),
    constraint FK_Roster_Team foreign key (TeamID) references Team(TeamID)
 );

go

 Create Table PlayerStats (
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    constraint PK_PlayerStats PRIMARY KEY (PlayerStatsID),
    constraint UQ_PlayerStats UNIQUE (PlayerID, RosterID),
    constraint FK_PlayerStats_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    constraint FK_PlayerStats_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID)
);

go

create table QBStats(
    QBStatsID int not null,
    PassingAttempts int not null default 0,
    PassingCompletions int not null default 0,
    PassingYards int not null default 0,
    PassingTouchdowns int not null default 0,
    Interceptions int not null default 0,
    constraint PK_QBStats PRIMARY KEY (QBStatsID),
    constraint FK_QBStats_PlayerStats FOREIGN KEY (QBStatsID) 
        REFERENCES PlayerStats(PlayerStatsID)
);

go

create table RBStats(
    RBStatsId int not null,
    RushingAttempts int not null default 0,
    RushingYards int not null default 0,
    RushingTouchdowns int not null default 0,
    LongestRush int not null default 0,
    Fumbles int not null default 0,
    constraint PK_RBStats primary key (RBStatsId),
    constraint FK_RBStats_PlayerStats foreign key (RBStatsId)
        references PlayerStats(PlayerStatsID)
);

go

create table WRStats(
    WRStatsId int not null,
    Receptions int not null default 0,
    ReceivingYards int not null default 0,
    ReceivingTouchdowns int not null default 0,
    LongestReception int not null default 0,
    Fumbles int not null default 0,
    constraint PK_WRStats primary key (WRStatsId),
    constraint FK_WRStats_PlayerStats foreign key (WRStatsId)
        references PlayerStats(PlayerStatsID)
);

go

create table DefenderStats(
    DefenderStatsId int not null,
    Tackles int not null default 0,
    Sacks int not null default 0,
    Interceptions int not null default 0,
    ForcedFumbles int not null default 0,
    DefensiveTouchdowns int not null default 0,
    constraint PK_DefenderStats primary key (DefenderStatsId),
    constraint FK_DefenderStats_PlayerStats foreign key (DefenderStatsId)
        references PlayerStats(PlayerStatsID)
);

go

create table KickerStats(
    KickerStatsId int not null,
    FieldGoalsMade int not null default 0,
    FieldGoalsAttempted int not null default 0,
    ExtraPointsMade int not null default 0,
    ExtraPointsAttempted int not null default 0,
    LongestFieldGoal int not null default 0,
    constraint PK_KickerStats primary key (KickerStatsId),
    constraint FK_KickerStats_PlayerStats foreign key (KickerStatsId)
        references PlayerStats(PlayerStatsID)
);

GO

create table PunterStats(
    PunterStatsId int not null,
    Punts int not null default 0,
    PuntYards int not null default 0,
    LongestPunt int not null default 0,
    constraint PK_PunterStats primary key (PunterStatsId),
    constraint FK_PunterStats_PlayerStats foreign key (PunterStatsId)
        references PlayerStats(PlayerStatsID)
);

GO

create table ReturnerStats(
    ReturnerStatsId int not null,
    KickReturns int not null default 0,
    KickReturnYards int not null default 0,
    KickReturnLong int not null default 0,
    KickReturnTouchdowns int not null default 0,
    PuntReturns int not null default 0,
    PuntReturnYards int not null default 0,
    PuntReturnTouchdowns int not null default 0,
    PuntReturnLong int not null default 0,
    constraint PK_ReturnerStats primary key (ReturnerStatsId),
    constraint FK_ReturnerStats_PlayerStats foreign key (ReturnerStatsId)
        references PlayerStats(PlayerStatsID),
);
GO
create table Coach (
    CoachID INT NOT NULL IDENTITY(1,1),
    CoachName NVARCHAR(100) NOT NULL
    constraint PK_Coach PRIMARY KEY (CoachID),
    constraint UQ_Coach UNIQUE (CoachName),
);
go
create table CoachRoster (
    CoachRosterID INT NOT NULL IDENTITY(1,1),
    CoachID INT NOT NULL,
    RosterID INT NOT NULL,
    constraint PK_CoachRoster PRIMARY KEY (CoachRosterID),
    constraint UQ_CoachRoster UNIQUE (CoachID, RosterID),
    constraint FK_CoachRoster_Coach FOREIGN KEY (CoachID) REFERENCES Coach(CoachID),
    constraint FK_CoachRoster_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID)
);
go
create table GamePrediction (
    GamePredictionID INT NOT NULL IDENTITY(1,1),
    GameID INT NOT NULL,
    AppUserID INT NOT NULL,
    PredictedWinnerTeamID INT NOT NULL,
    PredictedMargin INT NOT NULL,
    PredictionDateTime DATETIME NOT NULL DEFAULT GETDATE(),
    constraint PK_GamePrediction PRIMARY KEY (GamePredictionID),
    constraint UQ_GamePrediction UNIQUE (GameID, AppUserID),
    constraint FK_GamePrediction_Game FOREIGN KEY (GameID) REFERENCES Game(GameID),
    constraint FK_GamePrediction_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
    constraint FK_GamePrediction_PredictedWinnerTeam FOREIGN KEY (PredictedWinnerTeamID) REFERENCES Team(TeamID)
);