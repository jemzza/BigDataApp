#  Big Data App

<img src="/PREVIEW.gif" width="25%">

## About
The app displays top films by income. Users can sort films by name, ID, and income, as well as search for films by name. 
Firebase is used for the backend. In the initial commits, a JSON file is used for data.
Firestore indexes are utilized for correct search and sorting. The app is available on macOS, iPhone, and iPad.
The pagination mechanism has been implemented

## UI and UX
Simple UI: list and filters, search field
Localized for english and russian via R.swift library


## Architecture
MVVM with a Clean adaptation is used. DIContainer is integrated to simplify further improvements in UI flow.

ViewModel and View are placed in the Presentation layer. The ViewModel contains necessary services (gateways) and accesses them via interfaces.

In the Domain layer, there are Entities (models) and UseCases (interactors). Gateways are located in the Data layer.
