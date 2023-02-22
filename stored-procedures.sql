USE BookShareDB;
GO

CREATE PROCEDURE [uspReviewABook]
	@bookID integer NOT NULL,
	@userID integer NOT NULL,
	@rating integer NOT NULL,
	@description varchar NULL
AS
BEGIN
	INSERT INTO [bookReview]
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
GO

CREATE PROCEDURE [uspRateAUser]
	@userID integer NOT NULL,
	@rating integer NOT NULL
AS
BEGIN
	INSERT INTO [userRating]
		(
			[userID],
			[rating]
		)
	VALUES
		(
			@userID,
			@rating
		)
END
GO

CREATE PROCEDURE [uspRateACopy]
	@copyID integer NOT NULL,
	@rating integer NOT NULL,
	@ratingDate date NOT NULL
AS
BEGIN
	INSERT INTO [copyConditionRating]
		(
			[copyID],
			[rating],
			[ratingDate]
		)
	VALUES
		(
			@copyID,
			@rating,
			@ratingDate
		)
END
GO