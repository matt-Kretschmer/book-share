CREATE OR ALTER FUNCTION copyIsAvailable(@copyID integer)
RETURNS varchar 
AS
-- Returns "TRUE" if a book copy is available. Uses the share agreement state 
-- Checks that there aren't any cases where it's pending, accepted or received - as that means it's not available
    DECLARE unavailable number;
BEGIN
    SELECT COUNT(agreementState.stateName) INTO unavailable
    FROM shareAgreement
    INNER JOIN agreementState
    ON shareAgreement.state = agreementState.stateID
    WHERE agreementState.stateName = 'pending' 
        OR agreementState.stateName = 'accepted'
        OR agreementState.stateName = 'received';
    
    IF unavailable = 0 THEN
        RETURN 'TRUE';
    ELSE
        RETURN 'FALSE';
    END IF;
END;
GO;

CREATE OR ALTER FUNCTION addCopyOfBook(@ISBN integer, @ownerID integer)
RETURNS integer
AS
-- Adds a new copy of the book and returns it's copy ID
    copyID integer
BEGIN
    INSERT INTO bookCopy (bookID, ownerID)
    OUTPUT INSERTED.copyID INTO copyID
    VALUES (@ISBN, @ownerID);
    RETURN copyID;
END;
GO;
