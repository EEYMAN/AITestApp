# AI Chat Sessions App

A simple SwiftUI application for creating, displaying, and deleting AI chat sessions. Chat history is saved locally using Core Data.

## Architecture

- MVVM: separates view logic (ViewModel) from UI (View)
- Core Data: stores sessions and messages locally
- Combine: handles asynchronous updates and bindings
- Mock JSON: used as a fallback source on first app launch
- SwiftUI: builds the UI

## How to Run

1. Open *.xcodeproj or *.xcworkspace in Xcode 15+
2. Select a simulator and press `Run`
3. On first launch, sessions are loaded from `MockSessions.json` and cached in Core Data

## What’s Mocked

-  MockSessions.json` in `Bundle` simulates an API source
-  AI responses are mocked (`"AI says: ..."`) with a 1-second delay
-  No real external API integration is used

## Unit Test Coverage

Unit tests included for:
- `ChatViewModel`
- `SessionsListViewModel`
- `PersistenceController`

Run tests in Xcode using `⌘+U`.

## Improvement Ideas

- Real AI integration (e.g. OpenAI API)
- Multi-user support
- Customizable session categories
- Session filtering and sorting
- Message search feature
- Replace Combine with Swift Concurrency (async/await)
- UI improvements (autofocus, smooth scrolling, animations)

## Project Structure

├── Models/               // Data models (SessionModel, MessageModel)
├── ViewModels/           // ViewModels (ChatViewModel, SessionsListViewModel)
├── Views/                // SwiftUI Views
├── Resources/            // Mock JSON files
├── Tests/                // Unit tests

## Additional Info 

 I added an alert to the refresh button, which notifies users that sessions were updated successfully.
 I also added a way to delete outdated or unnecessary sessions manually.
 For convenience, I uploaded the project as a ZIP file — just download, unzip, and run it in Xcode.


