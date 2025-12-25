Fields to add for technician flows

- requests
  - assignedTo: string (technician id)
  - scheduledTime: timestamp (nullable)
  - status: string (pending/active/completed/cancelled)
  - lastUpdatedAt: timestamp
  - lastUpdatedBy: string (user id)
  - assignedToName: string (optional, for quick display)
  - lastUpdatedByName: string (optional)

- request_updates (collection or subcollection)
  - requestId: string
  - status: string
  - updatedBy: string (user id)
  - updatedByRole: string
  - updatedAt: timestamp
  - note: string (optional)

- users
  - id: string
  - name: string
  - role: string (student/technician/admin)
  - technicianId: string (optional, maps to assignments)
