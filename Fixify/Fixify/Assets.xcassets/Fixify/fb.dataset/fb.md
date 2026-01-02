## Collections needed for technician flows

- `requests`  
  - Fields: `id` (string, doc id), `title` (string), `description` (string), `location` (string), `category` (string), `priority` (string: low/medium/high/urgent), `status` (string: pending/active/completed/cancelled), `createdBy` (string user id), `dateCreated` (timestamp), `imageURL` (string, nullable)

- `notifications`  
  - Fields: `id` (string), `userId` (string target), `requestId` (string), `type` (string: status_change/new_assignment), `message` (string), `createdAt` (timestamp), `read` (bool).  
  - Trigger: Cloud Function on `requests` or `request_updates` write to fan-out to students and admins when technicians mark requests active/completed.

- `users`  
  - Fields: `id` (string), `email` (string), `role` (string: student/technician/admin)
