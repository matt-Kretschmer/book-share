USE BookShareDB;
GO

CREATE PROCEDURE [uspReviewABook]
	@bookID integer NOT NULL,
	@userID integer NOT NULL,
	@rating integer NOT NULL,
	@description varchar NULL
AS
BEGIN
	INSERT INTO bookReview
		(
			[bookID],
			[userID],
			[rating],
			[description]
		)
	VALUES
		(
			@bookID,
			@userID,
			@rating,
			@description
		)
END