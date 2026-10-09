# ExpiTrack: Food Expiration Tracker

A mobile app that helps you track the food in your kitchen and see at a glance what's fresh, what's about to expire, and what needs to go.

Built by a team of three for a senior-year software engineering course (spring 2026), and documented, tested, and presented as if for a real company.

## Overview

ExpiTrack keeps your food inventory and expiration dates in one centralized place. It focuses on organization, accessibility, and everyday convenience when managing groceries. The project delivers a functional prototype (MVP) that demonstrates inventory tracking, notifications, and user interaction.

## The problem

Food waste is a persistent problem for households. Expiration dates get forgotten, it's hard to see how fresh things are, and food is spread across refrigerators, counters, and cupboards with no central record. Many existing grocery and pantry apps rely on manual input only, lack clear visual indicators, or overwhelm users with features they don't need. As a result, people often throw food out unnecessarily or eat items past their safe use date.

There's a need for a simple, reliable tool that helps people track freshness, spot items nearing expiration, and make informed decisions about what to eat and what to buy.

## The solution

ExpiTrack lets users add food items by hand, by photo, or by scanning an expiration date with the phone's camera. Each item is stored in the app and shown with a color-coded freshness status, and the app helps with grocery planning by suggesting items that are running out of time. The design prioritizes usability, clear feedback, and a manageable technical scope, while demonstrating solid software engineering practice: modular design, input validation, testing, and documentation.

## Features

- **Add items manually**, or **upload or capture a photo** of the food
- **Scan expiration dates with the camera**
- **Automatic expiration classification** with color-coded freshness indicators
- **Edit and delete** items
- **Grocery list suggestions** for items that are expiring
- **Notifications** for expiring items
- **Persistent storage**, so items stay saved after the app restarts

### How freshness status works

| Status | Color | Rule |
|---|---|---|
| Fresh | Green | More than 3 days until expiration |
| Expiring soon | Yellow | 3 days or less until expiration |
| Expired | Red | Past the expiration date |

## Screenshots

TODO: add simulator or device screenshots to a `docs/` folder and link them here.

![Dashboard](Pic/Dashboard_Screen.png)
![Add item](Pic/Add-item.png)
![Grocery suggestions](Pic/Grocery-list.png)

## Tech stack

| Area | Tools |
|---|---|
| Language and UI | Swift, SwiftUI |
| Camera and image picker | UIKit |
| IDEs | Xcode, Visual Studio Code |
| Unit testing | XCTest |
| UI testing | Xcode Simulator |
| Version control and collaboration | Git and GitHub |

## Testing

| Area | Test case | Expected result | Result |
|---|---|---|---|
| Expiration accuracy | Item with more than 3 days left | Marked fresh (green) | Correct |
| Expiration accuracy | Item with 3 days or less left | Marked expiring soon (yellow) | Correct |
| Expiration accuracy | Expired item | Marked expired (red) | Correct |
| Grocery logic | Expiring item | Suggested for the grocery list | Correct |
| Grocery logic | Non-expiring item | No suggestion | Correct |
| Data persistence | Restart the app | Items remain saved | Correct |
| Image handling | Add a photo | Image displays correctly | Correct |
| Scanner detection | Clearly printed date | Correct date detected and added to the date field | Mostly correct; dates must be fairly clear on the packaging |

## UX review

**Strengths:** clean dashboard layout, colored status indicators, a simple workflow, familiar iOS interactions, and automated grocery suggestions.

**Weaknesses:** scanner accuracy depends on the condition of the packaging, edit and delete are harder to find than other features, and onboarding is limited.

## Known limitations

- The date scanner works best when the date is clearly printed. Worn or hard-to-read packaging lowers accuracy.
- Edit and delete are less discoverable than the app's other features.
- There is very little onboarding for new users.

## Roadmap

- Barcode scanning and basic meal suggestions (both in the original proposal)
- Better scanner accuracy on worn packaging
- A short onboarding flow and more visible edit and delete actions

## Project timeline

The project followed a 16-week plan:

| Weeks | Phase | Work |
|---|---|---|
| 1-6 | Initial deliverables and planning | Project proposal, requirements gathering, and functional specification |
| 7-11 | Design and core development | UI design and the major features: item entry, inventory management, expiration tracking, and notifications; working prototype |
| 11-13 | Testing and iteration | System testing, debugging, and improvements within the MVP scope |
| 14-16 | Finalization and delivery | Final polish, documentation, and delivery with a presentation and supporting materials |

The team estimated the project at about 1,754 lines of code, or roughly $2,100 at an industry-average rate of $1.20 per line.

## Team

| Name | Role |
|---|---|
| Makayla Coleman | Team leader, frontend developer, testing, UI/UX design |
| Vonnie Magnussen | Team manager, backend developer, database setup, logic integration |
| David LaMore | Backend developer, testing, logic integration and database support |

## Getting started

TODO: confirm the project file name and any setup steps.

1. Clone the repo: `git clone https://github.com/Coop-3/Food-scanner-app.git`
2. Open the project in **Xcode** (on a Mac).
3. Choose an iPhone simulator or a connected iPhone and press **Run**.

Camera scanning needs a physical iPhone, since the iOS simulator doesn't have a camera.
