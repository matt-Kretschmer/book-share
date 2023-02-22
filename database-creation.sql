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
  [username] varchar UNIQUE NOT NULL
)
GO

CREATE TABLE [userEmail] (
  [email] varchar PRIMARY KEY NOT NULL,
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
  [ISBN] integer PRIMARY KEY NOT NULL,
  [title] varchar NOT NULL,
  [description] varchar NOT NULL,
  [pages] integer NOT NULL,
)
GO

CREATE TABLE [genre] (
  [genreID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [name] varchar UNIQUE NOT NULL
)
GO

CREATE TABLE [bookGenre] (
  [bookGenreID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [genreID] integer FOREIGN KEY REFERENCES [genre]([genreID]) NOT NULL,
  [bookID] integer FOREIGN KEY REFERENCES [book]([ISBN]) NOT NULL
)
GO

CREATE TABLE [author] (
  [authorID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [firstNames] varchar NOT NULL,
  [lastName] varchar NOT NULL,
  [about] varchar NOT NULL
)
GO

CREATE TABLE [bookAuthor] (
  [bookAuthorID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [authorID] integer FOREIGN KEY REFERENCES [author]([authorID]) NOT NULL,
  [bookID] integer FOREIGN KEY REFERENCES [book]([ISBN]) NOT NULL
)
GO

CREATE TABLE [publisher] (
  [publisherID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [name] varchar NOT NULL
)
GO

CREATE TABLE [bookPublisher] (
  [bookPublisherID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [publisherID] integer FOREIGN KEY REFERENCES [publisher]([publisherID]) NOT NULL,
  [bookID] integer FOREIGN KEY REFERENCES [book] ([ISBN]) NOT NULL
)
GO

CREATE TABLE [bookReview] (
  [bookReviewID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [bookID] integer FOREIGN KEY REFERENCES [book]([ISBN]) NOT NULL,
  [userID] integer FOREIGN KEY REFERENCES [user] ([userID]) NOT NULL,
  [rating] integer NOT NULL CHECK(rating > 0 AND rating < 6),
  [description] varchar NULL
)
GO

CREATE TABLE [bookCopy] (
  [copyID] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
  [bookID] integer FOREIGN KEY REFERENCES [book]([ISBN]) NOT NULL,
  [ownerID] integer FOREIGN KEY REFERENCES [user]([userID]) NOT NULL
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
  [stateName] varchar NOT NULL
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