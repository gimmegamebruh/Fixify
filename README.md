==========================
README – Fixify Application
==========================

App Name:
Fixify – Student Maintenance Request System

--------------------------------------------------

GitHub Repository (Public):
https://github.com/gimmegamebruh/Fixify.git
--------------------------------------------------

Group Members:
1. Ebrahim Murad – 202305504
2. Hasan Marhoon 202303596
3. Salman Alnaar - 202303491
4. Sayed Ali Almusawi – 202304831
5. Mohamed Abdulla - 202304048


--------------------------------------------------

Main Features:

| Feature                                  | Developer        | Tester           |
|------------------------------------------|------------------|------------------|
| Login & Authentication           	   | Salman Alnaar    | Mohamed Abdulla  |
| Create Maintenance Request               | Ebrahim Murad    | Ahmed Almubark   |
| Edit / Cancel Pending Requests           | Ebrahim Murad    | Ahmed Almubark   |
| Request Status Tracking                  | Ebrahim Murad    | Ahmed Almubark   |
| Technician Role & Access Management      | Salman Alnaar    | Mohamed Abdulla  |
| manage assigned maintenance requests     | Ahmed Al Mubarak | Ebrahim Murad    |
| View, Schedule and Manage upcoming       | Ahmed Al Mubarak | Ebrahim Murad    |
  assigned jobs​
| Admin Request Management & Assignment    | Hasan Marhoon      Sayed ali         
| Admin Dashboard Analytics		     Hasan Marhoon	Sayed ali
| Notifications                            | Sayed Ali        | Hasan Marhoon    |
| Student Feedback/Rating                  | Sayed Ali        | Hasan Marhoon    |
| Profile & Settings                       | Mohammed Abdulla | Salman Alnaar    |
| Inventory Management System 		   | Mohammed Abdulla | Salman Alnaar    |


--------------------------------------------------

Design Changes:
- Improved card-based UI for better readability
- Simplified navigation using role-based tab bars
- Updated priority and category pickers for consistency
- Enhanced responsive layout for iPhone and iPad
- Merged the Profile into the Settings 
- Added products used in request details before a request in set to completed
- Product code is manually entered when registering a product into the system

--------------------------------------------------

Libraries / Packages / External Code Used:
- Firebase Authentication
- Firebase Firestore
- Firebase Storage
- Cloudinary (Image Upload)
- PHPickerViewController (Apple Photos Picker)

--------------------------------------------------

Project Setup Instructions:

1. Clone the repository:
   git clone https://github.com/gimmegamebruh/Fixify.git

2. Open the project in Xcode:
   Fixify.xcworkspace

3. Install dependencies (if needed):
   - Ensure Firebase is configured correctly
   - GoogleService-Info.plist must be included

4. Run the project using Xcode on a simulator or real device.

--------------------------------------------------

Simulators Used for Testing:
- iPhone 15 Pro
- iPhone 15 Pro Max
- iPhone 16
- iPhone 16 Pro Max
- iPad Pro (12.9-inch)

--------------------------------------------------

Admin Login Credentials (For Testing):

Email: admin@fixify.com  
Password: 123456
Email: student@fixify.com  
Password: 123456
Email: technician@fixify.com  
Password: 123456

--------------------------------------------------
