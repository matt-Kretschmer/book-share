INSERT INTO [user](username, deleted)
VALUES ('matt', 0),
('jade', 0),
('morgan', 0),
('oara', 0);

INSERT INTO [userEmail](email, userID)
VALUES ('matt@gmail.com', 1),
('jade@gmail.com', 2),
('morgan@bbd.com', 3),
('oiasuifoksdhfsadfsa@woohoo.com', 4);

INSERT INTO [userRating](userID, rating)
VALUES (1, 5),
(2, 4),
(3, 3),
(4, 2);

INSERT INTO [agreementState] (stateID, stateName) 
VALUES 
(0, 'Pending'),
(1, 'Accepted'),
(2, 'Denied'),
(3, 'Received'),
(4, 'Returned')
GO

INSERT INTO [book] ([ISBN], [title], [description], [pages])
VALUES	('9780451526342', 'Animal Farm', 'A farm is taken over by its overworked, mistreated animals. With flaming idealism and stirring slogans, they set out to create a paradise of progress, justice, and equality. Thus the stage is set for one of the most telling satiric fables ever penned –a razor-edged fairy tale for grown-ups that records the evolution from revolution against tyranny to a totalitarianism just as terrible. When Animal Farm was first published, Stalinist Russia was seen as its target. Today it is devastatingly clear that wherever and whenever freedom is attacked, under whatever banner, the cutting clarity and savage comedy of George Orwell’s masterpiece have a meaning and message still ferociously fresh.', '141'),
		('9780684801520', 'The Great Gatsby', 'This is the definitive, textually accurate edition of a classic of twentieth-century literature, The Great Gatsby. The story of the fabulously wealthy Jay Gatsby and his love for the beautiful Daisy Buchanan has been acclaimed by generations of readers. But the first edition contained a number of errors resulting from Fitzgerald''s extensive revisions and a rushed production schedule. Subsequent printings introduced further departures from the author''s words. This edition, based on the Cambridge critical text, restores all the language of Fitzgerald''s masterpiece. Drawing on the manuscript and surviving proofs of the novel, along with Fitzgerald''s later revisions and corrections, this is the authorized text -- The Great Gatsby as Fitzgerald intended it.', '216'),
		('9780007491568', 'Fahrenheit 451', 'The terrifyingly prophetic novel of a post-literate future. Guy Montag is a fireman. His job is to burn books, which are forbidden, being the source of all discord and unhappiness. Even so, Montag is unhappy; there is discord in his marriage. Are books hidden in his house? The Mechanical Hound of the Fire Department, armed with a lethal hypodermic, escorted by helicopters, is ready to track down those dissidents who defy society to preserve and read books. The classic dystopian novel of a post-literate future, Fahrenheit 451 stands alongside Orwell’s 1984 and Huxley’s Brave New World as a prophetic account of Western civilization’s enslavement by the media, drugs and conformity. Bradbury’s powerful and poetic prose combines with uncanny insight into the potential of technology to create a novel which, decades on from first publication, still has the power to dazzle and shock.', '227'),
		('9780684830490', 'The Old Man and the Sea', 'This short novel, already a modern classic, is the superbly told, tragic story of a Cuban fisherman in the Gulf Stream and the giant Marlin he kills and loses—specifically referred to in the citation accompanying the author''s Nobel Prize for literature in 1954.', '96'),
		('9780452284234', '1984', 'The new novel by George Orwell is the major work towards which all his previous writing has pointed. Critics have hailed it as his "most solid, most brilliant" work. Though the story of Nineteen Eighty-Four takes place thirty-five years hence, it is in every sense timely. The scene is London, where there has been no new housing since 1950 and where the city-wide slums are called Victory Mansions. Science has abandoned Man for the State. As every citizen knows only too well, war is peace. To Winston Smith, a young man who works in the Ministry of Truth (Minitru for short), come two people who transform this life completely. One is Julia, whom he meets after she hands him a slip reading, "I love you." The other is O''Brien, who tells him, "We shall meet in the place where there is no darkness." The way in which Winston is betrayed by the one and, against his own desires and instincts, ultimately betrays the other, makes a story of mounting drama and suspense.', '368');
GO

DECLARE @genreID integer

INSERT INTO [genre] ([name])
VALUES ('Classics')
SET @genreID = SCOPE_IDENTITY()

INSERT INTO [bookGenre] ([bookID], [genreID])
VALUES ('9780451526342', @genreID),
	   ('9780684801520', @genreID),
	   ('9780007491568', @genreID),
	   ('9780684830490', @genreID),
	   ('9780452284234', @genreID);

INSERT INTO [genre] ([name])
VALUES ('Fiction')
SET @genreID = SCOPE_IDENTITY()

INSERT INTO [bookGenre] ([bookID], [genreID])
VALUES ('9780451526342', @genreID),
	   ('9780684801520', @genreID),
	   ('9780007491568', @genreID),
	   ('9780684830490', @genreID),
	   ('9780452284234', @genreID);

INSERT INTO [genre] ([name])
VALUES ('Adventure')
SET @genreID = SCOPE_IDENTITY()

INSERT INTO [bookGenre] ([bookID], [genreID])
VALUES ('9780684830490', @genreID);

