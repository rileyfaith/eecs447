--Database schema for library management system

-- Book table: stores info about the books in the library
CREATE TABLE Book (
    book_id INTEGER PRIMARY KEY, -- Unique identifier for each book
    title VARCHAR(500) NOT NULL,
    author VARCHAR(500) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL, -- ISBN number is unique
    publication_year INTEGER NOT NULL,
    genre VARCHAR(500) NOT NULL,
    availability_status TEXT CHECK (availability_status IN ('Available', 'CheckedOut', 'Reserved')) DEFAULT 'Available', -- Availability status of book with default being 'Available'
    popularity INTEGER -- optional
);

-- Media table: stores info about the various media types (ebook, audiobook, video)
CREATE TABLE Media (
    media_id INTEGER PRIMARY KEY, -- Unique identifier for each media item
    title VARCHAR(500) NOT NULL,
    creator VARCHAR(500) NOT NULL,
    media_type TEXT CHECK (media_type IN ('Ebook', 'Audiobook', 'Video')) NOT NULL, -- Media type must be either 'Ebook', 'Audiobook', or 'Video'
    isbn VARCHAR(13) UNIQUE NOT NULL, -- ISBN number is unique
    publication_year INTEGER NOT NULL,
    genre VARCHAR(500) NOT NULL,
    availability_status TEXT CHECK (availability_status IN ('Available', 'CheckedOut', 'Reserved')) DEFAULT 'Available', -- Availability status of media item with default being 'Available'
    popularity INTEGER --optional
);

-- Magazine table: stores info about the magazines in the library
CREATE TABLE Magazine (
    magazine_id INTEGER PRIMARY KEY, -- Unique identifier for each magazine
    title VARCHAR(500) NOT NULL,
    issue_number VARCHAR(20) NOT NULL,
    publication_date DATE NOT NULL,
    availability_status TEXT CHECK (availability_status IN ('Available', 'CheckedOut', 'Reserved')) DEFAULT 'Available', -- Availability status of magazine with default being 'Available'
    popularity INTEGER --optional
);

-- Membership_Type table: defines the different types of memberships in the library
CREATE TABLE Membership_Type (
    type TEXT PRIMARY KEY CHECK (type IN ('Regular', 'Student', 'Senior')), -- Membership type must be either 'Regular', 'Student', or 'Senior'
    borrowing_limit INTEGER CHECK (borrowing_limit > 0) NOT NULL, -- Max number of items a member can borrow
    daily_late_fee DECIMAL(5,2) CHECK (daily_late_fee >= 0) NOT NULL, -- Daily fee for late returns
    extra_fees DECIMAL(5,2) CHECK (extra_fees >= 0) NOT NULL -- Extra fees
);

-- Client table: stores info about clients (members)
CREATE TABLE Client (
    client_id INTEGER PRIMARY KEY, -- Unique identifier for each client
    client_name VARCHAR(500) NOT NULL,
    contact_info VARCHAR(500) NOT NULL,
    publication_date DATE NOT NULL,
    membership_type TEXT DEFAULT 'Regular', -- Type of membership (defaults to Regular)
    account_status TEXT CHECK (account_status IN ('Active', 'Inactive')) DEFAULT 'Active', -- Status of the client’s account (defaults to Active)
    FOREIGN KEY (membership_type) REFERENCES Membership_Type(type) -- Reference to the Membership_Type table
);

-- Loan table: stores info about items borrowed by clients
CREATE TABLE Loan (
    loan_id INTEGER PRIMARY KEY, --Unique identifier for each loan
    client_id INTEGER,
    item_type TEXT CHECK (item_type IN ('Book', 'E-book', 'Audiobook', 'Video', 'Magazine')) NOT NULL, -- Type of item borrowed
    media_id INTEGER, -- Media item borrowed (if applicable)
    book_id INTEGER, -- book borrowed (if applicable)
    magazine_id INTEGER, -- Magazine borrowed (if applicable)
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fees_accrued DECIMAL(5,2) CHECK (fees_accrued >= 0), -- Late fees that have accrued
    FOREIGN KEY (client_id) REFERENCES Client(client_id), -- Reference to the Client table
    FOREIGN KEY (media_id) REFERENCES Media(media_id), -- Reference to the Media table
    FOREIGN KEY (book_id) REFERENCES Book(book_id), -- Reference to the Book table
    FOREIGN KEY (magazine_id) REFERENCES Magazine(magazine_id) -- Reference to the Magazine table
);

