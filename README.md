TECHNO

TECHNO is a social media app built using Flutter during an internship at THINK. This project integrates various features, including authentication, an API feed, and user profiles with photo and name management. The app demonstrates best practices in Flutter development and uses Firebase for backend services.

Features

1. Authentication

Firebase Authentication: Users can sign up, log in, and log out using Firebase's secure authentication service.

2. Rick and Morty API Integration

Displays data from the Rick and Morty API, providing users with character information.
Search Functionality: Users can search for their favorite characters from the Rick and Morty universe using a search bar, with real-time filtering of results.

3. Feed Tab

The feed tab allows users to view and interact with posts.

Each post supports:

Likes: Users can like posts, and the like count updates in real-time.

Comments: Users can comment on posts, with all comments being stored and retrieved via Firebase.

4. User Profiles

Users have customizable profiles where they can:

Change their display name: Editable directly from the profile screen.

Upload or change profile photos: Handled via Firebase Storage, allowing users to store their profile pictures securely.

5. Real-time Features

The feed and profile information are updated in real-time using Firestore streams, ensuring a dynamic and interactive user experience.

