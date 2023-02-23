USE master;
GO

IF EXISTS(select * from sys.databases where name='BookShareDB')
DROP DATABASE BookShareDB;
GO

CREATE DATABASE BookShareDB;
Go

USE BookShareDB;
GO

CREATE TABLE [user] (
  [userID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [username] varchar(15) UNIQUE NOT NULL,
  [deleted] BIT NOT NULL
)
GO

CREATE TABLE [userEmail] (
  [email] varchar(120) PRIMARY KEY NOT NULL,
  [userID] integer FOREIGN KEY REFERENCES [user]([userID]) NOT NULL
)
GO

CREATE TABLE [userRating] (
  [userRatingID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [userID] integer FOREIGN KEY REFERENCES [user]([userID]) NOT NULL,
  [rating] integer NOT NULL CHECK(rating > 0 AND rating < 6)
)
GO

CREATE TABLE [book] (
  [ISBN] bigint PRIMARY KEY NOT NULL,
  [title] varchar(120) NOT NULL,
  [description] varchar(1500) NOT NULL,
  [pages] integer NOT NULL,
)
GO

CREATE TABLE [genre] (
  [genreID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [name] varchar(20) UNIQUE NOT NULL
)
GO

CREATE TABLE [bookGenre] (
  [bookGenreID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [genreID] integer FOREIGN KEY REFERENCES [genre]([genreID]) NOT NULL,
  [bookID] bigint FOREIGN KEY REFERENCES [book]([ISBN]) NOT NULL
)
GO

CREATE TABLE [author] (
  [authorID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [firstNames] varchar(120) NOT NULL,
  [lastName] varchar(120) NOT NULL,
  [about] varchar(1000) NOT NULL
)
GO

CREATE TABLE [bookAuthor] (
  [bookAuthorID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [authorID] integer FOREIGN KEY REFERENCES [author]([authorID]) NOT NULL,
  [bookID] bigint FOREIGN KEY REFERENCES [book]([ISBN]) NOT NULL
)
GO

CREATE TABLE [publisher] (
  [publisherID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [name] varchar(120) NOT NULL
)
GO

CREATE TABLE [bookPublisher] (
  [bookPublisherID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [publisherID] integer FOREIGN KEY REFERENCES [publisher]([publisherID]) NOT NULL,
  [bookID] bigint FOREIGN KEY REFERENCES [book] ([ISBN]) NOT NULL
)
GO

CREATE TABLE [bookReview] (
  [bookReviewID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [bookID] bigint FOREIGN KEY REFERENCES [book]([ISBN]) NOT NULL,
  [userID] integer FOREIGN KEY REFERENCES [user] ([userID]) NOT NULL,
  [rating] integer NOT NULL CHECK(rating > 0 AND rating < 6),
  [description] varchar(200) NULL
)
GO

CREATE TABLE [bookCopy] (
  [copyID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [bookID] bigint FOREIGN KEY REFERENCES [book]([ISBN]) NOT NULL,
  [ownerID] integer FOREIGN KEY REFERENCES [user]([userID]) NOT NULL,
  [deleted] BIT NOT NULL
)
GO

CREATE TABLE [copyConditionRating] (
  [copyConditionRatingID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [copyID] integer FOREIGN KEY REFERENCES [bookCopy]([copyID]) NOT NULL,
  [rating] integer NOT NULL CHECK(rating > 0 AND rating < 6),
  [ratingDate] date NOT NULL CHECK(ratingDate <= CAST((GETDATE()) AS date))
)
GO

CREATE TABLE [agreementState] (
  [stateID] integer PRIMARY KEY NOT NULL,
  [stateName] varchar(20) NOT NULL
)
GO

CREATE TABLE [shareAgreement] (
  [agreementID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [copyID] integer FOREIGN KEY REFERENCES [bookCopy]([copyID]) NOT NULL,
  [ownerID] integer FOREIGN KEY REFERENCES [user]([userID]) NOT NULL,
  [borrowerID] integer FOREIGN KEY REFERENCES [user]([userID]) NOT NULL,
  [lendingDate] date NOT NULL,
  [returnDate] date NOT NULL,
  [state] integer FOREIGN KEY REFERENCES [agreementState]([stateID]) NOT NULL
)
GO

ALTER TABLE [shareAgreement] ADD CONSTRAINT 
	ckShareDates CHECK((lendingDate > (CAST((GETDATE()) AS date)) AND (returnDate > lendingDate)))
GO