USE BookShareDB;
GO

CREATE PROCEDURE [uspGetErrorInfo]
AS
  SELECT
     ERROR_NUMBER() AS ErrorNumber,
	 ERROR_SEVERITY() AS ErrorSeverity,
	 ERROR_STATE() AS ErrorState,
     ERROR_PROCEDURE() AS ErrorProcedure,
     ERROR_LINE() AS ErrorLine,
     ERROR_MESSAGE() AS ErrorMessage;
GO

CREATE PROCEDURE [uspReviewABook]
	@bookID integer,
	@userID integer,
	@rating integer,
	@description varchar = NULL
AS
BEGIN
BEGIN TRY
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
END TRY
BEGIN CATCH
	SELECT * FROM [uspGetErrorInfo]()
END CATCH
END
GO

CREATE PROCEDURE [uspRateAUser]
	@userID integer,
	@rating integer
AS
BEGIN
BEGIN TRY
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
END TRY
BEGIN CATCH
	SELECT * FROM [uspGetErrorInfo]()
END CATCH
END
GO

CREATE PROCEDURE [uspRateACopy]
	@copyID integer,
	@rating integer,
	@ratingDate date
AS
BEGIN
BEGIN TRY
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
END TRY
BEGIN CATCH
	SELECT * FROM [uspGetErrorInfo]()
END CATCH
END
GO