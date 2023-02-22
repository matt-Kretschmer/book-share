CREATE OR ALTER FUNCTION copyIsAvailable
(@copyID integer)
RETURNS varchar 
AS
-- Returns "TRUE" if a book copy is available. Uses the share agreement state 
-- Checks that there aren't any cases where it's pending, accepted or received - as that means it's not available
BEGIN 	
	DECLARE @available as varchar(5)
	SELECT @available = CASE 
		WHEN COUNT(agreementState.stateName) = 0 
			THEN 'TRUE'
			ELSE 'FALSE' 
		END 
			FROM shareAgreement
			INNER JOIN agreementState
			ON shareAgreement.state = agreementState.stateID
			WHERE @copyID = agreementID AND (stateName = 'pending' 
				OR stateName = 'accepted'
				OR stateName = 'received')
	RETURN @available;
END;
GO
