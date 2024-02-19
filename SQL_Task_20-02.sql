CREATE DATABASE Library2
USE Library2

CREATE TABLE Authors 
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(20),
    Surname NVARCHAR(20)
)

CREATE TABLE Books 
(
    Id INT PRIMARY KEY IDENTITY,
    Name VARCHAR(100) CHECK (LEN(Name) >= 2),
    AuthorId INT,
    PageCount INT CHECK (PageCount >= 10),
    FOREIGN KEY (AuthorId) REFERENCES Authors(Id)
)


INSERT INTO Authors(Name, Surname)
VALUES
('Name1', 'Surname1'),
('Name2', 'Surname2'),
('Name3', 'Surname3'),
('Name4', 'Surname4'),
('Name5', 'Surname5'),
('Name6', 'Surname6'),
('Name7', 'Surname7'),
('Name8', 'Surname8')



INSERT INTO Books(Name, AuthorId, PageCount)
VALUES
('BookName1', 1, 102),
('BookName2', 2, 142),
('BookName3', 5, 156),
('BookName4', 4, 189),
('BookName5', 3, 34),
('BookName6', 6, 166),
('BookName7', 7, 209),
('BookName8', 8, 135),
('BookName9', 4, 140),
('BookName10', 3, 89),
('BookName11', 3, 329),
('BookName12', 5, 298)


-- Books ve Authors table-larınız olsun
-- (one to many realtion) Id,Name,PageCount ve
-- AuthorFullName columnlarının valuelarını
-- qaytaran bir view yaradın

CREATE VIEW BookDetails AS
SELECT B.Id, B.Name, B.PageCount, CONCAT(A.Name, ' ', A.Surname) AS Fullname FROM Books AS B
JOIN Authors AS A ON A.Id = B.AuthorId

SELECT * FROM BookDetails

-- Göndərilmiş axtarış dəyərinə görə həmin axtarış
-- dəyəri name və ya authorFullName-lərində olan Book-ları
-- Id,Name,PageCount,AuthorFullName columnları şəklində
-- göstərən procedure yazın

CREATE PROCEDURE USP_SEARCH_BOOK_OR_AUTHOR
@SEARCH NVARCHAR(100)
AS
SELECT Id, Name, PageCount, Fullname FROM BookDetails AS BD
WHERE Name LIKE CONCAT('%', @SEARCH, '%') OR Fullname LIKE CONCAT('%', @SEARCH, '%')

EXEC USP_SEARCH_BOOK_OR_AUTHOR '3'


-- Book tabledaki verilmiş id-li datanın qiymıətini verilmiş yeni qiymətə update edən procedure yazın.

CREATE PROCEDURE USP_UPDATE_BOOK
@ID INT,
@NEW_PAGE_COUNT INT
AS
UPDATE Books
SET PageCount = @NEW_PAGE_COUNT
WHERE Books.Id = @ID

EXEC USP_UPDATE_BOOK 1, 200

SELECT * FROM BookDetails

-- Authors-ları Id,FullName,BooksCount,MaxPageCount şəklində qaytaran view yaradırsınız

CREATE VIEW AuthorDetails
AS
SELECT
A.Id,
CONCAT(A.Name, ' ', A.Surname) AS Fullname,
COUNT(B.Id) AS BookCount,
MAX(B.PageCount) AS MaxPageCount
FROM Authors AS A
LEFT JOIN Books AS B ON B.AuthorId = A.Id
GROUP BY A.Id, CONCAT(A.Name, ' ', A.Surname)

SELECT * FROM AuthorDetails
