# downAppTest

Hi!

The main focus of my work was to replicate the UI/UX as closely as possible while keeping the architecture simple yet testable.

Given the constraints of 4 hours, I decided to go with SwiftUI as it allows me to focus on the UI itself, rather than writing boilerplate code.

This is a quite simple thin client; the only goal of it is to download backend data and display it to the user. There is no heavy client logic, so a simple MV architecture should be enough.

For the sake of time, I made a couple of simplifications:

* There is no proper Dependency Container. Normally, I'd use Swinject to manage dependencies, but just for one service, it seems to be overkill. Using the SwiftUI Environment for this case is quite enough.
* Normally, we don't want to use Backend models directly; we'd build a Mapper to transform it into a domain model. But for this test app, it's not that important.
* Across the views, there are still some magic design numbers, but mostly it's one-time usage, and it's quite straightforward.
* Networking and ErrorHandler might be a bit overkill for this small app, but it's my common way to handle networking, and it's quite easy to hook up.
* There is no business logic except for fetching profiles, so there is a UnitTest only to check if the API is working and the model mapping is correct.
* Most UI States are tested within Previews of SwiftUI.
* There is room for UI tests, of course, for that I'd need to set up some accessibility ids and write e2e tests.
* Localization is missing, but it would be easy with the new xcstrings.catalog.
* I only used NukeUI because AsyncImage still doesn't have built-in caching, and it's just not stable enough to be used every day.
