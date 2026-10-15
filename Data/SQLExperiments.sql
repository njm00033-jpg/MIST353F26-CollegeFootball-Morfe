/*
select * from Player;

select * from Roster;

select * from PlayerStats;

go

insert into Player (PlayerName, PlayerDateOfBirth)

values ('John Doe', '1990-01-01', 1);


INSERT INTO PlayerPosition (PlayerID, PositionID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO PlayerStats (
    PlayerID,
    RosterID,
    Position
)
VALUES
(1, 1, 'QB'),
(2, 1, 'RB'),
(3, 2, 'Defender'),
(4, 3, 'Returner');

INSERT INTO QBStats (
    PlayerStatsID,
    Attempts,
    Completions,
    Yards,
    TDs,
    INTs
)
VALUES
(1, 35, 25, 320, 3, 1);

INSERT INTO RBStats (
    PlayerStatsID,
    Carries,
    Yards,
    TDs,
    Long,
    Fumbles
)
VALUES
(2, 20, 145, 2, 45, 0);

INSERT INTO DefenderStats (
    PlayerStatsID,
    Tackles,
    Sacks,
    Interceptions,
    DefensiveTDs
)
VALUES
(3, 12, 2, 1, 0);

GO

SELECT * FROM PlayerPosition;
SELECT * FROM PlayerStats;
SELECT * FROM QBStats;
SELECT * FROM RBStats;
SELECT * FROM DefenderStats;
/*