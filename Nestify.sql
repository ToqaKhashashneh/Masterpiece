
drop database Nestify;

CREATE TABLE Properties (
    PropertyID INT PRIMARY KEY IDENTITY(1,1),
    PropertyName NVARCHAR(255) NOT NULL,
    LocationID INT NOT NULL,
    SublocationID INT NOT NULL,
	    UserID INT NULL,
    Bedrooms INT NOT NULL,
	Bathrooms INT NOT NULL DEFAULT 1,
    Size DECIMAL(10,2) NOT NULL, -- In square meters or feet
    Price DECIMAL(18,2) NOT NULL,
	IsFeatured BIT DEFAULT 0, -- 0 = Not Featured, 1 = Featured
	 Description NVARCHAR(MAX) NULL,
    YearBuilt INT NULL,
    LotArea DECIMAL(10,2) NULL,
    LotDimensions NVARCHAR(255) NULL,
    PropertyStatus NVARCHAR(255) NULL CHECK (PropertyStatus IN ('For Sale', 'For Rent', 'Sold')),
    VideoURL NVARCHAR(500) NULL, -- URL for property video
	Latitude DECIMAL(9,6) NULL,
    Longitude DECIMAL(9,6) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
    FOREIGN KEY (SublocationID) REFERENCES Sublocations(SublocationID)
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL;
);

CREATE TABLE Locations (
    LocationID INT PRIMARY KEY IDENTITY(1,1),
    LocationName NVARCHAR(255) UNIQUE NOT NULL
);


CREATE TABLE Sublocations (
    SublocationID INT PRIMARY KEY IDENTITY(1,1),
    SublocationName NVARCHAR(255) NOT NULL,
    LocationID INT NOT NULL,
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);


CREATE TABLE PropertyImages (
    ImageID INT PRIMARY KEY IDENTITY(1,1),
    PropertyID INT NOT NULL,
    ImageURL NVARCHAR(500) NOT NULL, -- Store image file path or URL
    IsPrimary BIT DEFAULT 0, -- 1 for main image, 0 for additional images
    UploadedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID) ON DELETE CASCADE
);


CREATE TABLE MainFocusSections (
    SectionID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    ImageURL NVARCHAR(500) NULL, -- Optional icon or image
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE InteriorDesignImages (
    ImageID INT PRIMARY KEY IDENTITY(1,1),
    ImageURL NVARCHAR(500) NOT NULL, -- Path or URL of the image
    Description NVARCHAR(500) NULL, -- Optional text for the image
    UploadedAt DATETIME DEFAULT GETDATE()
);


CREATE TABLE Testimonials (
    TestimonialID INT PRIMARY KEY IDENTITY(1,1),
    ClientName NVARCHAR(255) NOT NULL,
    ClientImageURL NVARCHAR(500) NULL, -- Path or URL of the client's image
    Message NVARCHAR(MAX) NOT NULL, -- Testimonial text
    FeedbackSection NVARCHAR(255) NOT NULL, -- Example: 'Interior Design', 'Property Purchase', etc.
    SubmittedAt DATETIME DEFAULT GETDATE()
);


CREATE TABLE Blogs (
    BlogID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(500) NOT NULL,
    ImageURL NVARCHAR(500) NULL, -- Thumbnail image for the blog
    PublishedDate DATETIME DEFAULT GETDATE(),
    ReadMoreURL NVARCHAR(500) NOT NULL -- Link to the full blog post
);

CREATE TABLE PropertyFeatures (
    FeatureID INT PRIMARY KEY IDENTITY(1,1),
    PropertyID INT NOT NULL,
    FeatureName NVARCHAR(255) NOT NULL, -- e.g., Living Room, Garage
    Size NVARCHAR(50) NOT NULL, -- e.g., "20 x 16 sq m"
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID) ON DELETE CASCADE
);


CREATE TABLE Amenities (
    AmenityID INT PRIMARY KEY IDENTITY(1,1),
    AmenityName NVARCHAR(255) UNIQUE NOT NULL -- e.g., 'Air Conditioning', 'Swimming Pool'
);


