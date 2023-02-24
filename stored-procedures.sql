USE BookShareDB;
GO

CREATE OR ALTER PROCEDURE [uspGetErrorInfo]
AS
  SELECT
     ERROR_NUMBER() AS ErrorNumber,
	 ERROR_SEVERITY() AS ErrorSeverity,
	 ERROR_STATE() AS ErrorState,
     ERROR_PROCEDURE() AS ErrorProcedure,
     ERROR_LINE() AS ErrorLine,
     ERROR_MESSAGE() AS ErrorMessage;
GO

CREATE OR ALTER PROCEDURE [uspReviewABook]
	@bookID bigint,
	@userID integer,
	@rating integer,
	@description varchar(200) = NULL
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

CREATE OR ALTER PROCEDURE [uspRateAUser]
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

CREATE OR ALTER PROCEDURE [uspRateACopy]
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


CREATE OR ALTER PROCEDURE getBookCopiesAvailableByISBN @ISBN bigint
-- Looks for all available, i.e. unborrorowed/returned books in the library with that ISBN.
AS
    SELECT bookCopy.copyID
    FROM bookCopy
    WHERE bookID = @ISBN AND [dbo].[copyIsAvailable](copyID) = 'TRUE'
GO

CREATE OR ALTER PROCEDURE addCopyOfBook @ISBN bigint, @ownerID integer
AS
-- Adds a new copy of the book and returns it's copy ID
BEGIN
	DECLARE @copyID integer;

    INSERT INTO [dbo].[bookCopy]
		(bookID, ownerID, deleted)
    OUTPUT INSERTED.copyID AS copyID
    VALUES 
		( @ISBN, @ownerID, 0 )
END;
GO

CREATE OR ALTER PROCEDURE removeCopyOfBook @copyID integer
-- Removes a copy from the library
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE [bookCopy]
	SET deleted = 1
	where copyID = @copyID
END
GO

CREATE OR ALTER PROCEDURE getBooksByGenre @name varchar(20)
-- Gets books by Genre
AS
    SELECT book.ISBN, book.title, book.description, book.pages
    FROM book
    INNER JOIN bookGenre ON bookGenre.bookID = book.ISBN
    INNER JOIN genre ON bookGenre.genreID = genre.genreID
    WHERE genre.name = @name
GO

CREATE OR ALTER PROCEDURE getBooksByAuthor @firstNames varchar(120), @lastName varchar(120)
-- Gets books by Author
AS
    SELECT book.ISBN, book.title, book.description, book.pages
    FROM [dbo].[book]
    INNER JOIN [dbo].[bookAuthor] ON bookAuthor.bookID = book.ISBN
    INNER JOIN [dbo].[author] ON bookAuthor.authorID = author.authorID
    WHERE author.firstNames LIKE @firstNames AND author.lastName LIKE @lastName
GO

CREATE OR ALTER PROCEDURE getBooksByTitle @title varchar(120)
-- Gets books that include this as it's title
AS
    SELECT book.ISBN, book.title, book.description, book.pages
    FROM [dbo].[book]
    WHERE book.title LIKE '%' + @title + '%'
GO

CREATE OR ALTER PROCEDURE getBookByISBN @ISBN bigint
AS
    SELECT book.title, book.description, book.pages 
    FROM book
    WHERE book.ISBN = @ISBN
GO

CREATE OR ALTER PROCEDURE createBookRequest
@copyID integer,
@borrowerID integer,
@lendingDate DateTime,
@returnDate DateTime
AS
BEGIN
	INSERT INTO shareAgreement (copyID,borrowerID,lendingDate,returnDate,[state])
	VALUES (
		@copyID,
		@borrowerID,
		@lendingDate,
		@returnDate,
		(
			SELECT "as".stateID 
			FROM agreementState "as" 
			where "as".stateName = 'Pending'
		)
	)
END
GO

CREATE OR ALTER PROCEDURE setRequestStateByUsers
@shareAgreementId integer,
@state integer
AS
BEGIN
	UPDATE shareAgreement 
	SET "state" = @state
	where agreementID = @shareAgreementId
END
GO

