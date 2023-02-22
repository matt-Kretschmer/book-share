CREATE OR ALTER FUNCTION BookShareDB.copyIsAvailable(@copyID integer)
RETURNS varchar 
AS
-- Returns "TRUE" if a book copy is available. Uses the fact that return date is null if it hasn't been returned.
    unavailable number;
BEGIN
    SELECT COUNT(agreementState.stateName) INTO unavailable
    FROM BookShareDB.shareAgreement
    INNER JOIN BookShareDB.agreementState
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

CREATE OR ALTER FUNCTION BookShareDB.addCopyOfBook(@ISBN integer, @ownerID integer)
RETURNS integer
AS
-- Adds a new copy of the book and returns it's copy ID
    copyID integer
BEGIN
    INSERT INTO BookShareDB.bookCopy (bookID, ownerID)
    OUTPUT INSERTED.copyIDINTO copyID
    VALUES (@ISBN, @ownerID);

    RETURN copyID;
END;
GO;