-- Reservation table: stores info about items reserved by clients
CREATE TABLE Reservation (
    reservation_id INTEGER PRIMARY KEY, -- Unique identifier for each reservation
    client_id INTEGER,
    item_type TEXT CHECK (item_type IN ('Book', 'E-book', 'Audiobook', 'Video', 'Magazine')) NOT NULL, -- Type of item reserved
    media_id INTEGER, -- Media item reserved (if applicable)
    book_id INTEGER, -- Book reserved (if applicable)
    magazine_id INTEGER, -- Magazine reserved (if applicable)
    reservation_date DATE NOT NULL,
    status TEXT CHECK (status IN ('Ready for pickup', 'In line', 'Processing')) DEFAULT 'Processing', -- Status of the reservation (default is Processing)
    place_in_line INTEGER,
    FOREIGN KEY (client_id) REFERENCES Client(client_id), -- Reference to the Client table
    FOREIGN KEY (media_id) REFERENCES Media(media_id), -- Reference to the Media table
    FOREIGN KEY (book_id) REFERENCES Book(book_id), -- Reference to the Book table
    FOREIGN KEY (magazine_id) REFERENCES Magazine(magazine_id) -- Reference to the Magazine table
);

-- Notification table: stores notifications sent to clients
CREATE TABLE Notification (
    notification_id INTEGER PRIMARY KEY, -- Unique identifier for each notification
    client_id INTEGER,
    message TEXT NOT NULL, -- Content of the notification
    FOREIGN KEY (client_id) REFERENCES Client(client_id) -- Reference to the Client table
);

-- Gets table (client receives notifications) - many-to-many relationship between clients and notifications, tracks which clients recieve which notifications
CREATE TABLE Gets (
    client_id INTEGER,
    notification_id INTEGER,
    PRIMARY KEY (client_id, notification_id),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (notification_id) REFERENCES Notification(notification_id)
);

-- Has table (client has membership type) - many-to-many relationship between clients and membership types
CREATE TABLE Has (
    type TEXT,
    client_id INTEGER,
    PRIMARY KEY (type, client_id), -- Composite primary key
    FOREIGN KEY (type) REFERENCES Membership_Type(type), -- Reference to the Membership_Type table
    FOREIGN KEY (client_id) REFERENCES Client(client_id) -- Reference to the Client table
);

-- Takes table (client takes loans) - many-to-many relationship between clients and loans
CREATE TABLE Takes (
    client_id INTEGER,
    loan_id INTEGER,
    PRIMARY KEY (client_id, loan_id), -- Composite primary key
    FOREIGN KEY (client_id) REFERENCES Client(client_id), -- Reference to the Client table
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id) -- Reference to the Loan table
);

-- Loaned table (loans linked to items) - many-to-many relationship between loans and items, tracks which items are associated with which loans
CREATE TABLE Loaned (
    loan_id INTEGER,
    media_id INTEGER,
    magazine_id INTEGER,
    book_id INTEGER,
    PRIMARY KEY (loan_id), -- Primary key is loan_id
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id), -- Reference to the Loan table
    FOREIGN KEY (media_id) REFERENCES Media(media_id), -- Reference to the Media table
    FOREIGN KEY (magazine_id) REFERENCES Magazine(magazine_id), -- Reference to the Magazine table
    FOREIGN KEY (book_id) REFERENCES Book(book_id) -- Reference to the Book table
);

-- Reserved table (reservation linked to items) - many-to-many relationship between reservations and items, tracks which items are associated with which reservations
CREATE TABLE Reserved (
    reservation_id INTEGER,
    media_id INTEGER,
    magazine_id INTEGER,
    book_id INTEGER,
    PRIMARY KEY (reservation_id), -- Primary key is reservation_id
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id), -- Reference to the Reservation table
    FOREIGN KEY (media_id) REFERENCES Media(media_id), -- Reference to the Media table
    FOREIGN KEY (magazine_id) REFERENCES Magazine(magazine_id), -- Reference to the Magazine table
    FOREIGN KEY (book_id) REFERENCES Book(book_id) -- Reference to the Book table
); 

-- Reserves table (client reserves items) - many-to-many relationship between clients and reservations
CREATE TABLE Reserves (
    client_id INTEGER,
    reservation_id INTEGER,
    PRIMARY KEY (client_id, reservation_id), -- Composite primary key
    FOREIGN KEY (client_id) REFERENCES Client(client_id), -- Reference to the Client table
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id) -- Reference to the Reservation table
);