CREATE TABLE PropertyAmenities (
    PropertyID INT NOT NULL,
    AmenityID INT NOT NULL,
    PRIMARY KEY (PropertyID, AmenityID),
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID) ON DELETE CASCADE,
    FOREIGN KEY (AmenityID) REFERENCES Amenities(AmenityID) ON DELETE CASCADE
);


CREATE TABLE FloorPlans (
    FloorPlanID INT PRIMARY KEY IDENTITY(1,1),
    PropertyID INT NOT NULL,
    FloorName NVARCHAR(255) NOT NULL, -- e.g., "First Floor", "Garden"
    ImageURL NVARCHAR(500) NOT NULL, -- Floor plan image URL
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID) ON DELETE CASCADE
);


CREATE TABLE PropertyInquiries (
    InquiryID INT PRIMARY KEY IDENTITY(1,1),
    PropertyID INT NOT NULL,
    Name NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    SubmittedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID) ON DELETE CASCADE
);


CREATE TABLE InteriorDesignInquiries (
    InquiryID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    SubmittedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Lawyers (
    LawyerID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Specialization NVARCHAR(255) NOT NULL, -- e.g., Real Estate Law, Property Transactions
    ImageURL NVARCHAR(500) NULL, -- Lawyer's profile image
    CreatedAt DATETIME DEFAULT GETDATE()
);



CREATE TABLE LegalServiceRequests (
    RequestID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,
    ServiceType NVARCHAR(50) NOT NULL CHECK (ServiceType IN ('Home Buying', 'Home Selling', 'Consulting Service')),
    Message NVARCHAR(MAX) NOT NULL,
    LawyerID INT NULL, -- Assign a lawyer (optional)
    Status NVARCHAR(50) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'In Progress', 'Completed')), -- Tracks request progress
    SubmittedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (LawyerID) REFERENCES Lawyers(LawyerID) ON DELETE SET NULL -- If lawyer is deleted, request remains
);

CREATE TABLE ContactInfo (
    ContactID INT PRIMARY KEY IDENTITY(1,1),
    Type NVARCHAR(50) NOT NULL CHECK (Type IN ('Email', 'Phone', 'Location')),
    Value NVARCHAR(500) NOT NULL
);


CREATE TABLE ContactInquiries (
    InquiryID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,
    ServiceType NVARCHAR(50) NOT NULL CHECK (ServiceType IN ('Home Buying', 'Home Selling', 'Interior Design', 'Consulting Service')),
    Message NVARCHAR(MAX) NOT NULL,
	AssignedTo NVARCHAR(50) NOT NULL DEFAULT 'General Support' CHECK (AssignedTo IN ('Sales', 'Legal', 'Interior Design', 'General Support')),
    Status NVARCHAR(50) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'In Progress', 'Resolved')),
    SubmittedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE InquiryResponses (
    ResponseID INT PRIMARY KEY IDENTITY(1,1),
    InquiryID INT NOT NULL,
    AdminName NVARCHAR(255) NOT NULL, -- Admin responding
    ResponseMessage NVARCHAR(MAX) NOT NULL,
    RespondedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (InquiryID) REFERENCES ContactInquiries(InquiryID) ON DELETE CASCADE
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL, -- Store hashed password
    PhoneNumber NVARCHAR(20) NULL,
	ProfileImageURL NVARCHAR(500) NULL,
    Address NVARCHAR(255) NULL,
    City NVARCHAR(100) NULL,
    Country NVARCHAR(100) NULL
);

CREATE TABLE FavoriteProperties (
    FavoriteID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    PropertyID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID) ON DELETE CASCADE
);






CREATE TABLE AdminMessages (
    MessageID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    ServiceType NVARCHAR(50) NOT NULL CHECK (ServiceType IN ('Home Buying', 'Home Selling', 'Interior Design', 'Consulting Service')),
    PhoneNumber NVARCHAR(20) NULL,
    Email NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    SentAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod NVARCHAR(50) NOT NULL CHECK (PaymentMethod IN ('Credit Card', 'PayPal', 'Bank Transfer')),
    Status NVARCHAR(50) NOT NULL CHECK (Status IN ('Pending', 'Completed', 'Failed')),
    PaymentDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
