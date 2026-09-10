-- SCHEMA

CREATE TABLE Category (
    id_category INT GENERATED ALWAYS AS IDENTITY,
    category_name VARCHAR(100) NOT NULL,
    CONSTRAINT pk_category PRIMARY KEY (id_category)
);

CREATE TABLE Book (
    id_book INT GENERATED ALWAYS AS IDENTITY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(150) NOT NULL,
    category_id INT,
    CONSTRAINT pk_book PRIMARY KEY (id_book),
    CONSTRAINT fk_book_category FOREIGN KEY (category_id)
        REFERENCES Category(id_category) ON DELETE SET NULL
);

CREATE TABLE Member (
    id_member INT GENERATED ALWAYS AS IDENTITY,
    member_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT pk_member PRIMARY KEY (id_member),
    CONSTRAINT uq_member_email UNIQUE (email)
);

CREATE TABLE Loan (
    id_loan INT GENERATED ALWAYS AS IDENTITY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    loan_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    CONSTRAINT pk_loan PRIMARY KEY (id_loan),
    CONSTRAINT fk_loan_member FOREIGN KEY (member_id)
        REFERENCES Member(id_member) ON DELETE RESTRICT,
    CONSTRAINT fk_loan_book FOREIGN KEY (book_id)
        REFERENCES Book(id_book) ON DELETE RESTRICT,
    CONSTRAINT chk_status CHECK (status IN ('returned', 'active', 'overdue'))
);

-- 2. SAMPLE DATA

INSERT INTO Category (category_name) VALUES
('Fantasy'),              -- id_category = 1
('Science Fiction'),      -- id_category = 2
('Classic Literature'),   -- id_category = 3
('Programming');          -- id_category = 4

INSERT INTO Book (title, author, category_id) VALUES
('The Hobbit', 'J.R.R. Tolkien', 1),                          -- id_book = 1
('Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', 1), -- id_book = 2
('A Game of Thrones', 'George R.R. Martin', 1),                -- id_book = 3
('Dune', 'Frank Herbert', 2),                                  -- id_book = 4
('Foundation', 'Isaac Asimov', 2),                             -- id_book = 5
('Neuromancer', 'William Gibson', 2),                          -- id_book = 6
('Nineteen Eighty-Four', 'George Orwell', 3),                  -- id_book = 7
('Pride and Prejudice', 'Jane Austen', 3),                     -- id_book = 8
('Moby-Dick', 'Herman Melville', 3),                           -- id_book = 9
('Clean Code', 'Robert C. Martin', 4),                         -- id_book = 10
('The Pragmatic Programmer', 'Andrew Hunt', 4),                -- id_book = 11
('Design Patterns', 'Erich Gamma', 4),                         -- id_book = 12
('Brave New World', 'Aldous Huxley', 3),                       -- id_book = 13 (never loaned)
('The Left Hand of Darkness', 'Ursula K. Le Guin', 2),         -- id_book = 14 (never loaned)
('The Silmarillion', 'J.R.R. Tolkien', 1);                     -- id_book = 15 (never loaned)

INSERT INTO Member (member_name, email, registration_date) VALUES
('Alice Johnson',  'alice.johnson@example.com',  '2025-11-01'), -- id_member = 1
('Bruno Silva',    'bruno.silva@example.com',    '2025-11-03'), -- id_member = 2
('Carla Mendes',   'carla.mendes@example.com',   '2025-11-10'), -- id_member = 3
('Diego Santos',   'diego.santos@example.com',   '2025-12-01'), -- id_member = 4
('Elena Costa',    'elena.costa@example.com',    '2025-12-05'), -- id_member = 5
('Felipe Rocha',   'felipe.rocha@example.com',   '2026-01-02'), -- id_member = 6
('Gabriela Lima',  'gabriela.lima@example.com',  '2026-01-10'), -- id_member = 7
('Hugo Almeida',   'hugo.almeida@example.com',   '2026-01-15'); -- id_member = 8 (never made a loan)

INSERT INTO Loan (member_id, book_id, loan_date, return_date, status) VALUES
(1,  1, '2026-01-05', '2026-01-20', 'returned'), -- Alice - The Hobbit
(1,  2, '2026-01-10', '2026-01-25', 'returned'), -- Alice - Harry Potter
(1,  4, '2026-02-01', '2026-02-15', 'returned'), -- Alice - Dune
(1, 10, '2026-08-01',  NULL,        'active'),   -- Alice - Clean Code
(1,  3, '2026-02-20', '2026-03-05', 'returned'), -- Alice - A Game of Thrones

