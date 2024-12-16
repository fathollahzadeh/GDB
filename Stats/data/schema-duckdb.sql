-- Users
CREATE TABLE users (
Id INTEGER PRIMARY KEY,
Reputation INTEGER ,
CreationDate TIMESTAMP ,
Views INTEGER ,
UpVotes INTEGER ,
DownVotes INTEGER
);

-- Posts
CREATE TABLE posts (
	Id INTEGER PRIMARY KEY,
	PostTypeId SMALLINT ,
	CreationDate TIMESTAMP ,
	Score INTEGER ,
	ViewCount INTEGER,
	OwnerUserId INTEGER,
  AnswerCount INTEGER ,
  CommentCount INTEGER ,
  FavoriteCount INTEGER,
  LastEditorUserId INTEGER
);

-- PostLinks
CREATE TABLE postLinks (
	Id INTEGER PRIMARY KEY,
	CreationDate TIMESTAMP ,
	PostId INTEGER ,
	RelatedPostId INTEGER ,
	LinkTypeId SMALLINT
);

-- PostHistory
CREATE TABLE postHistory (
	Id INTEGER PRIMARY KEY,
	PostHistoryTypeId SMALLINT ,
	PostId INTEGER ,
	CreationDate TIMESTAMP ,
	UserId INTEGER
);

-- Comments
CREATE TABLE comments (
	Id INTEGER PRIMARY KEY,
	PostId INTEGER ,
	Score SMALLINT ,
  CreationDate TIMESTAMP ,
	UserId INTEGER
);

-- Votes
CREATE TABLE votes (
	Id INTEGER PRIMARY KEY,
	PostId INTEGER,
	VoteTypeId SMALLINT ,
	CreationDate TIMESTAMP ,
	UserId INTEGER,
	BountyAmount SMALLINT
);

-- Badges
CREATE TABLE badges (
	Id INTEGER PRIMARY KEY,
	UserId INTEGER ,
	Date TIMESTAMP
);

-- Tags
CREATE TABLE tags (
	Id INTEGER PRIMARY KEY,
	Count INTEGER ,
	ExcerptPostId INTEGER
);

create index idx_posts_owneruserid on posts(owneruserid);
create index  idx_posts_lasteditoruserid on posts(lasteditoruserid);
create index idx_postlinks_relatedpostid on postLinks(relatedpostid);
create index idx_postlinks_postid on postLinks(postid);
create index idx_posthistory_postid on postHistory(postid);
create index idx_posthistory_userid on postHistory(userid);
create index idx_comments_postid on comments(postid);
create index idx_comments_userid on comments(userid);
create index idx_votes_userid on votes(userid);
create index idx_votes_postid on votes(postid);
create index idx_badges_userid on badges(userid);
create index idx_tags_excerptpostid on tags(excerptpostid);
analyze badges;
analyze comments;
analyze posthistory;
analyze postlinks;
analyze posts;
analyze tags;
analyze users;
analyze votes;

COPY users FROM '../../../data/stats_simplified/users.csv' (DELIMITER ',');
COPY posts FROM '../../../data/stats_simplified/posts.csv' (DELIMITER ',');
COPY postLinks FROM '../../../data/stats_simplified/postLinks.csv' (DELIMITER ',');
COPY postHistory FROM '../../../data/stats_simplified/postHistory.csv' (DELIMITER ',');
COPY comments FROM '../../../data/stats_simplified/comments.csv' (DELIMITER ',');
COPY votes FROM '../../../data/stats_simplified/votes.csv' (DELIMITER ',');
COPY badges FROM '../../../data/stats_simplified/badges.csv' (DELIMITER ',');
COPY tags FROM '../../../data/stats_simplified/tags.csv' (DELIMITER ',');
