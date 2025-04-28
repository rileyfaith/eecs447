-- Membership Types
INSERT INTO Membership_Type (type, borrowing_limit, daily_late_fee, extra_fees) VALUES
('Regular', 5, 0.50, 0.00),
('Student', 7, 0.25, 5.00),
('Senior', 6, 0.30, 2.50);

-- Clients
INSERT INTO Client (client_id, client_name, contact_info, publication_date, membership_type, account_status) VALUES
(1, 'Alice Johnson', 'alice@example.com', '2023-05-01', 'Regular', 'Active'),
(2, 'Bob Smith', 'bob@example.com', '2023-06-15', 'Student', 'Active'),
(3, 'Carol White', 'carol@example.com', '2023-07-20', 'Senior', 'Inactive'),
(4, 'David Lee', 'david@example.com', '2024-01-10', 'Regular', 'Active'),
(5, 'Eve Torres', 'eve@example.com', '2024-02-11', 'Student', 'Active');

-- Books
INSERT INTO Book (book_id, title, author, isbn, publication_year, genre, availability_status, popularity) VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 1925, 'Fiction', 'Available', 8),
(2, '1984', 'George Orwell', '9780451524935', 1949, 'Dystopian', 'CheckedOut', 10),
(3, 'To Kill a Mockingbird', 'Harper Lee', '9780061120084', 1960, 'Classic', 'Available', 9),
(4, 'The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 1951, 'Classic', 'Reserved', 7),
(5, 'Sapiens', 'Yuval Noah Harari', '9780062316097', 2011, 'History', 'Available', 8);

-- Media
INSERT INTO Media (media_id, title, creator, media_type, isbn, publication_year, genre, availability_status, popularity) VALUES
(1, 'Becoming', 'Michelle Obama', 'Audiobook', '9781524763138', 2018, 'Biography', 'Available', 7),
(2, 'The Martian', 'Andy Weir', 'Ebook', '9780804139021', 2014, 'Science Fiction', 'Reserved', 9),
(3, 'Dune', 'Frank Herbert', 'Audiobook', '9780441172719', 1965, 'Sci-Fi', 'CheckedOut', 8),
(4, 'Cosmos', 'Carl Sagan', 'Video', '9780345331359', 1980, 'Science', 'Available', 6);

-- Magazines
INSERT INTO Magazine (magazine_id, title, issue_number, publication_date, availability_status, popularity) VALUES
(1, 'National Geographic', '2023-09', '2023-09-01', 'Available', 6),
(2, 'Time', '2023-10', '2023-10-01', 'CheckedOut', 7),
(3, 'Forbes', '2023-11', '2023-11-01', 'Available', 5),
(4, 'Wired', '2024-01', '2024-01-01', 'Reserved', 4);

-- Loans
INSERT INTO Loan (loan_id, client_id, item_type, media_id, book_id, magazine_id, borrow_date, due_date, return_date, fees_accrued) VALUES
(1, 1, 'Book', NULL, 1, NULL, '2024-04-01', '2024-04-15', NULL, 0.00),
(2, 2, 'E-book', 2, NULL, NULL, '2024-04-10', '2024-04-20', NULL, 0.00),
(3, 3, 'Magazine', NULL, NULL, 1, '2024-03-01', '2024-03-10', '2024-03-11', 0.30),
(4, 4, 'Audiobook', 3, NULL, NULL, '2024-04-15', '2024-04-25', NULL, 0.00),
(5, 5, 'Book', NULL, 5, NULL, '2024-04-18', '2024-05-01', NULL, 0.00);

-- Reservations
INSERT INTO Reservation (reservation_id, client_id, item_type, media_id, book_id, magazine_id, reservation_date, status, place_in_line) VALUES
(1, 1, 'Audiobook', 1, NULL, NULL, '2024-04-25', 'Processing', 1),
(2, 2, 'Book', NULL, 2, NULL, '2024-04-26', 'In line', 2),
(3, 4, 'Video', 4, NULL, NULL, '2024-04-20', 'Ready for pickup', 1),
(4, 5, 'Magazine', NULL, NULL, 4, '2024-04-22', 'Processing', 1);

-- Notifications
INSERT INTO Notification (notification_id, client_id, message) VALUES
(1, 1, 'Your audiobook is ready for pickup.'),
(2, 2, 'The book you reserved is now available.'),
(3, 4, 'The video Cosmos is ready for pickup.'),
(4, 5, 'Your magazine reservation is being processed.');

-- Gets
INSERT INTO Gets (client_id, notification_id) VALUES
(1, 1),
(2, 2),
(4, 3),
(5, 4);

-- Has
INSERT INTO Has (type, client_id) VALUES
('Regular', 1),
('Student', 2),
('Senior', 3),
('Regular', 4),
('Student', 5);

-- Takes
INSERT INTO Takes (client_id, loan_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Loaned
INSERT INTO Loaned (loan_id, media_id, magazine_id, book_id) VALUES
(1, NULL, NULL, 1),
(2, 2, NULL, NULL),
(3, NULL, 1, NULL),
(4, 3, NULL, NULL),
(5, NULL, NULL, 5);

-- Reserved
INSERT INTO Reserved (reservation_id, media_id, magazine_id, book_id) VALUES
(1, 1, NULL, NULL),
(2, NULL, NULL, 2),
(3, 4, NULL, NULL),
(4, NULL, 4, NULL);

-- Reserves
INSERT INTO Reserves (client_id, reservation_id) VALUES
(1, 1),
(2, 2),
(4, 3),
(5, 4);
