# high_flyers_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



todo:

-update marker on map when skipping a stop

-add location being written to database periodically for order tracking and live logistics manager in the future

-make sure that a driver is only assigned a run if it is optimised. Maybe store optimised route in the assignedRuns in driver doc.

-update flash/startup screen to bird logo

-when "arrived" is clicked a form should show up asking for basic information like did they collection payment, Did they pick up the correct quantity etc.
-form should show button saying "submit" or "complete". This will release the next stop.













//gemini response to concern of JWT hijacking and flooding of documents with inproper structure


Addressing the Flooding Concern
Even with strict security rules, a legitimate user could still try to abuse the system. Here's how a malicious user might "spam" your database and how to prevent it:

1. The "JWT Hijacking" Scenario:

The user doesn't need to "grab" the JWT in the traditional sense. Since they are a legitimate user, they already have a valid JWT. They could simply write a script that uses this JWT to create thousands of documents.

Mitigation:

Rate Limiting on the Server (Cloud Functions): This is the most robust solution. Instead of allowing direct writes, you can create a Cloud Function that acts as an API endpoint. The client app calls this function to submit an order.

The Cloud Function can then perform additional validation and security checks before writing to Firestore.

Crucially, you can implement rate limiting within the Cloud Function. For example, you could track the number of orders submitted by a user in a given time period and reject requests that exceed a certain threshold.

Firestore Rules-based Rate Limiting (Less Robust): While not as effective as Cloud Functions, you can use Firestore rules to limit writes. This is more complex and has limitations. For example, you could store a lastWriteTime for each user and prevent them from writing more than once every minute.

match /users/{userId} {
  // This is a simple example and can be complex to manage
  allow write: if request.time > resource.data.lastWriteTime + duration.value(1, 'm');
}
2. The "Denial of Service" Attack:

A malicious user could try to create massive, bloated documents to consume your database's resources and storage limits.

Mitigation:

Document Size Restrictions in Security Rules: You can and should validate the size and shape of the documents being written.

match /orders/{orderId} {
  allow create: if request.auth != null
                && request.resource.data.keys().hasAll(['items', 'total']) // Ensure required fields are present
                && request.resource.data.items is list
                && request.resource.data.items.size() <= 50 // Limit the number of items
                && request.resource.data.total is number; // Validate data types
}

Recommendations
For a production application, the most secure and scalable approach is a hybrid model:

Use Firestore Security Rules for basic access control. This is a non-negotiable first step. Always validate request.auth and user roles.

For critical write operations (like order submission), use a Cloud Function. This allows you to:

Implement server-side rate limiting.

Perform complex business logic and data validation.

Cleanse and transform data before writing it to the database.

Trigger other backend processes (e.g., sending a confirmation email, updating inventory).

Summary
Direct client writes to Firestore are secure if and only if you have comprehensive and well-thought-out Firestore Security Rules. However, for preventing a malicious user from flooding your database with legitimate-looking documents, server-side rate limiting via a Cloud Function is the most effective and recommended solution. It adds a layer of control that you cannot achieve with rules alone.