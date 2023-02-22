USE BookShareDB;
GO;

CREATE PROCEDURE [uspGetErrorInfo]
AS
  SELECT
     ERROR_NUMBER() AS ErrorNumber,
	 ERROR_SEVERITY() AS ErrorSeverity,
	 ERROR_STATE() AS ErrorState,
     ERROR_PROCEDURE() AS ErrorProcedure,
     ERROR_LINE() AS ErrorLine,
     ERROR_MESSAGE() AS ErrorMessage;
GO;

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


CREATE OR ALTER PROCEDURE getBookCopiesAvailableByISBN @ISBN integer
-- Looks for all available, i.e. unborrorowed/returned books in the library with that ISBN.
AS
    SELECT bookCopy.copyID
    FROM bookCopy
    WHERE bookID = @ISBN AND copyIsAvailable(copyID) = 'TRUE'
GO;

CREATE OR ALTER PROCEDURE removeCopyOfBook @copyID
-- Removes a copy from the library
AS
    DELETE FROM bookCopy
    WHERE copyID = @copyID
GO;

CREATE OR ALTER PROCEDURE getBooksByGenre @name varchar
-- Gets books by Genre
AS
    SELECT book.ISBN, book.title, book.description, book.pages
    FROM book
    INNER JOIN bookGenre ON bookGenre.bookID = book.ISBN
    INNER JOIN genre ON bookGenre.genreID = genre.genreID
    WHERE genre.name = @name
GO;

CREATE OR ALTER PROCEDURE getBooksByAuthor @firstNames varchar, @lastName varchar
-- Gets books by Author
AS
    SELECT book.ISBN, book.title, book.description, book.pages
    FROM BookShareDB.book
    INNER JOIN BookShareDB.bookAuthor ON bookAuthor.bookID = book.ISBN
    INNER JOIN BookShareDB.author ON bookAuthor.authorID = author.authorID
    WHERE author.firstNames LIKE @firstNames AND author.lastName LIKE @lastName
GO;

CREATE OR ALTER PROCEDURE getBooksByTitle @title varchar
-- Gets books that include this as it's title
AS
    SELECT book.ISBN, book.title, book.description, book.pages
    FROM BookShareDB.book
    WHERE book.title LIKE '%' + @title + '%'
GO;

CREATE OR ALTER PROCEDURE getBookByISBN @ISBN integer
AS
    SELECT book.title, book.description, book.pages 
    FROM book
    WHERE book.ISBN = @ISBN
GO;