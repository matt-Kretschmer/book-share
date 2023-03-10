USE BookShareDB;
GO

CREATE OR ALTER FUNCTION copyIsAvailable
(@copyID integer)
RETURNS varchar(5) 
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
			WHERE @copyID = copyID AND (stateName = 'pending' 
				OR stateName = 'accepted'
				OR stateName = 'received')
	RETURN @available;
END;
GO

CREATE OR ALTER FUNCTION getAuthorID
(@fnames varchar(120),
@lname varchar(120))
RETURNS integer 
AS
BEGIN 	
	DECLARE @Id int;

	SELECT @Id = authorId
	FROM author
	WHERE firstNames = @fnames AND lastName = @lname;

	RETURN @Id;
END;
GO

CREATE OR ALTER FUNCTION getBookReviews
(@isbn bigint)
RETURNS TABLE 
AS
RETURN
	SELECT *
	FROM bookReview
	WHERE bookID = @isbn;
GO