(2,  2, '2026-01-12', '2026-01-28', 'returned'), -- Bruno - Harry Potter
(2,  5, '2026-02-05', '2026-02-19', 'returned'), -- Bruno - Foundation
(2,  7, '2026-03-01',  NULL,        'overdue'),  -- Bruno - Nineteen Eighty-Four
(2, 10, '2026-04-10', '2026-04-24', 'returned'), -- Bruno - Clean Code

(3,  1, '2026-01-15', '2026-01-29', 'returned'), -- Carla - The Hobbit
(3,  4, '2026-02-10', '2026-02-24', 'returned'), -- Carla - Dune
(3,  8, '2026-08-05',  NULL,        'active'),   -- Carla - Pride and Prejudice
(3, 11, '2026-03-15', '2026-03-29', 'returned'), -- Carla - The Pragmatic Programmer

(4,  9, '2026-02-01', '2026-02-15', 'returned'), -- Diego - Moby-Dick
(4,  6, '2026-08-10',  NULL,        'active'),   -- Diego - Neuromancer

(5,  2, '2026-03-01', '2026-03-15', 'returned'), -- Elena - Harry Potter

(6, 12, '2026-04-01', '2026-04-15', 'returned'), -- Felipe - Design Patterns

(7,  1, '2026-02-25',  NULL,        'overdue');  -- Gabriela - The Hobbit

-- Exercises 1-10
-- Exercise 1 - Relating Members and Loans (INNER JOIN)
SELECT
    m.member_name,
    m.email,
    l.loan_date,
    l.status
FROM Member m
INNER JOIN Loan l ON l.member_id = m.id_member
ORDER BY l.loan_date;

-- Exercise 2 - Relating Members, Books and Loans (JOIN across 3 tables)
SELECT
    m.member_name,
    b.title,
    b.author,
    l.loan_date,
    l.status
FROM Loan l
INNER JOIN Member m ON m.id_member = l.member_id
INNER JOIN Book   b ON b.id_book   = l.book_id
ORDER BY l.loan_date;

-- Exercise 3 - Members without loans (LEFT JOIN)
-- Step 1: all members, including those who never made a loan.
SELECT
    m.member_name,
    l.id_loan,
    l.loan_date,
    l.status
FROM Member m
LEFT JOIN Loan l ON l.member_id = m.id_member
ORDER BY m.member_name;

-- Step 2: only the members who never borrowed a book.
SELECT
    m.member_name,
    m.email
FROM Member m
LEFT JOIN Loan l ON l.member_id = m.id_member
WHERE l.id_loan IS NULL;

-- Exercise 4 - Books that were never loaned
SELECT
    b.title,
    b.author,
    c.category_name
FROM Book b
LEFT JOIN Loan l ON l.book_id = b.id_book
LEFT JOIN Category c ON c.id_category = b.category_id
WHERE l.id_loan IS NULL;

-- Exercise 5 - Counting loans per member (COUNT + GROUP BY + JOIN)
SELECT
    m.member_name,
    COUNT(l.id_loan) AS total_loans
FROM Member m
INNER JOIN Loan l ON l.member_id = m.id_member
GROUP BY m.member_name
ORDER BY total_loans DESC;

-- Exercise 6 - Most active members (COUNT + GROUP BY + HAVING)
SELECT
    m.member_name,
    COUNT(l.id_loan) AS total_loans
FROM Member m
INNER JOIN Loan l ON l.member_id = m.id_member
GROUP BY m.member_name
HAVING COUNT(l.id_loan) > 3
ORDER BY total_loans DESC;

-- Exercise 7 - Most borrowed books
SELECT
    b.title,
    b.author,
    COUNT(l.id_loan) AS times_borrowed
FROM Book b
LEFT JOIN Loan l ON l.book_id = b.id_book
GROUP BY b.id_book, b.title, b.author
ORDER BY times_borrowed DESC, b.title ASC
LIMIT 5;

-- Exercise 8 - Loans by status (COUNT + GROUP BY)
SELECT
    status,
    COUNT(*) AS total
FROM Loan
GROUP BY status
ORDER BY total DESC;

-- Logic Challenge: Popular category
SELECT
    c.category_name,
    COUNT(l.id_loan) AS total_loans
FROM Category c
INNER JOIN Book b ON b.category_id = c.id_category
INNER JOIN Loan l ON l.book_id = b.id_book
GROUP BY c.category_name
ORDER BY total_loans DESC;