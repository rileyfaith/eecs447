-- Book table
CREATE TABLE Book (
    book_id INTEGER PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    author VARCHAR(500) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    publication_year INTEGER NOT NULL,
    genre VARCHAR(500) NOT NULL,
    availability_status TEXT CHECK (availability_status IN ('Available', 'CheckedOut', 'Reserved')) DEFAULT 'Available',
    popularity INTEGER
);

-- Media table
CREATE TABLE Media (
    media_id INTEGER PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    creator VARCHAR(500) NOT NULL,
    media_type TEXT CHECK (media_type IN ('Ebook', 'Audiobook', 'Video')) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    publication_year INTEGER NOT NULL,
    genre VARCHAR(500) NOT NULL,
    availability_status TEXT CHECK (availability_status IN ('Available', 'CheckedOut', 'Reserved')) DEFAULT 'Available',
    popularity INTEGER
);

-- Magazine table
CREATE TABLE Magazine (
    magazine_id INTEGER PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    issue_number VARCHAR(20) NOT NULL,
    publication_date DATE NOT NULL,
    availability_status TEXT CHECK (availability_status IN ('Available', 'CheckedOut', 'Reserved')) DEFAULT 'Available',
    popularity INTEGER
);

-- Membership_Type table
CREATE TABLE Membership_Type (
    type TEXT PRIMARY KEY CHECK (type IN ('Regular', 'Student', 'Senior')),
    borrowing_limit INTEGER CHECK (borrowing_limit > 0) NOT NULL,
    daily_late_fee DECIMAL(5,2) CHECK (daily_late_fee >= 0) NOT NULL,
    extra_fees DECIMAL(5,2) CHECK (extra_fees >= 0) NOT NULL
);

-- Client table
CREATE TABLE Client (
    client_id INTEGER PRIMARY KEY,
    client_name VARCHAR(500) NOT NULL,
    contact_info VARCHAR(500) NOT NULL,
    publication_date DATE NOT NULL,
    membership_type TEXT DEFAULT 'Regular',
    account_status TEXT CHECK (account_status IN ('Active', 'Inactive')) DEFAULT 'Active',
    FOREIGN KEY (membership_type) REFERENCES Membership_Type(type)
);

-- Loan table
CREATE TABLE Loan (
    loan_id INTEGER PRIMARY KEY,
    client_id INTEGER,
    item_type TEXT CHECK (item_type IN ('Book', 'E-book', 'Audiobook', 'Video', 'Magazine')) NOT NULL,
    media_id INTEGER,
    book_id INTEGER,
    magazine_id INTEGER,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fees_accrued DECIMAL(5,2) CHECK (fees_accrued >= 0),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (media_id) REFERENCES Media(media_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (magazine_id) REFERENCES Magazine(magazine_id)
);

-- Reservation table
CREATE TABLE Reservation (
    reservation_id INTEGER PRIMARY KEY,
    client_id INTEGER,
    item_type TEXT CHECK (item_type IN ('Book', 'E-book', 'Audiobook', 'Video', 'Magazine')) NOT NULL,
    media_id INTEGER,
    book_id INTEGER,
    magazine_id INTEGER,
    reservation_date DATE NOT NULL,
    status TEXT CHECK (status IN ('Ready for pickup', 'In line', 'Processing')) DEFAULT 'Processing',
    place_in_line INTEGER,
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (media_id) REFERENCES Media(media_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (magazine_id) REFERENCES Magazine(magazine_id)
);

-- Notification table
CREATE TABLE Notification (
    notification_id INTEGER PRIMARY KEY,
    client_id INTEGER,
    message TEXT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id)
);

-- Gets table (client receives notifications) - many-to-many
CREATE TABLE Gets (
    client_id INTEGER,
    notification_id INTEGER,
    PRIMARY KEY (client_id, notification_id),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (notification_id) REFERENCES Notification(notification_id)
);

-- Has table (client has membership type) - many-to-many
CREATE TABLE Has (
    type TEXT,
    client_id INTEGER,
    PRIMARY KEY (type, client_id),
    FOREIGN KEY (type) REFERENCES Membership_Type(type),
    FOREIGN KEY (client_id) REFERENCES Client(client_id)
);

-- Takes table (client takes loans) - many-to-many
CREATE TABLE Takes (
    client_id INTEGER,
    loan_id INTEGER,
    PRIMARY KEY (client_id, loan_id),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id)
);

-- Loaned table (loans linked to items) - many-to-many
CREATE TABLE Loaned (
    loan_id INTEGER,
    media_id INTEGER,
    magazine_id INTEGER,
    book_id INTEGER,
    PRIMARY KEY (loan_id),
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id),
    FOREIGN KEY (media_id) REFERENCES Media(media_id),
    FOREIGN KEY (magazine_id) REFERENCES Magazine(magazine_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

-- Reserved table (reservation linked to items) - many-to-many
CREATE TABLE Reserved (
    reservation_id INTEGER,
    media_id INTEGER,
    magazine_id INTEGER,
    book_id INTEGER,
    PRIMARY KEY (reservation_id),
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id),
    FOREIGN KEY (media_id) REFERENCES Media(media_id),
    FOREIGN KEY (magazine_id) REFERENCES Magazine(magazine_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

-- Reserves table (client reserves items) - many-to-many
CREATE TABLE Reserves (
    client_id INTEGER,
    reservation_id INTEGER,
    PRIMARY KEY (client_id, reservation_id),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id)
);
