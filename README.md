# MiniGitClient-iOS
Simple Master-Detail iOS app where you can see the top rated Swift repositories and a list of latest pull requests for each repository.

# Architecture
This app uses a VIPER based architecture with the following components:
* Coordinator - Responsible for routing, dependency injection and scenes setup
* View Controller - User interface component
* Presenter - Presentation logic manager. Handles both UI interactions and model distribution
* Interactor - Fetchs model data for the presenter
* Model - Simple Entity representation
All those components are connected using reactive bindings and protocols.