INSERT INTO [genre] ([name])
VALUES ('Science Fiction')
SET @genreID = SCOPE_IDENTITY()

INSERT INTO [bookGenre] ([bookID], [genreID])
VALUES ('9780007491568', @genreID),
	   ('9780452284234', @genreID);

INSERT INTO [genre] ([name])
VALUES ('Politics')
SET @genreID = SCOPE_IDENTITY()

INSERT INTO [bookGenre] ([bookID], [genreID])
VALUES ('9780451526342', @genreID),
	   ('9780452284234', @genreID);

INSERT INTO [genre] ([name])
VALUES ('Dystopia')
SET @genreID = SCOPE_IDENTITY()

INSERT INTO [bookGenre] ([bookID], [genreID])
VALUES ('9780451526342', @genreID),
	   ('9780007491568', @genreID),
	   ('9780452284234', @genreID);

INSERT INTO [genre] ([name])
VALUES ('Historical Fiction')
SET @genreID = SCOPE_IDENTITY()

INSERT INTO [bookGenre] ([bookID], [genreID])
VALUES ('9780684801520', @genreID);

INSERT INTO [genre] ([name])
VALUES ('Romance')
SET @genreID = SCOPE_IDENTITY()

INSERT INTO [bookGenre] ([bookID], [genreID])
VALUES ('9780684801520', @genreID);
GO

DECLARE @authorID integer

INSERT INTO [author] ([firstNames], [lastName], [about])
VALUES ('George', 'Orwell', 'Eric Arthur Blair, better known by his pen name George Orwell, was an English author and journalist. His work is marked by keen intelligence and wit, a profound awareness of social injustice, an intense opposition to totalitarianism, a passion for clarity in language, and a belief in democratic socialism.');
SET @authorID = SCOPE_IDENTITY()

INSERT INTO [bookAuthor] ([bookID], [authorID])
VALUES ('9780451526342', @authorID),
	   ('9780452284234', @authorID);

INSERT INTO [author] ([firstNames], [lastName], [about])
VALUES ('Francis Scott Key', 'Fitzgerald', 'Francis Scott Key Fitzgerald was an American writer of novels and short stories, whose works have been seen as evocative of the Jazz Age, a term he himself allegedly coined. He is regarded as one of the greatest twentieth century writers. Fitzgerald was of the self-styled "Lost Generation," Americans born in the 1890s who came of age during World War I. He finished four novels, left a fifth unfinished, and wrote dozens of short stories that treat themes of youth, despair, and age. He was married to Zelda Fitzgerald.');
SET @authorID = SCOPE_IDENTITY()

INSERT INTO [bookAuthor] ([bookID], [authorID])
VALUES ('9780684801520', @authorID);

INSERT INTO [author] ([firstNames], [lastName], [about])
VALUES ('Ray Douglas', 'Bradbury', 'Ray Douglas Bradbury, American novelist, short story writer, essayist, playwright, screenwriter and poet, was born August 22, 1920 in Waukegan, Illinois. He graduated from a Los Angeles high school in 1938. Although his formal education ended there, he became a "student of life," selling newspapers on L.A. street corners from 1938 to 1942, spending his nights in the public library and his days at the typewriter. He became a full-time writer in 1943, and contributed numerous short stories to periodicals before publishing a collection of them, Dark Carnival, in 1947.');
SET @authorID = SCOPE_IDENTITY()

INSERT INTO [bookAuthor] ([bookID], [authorID])
VALUES ('9780007491568', @authorID);

INSERT INTO [author] ([firstNames], [lastName], [about])
VALUES ('Ernest Miller', 'Hemingway', 'Ernest Miller Hemingway was an American author and journalist. His economical and understated style had a strong influence on 20th-century fiction, while his life of adventure and his public image influenced later generations. Hemingway produced most of his work between the mid-1920s and the mid-1950s, and won the Nobel Prize in Literature in 1954. He published seven novels, six short story collections and two non-fiction works. Three novels, four collections of short stories and three non-fiction works were published posthumously. Many of these are considered classics of American literature.');
SET @authorID = SCOPE_IDENTITY()

INSERT INTO [bookAuthor] ([bookID], [authorID])
VALUES ('9780684830490', @authorID);
GO

DECLARE @publisherID integer

INSERT INTO [publisher] ([name])
VALUES ('Signet Classics');
SET @publisherID = SCOPE_IDENTITY()

INSERT INTO [bookPublisher] ([publisherID], [bookID])
VALUES (@publisherID, '9780451526342');

INSERT INTO [publisher] ([name])
VALUES ('Scribner');
SET @publisherID = SCOPE_IDENTITY()

INSERT INTO [bookPublisher] ([publisherID], [bookID])
VALUES (@publisherID, '9780684801520'),
	   (@publisherID, '9780684830490');

INSERT INTO [publisher] ([name])
VALUES ('Harper Voyager');
SET @publisherID = SCOPE_IDENTITY()

INSERT INTO [bookPublisher] ([publisherID], [bookID])
VALUES (@publisherID, '9780007491568');

INSERT INTO [publisher] ([name])
VALUES ('Plume');
SET @publisherID = SCOPE_IDENTITY()

INSERT INTO [bookPublisher] ([publisherID], [bookID])
VALUES (@publisherID, '9780452284234');
GO