CREATE OR ALTER PROCEDURE addUser
@username varchar(15)
-- Adds a user to the library
AS
BEGIN
	DECLARE @userID integer;

    INSERT INTO [user]
		( username, deleted )
    OUTPUT INSERTED.userID AS userID
    VALUES 
		( @username, 0 )
END
GO

CREATE OR ALTER PROCEDURE removeUser
@userID integer
-- Removes a user from the library
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE [user]
	SET deleted = 1
	where userID = @userID
END
GO

CREATE OR ALTER PROCEDURE AddBookAuthor
@authorId int,
@bookId bigint
AS
	INSERT INTO bookAuthor (authorID,bookID)
	VALUES (@authorId, @bookId)
GO

CREATE OR ALTER PROCEDURE HandleBookAuthor
@ISBN BIGINT,
@authorId int=null,
@firstNames varchar(120),
@lastname varchar(120),
@about varchar(1000)
AS
IF(@authorId IS NULL)
	Begin
		INSERT INTO author(firstNames, lastName, about)
		VALUES (@firstNames, @lastname, @about)
		DECLARE @newAuthorId int

		SET @newAuthorId = (SELECT SCOPE_IDENTITY())

		EXEC AddBookAuthor @authorId=@newAuthorId, @bookId=@ISBN
	END 
IF(@authorId IS NOT NULL)
BEGIN
	EXEC AddBookAuthor @bookId=@ISBN, @authorId=@authorId
END
GO

CREATE OR ALTER PROCEDURE addBookGenre
@genreId int,
@bookId bigint
AS
	INSERT INTO bookGenre(genreID,bookID)
	VALUES (@genreId, @bookId)
GO

CREATE OR ALTER PROCEDURE handleBookGenre
@genreId int=null,
@genreName varchar(20),
@bookId bigint
AS
IF(@genreId IS NULL)
Begin
	INSERT INTO genre("name")
	VALUES (@genreName)
	DECLARE @newGenreId int

	SET @newGenreId = (SELECT SCOPE_IDENTITY())

	EXEC AddBookGenre @genreId=@newGenreId, @bookId=@bookId
END 
IF(@genreId IS NOT NULL)
BEGIN
	EXEC addBookGenre @bookId=@bookId, @genreId=@genreId
END
GO

CREATE OR ALTER PROCEDURE addBookPublisher
@publisherId int,
@bookId bigint

AS
	INSERT INTO bookPublisher(publisherID,bookID)
	VALUES (@publisherId, @bookId)
GO

CREATE OR ALTER PROCEDURE handleBookPublisher
@publisherId int=null,
@publisherName varchar(20),
@bookId bigint

AS
IF(@publisherId IS NULL)
Begin
	INSERT INTO publisher("name")
	VALUES (@publisherName)
	DECLARE @newPublisherId int

	SET @newPublisherId = (SELECT SCOPE_IDENTITY())

	EXEC addBookPublisher @publisherId=@newPublisherId, @bookId=@bookId
END 
IF(@publisherId IS NOT NULL)
BEGIN
	EXEC addBookPublisher @bookId=@bookId, @publisherId=@publisherId
END
GO

CREATE OR ALTER PROCEDURE addBook
@ISBN BIGINT,
@title varchar(120),
@description varchar(1500),
@pages int,

@authorId int=null,
@firstNames varchar(120),
@lastname varchar(120),
@about varchar(1000),

@genreId varchar(max)=null,
@genreName varchar(20),

@publisherId int=null,
@publisherName varchar(20)

AS

	Declare @existsCheck bit
	set @existsCheck=(
		SELECT CASE WHEN EXISTS (
			SELECT 1 FROM book WHERE book.ISBN = 123456789
		)
		THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT) 
		END
	)
	if(@existsCheck=0)
	begin 
		INSERT INTO book (ISBN, title, description, pages)
		VALUES(@ISBN, @title, @description, @pages)
	end

	EXEC HandleBookAuthor @ISBN=@ISBN, @authorId=@authorId, @firstNames=@firstNames, @lastname=@lastname, @about=@about
	
	EXEC handleBookGenre @genreId=@genreId, @genreName=@genreName, @bookId=@ISBN

	EXEC handleBookPublisher @publisherId=@publisherId,@bookId=@ISBN, @publisherName=@publisherName
GO