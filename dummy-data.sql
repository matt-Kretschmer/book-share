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