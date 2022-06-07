<p align="center"><a href="https://github.com/Open-Bytes/SwiftUINavigator">
<img src="https://github.com/Open-Bytes/SwiftUINavigator/blob/master/blob/logo/logo_white.png?raw=true" alt="SwiftUINavigator Logo"/>
</a></p>

The logo is contributed with ❤️ by [Mahmoud Hussein](https://github.com/MhmoudAlim)
</br>
</br>

![swift v5.3](https://img.shields.io/badge/swift-v5.3-orange.svg)
![iOS 13](https://img.shields.io/badge/iOS-13.0+-865EFC.svg)
![macOS](https://img.shields.io/badge/macOS-10.15+-179AC8.svg)
![tvOS](https://img.shields.io/badge/tvOS-13.0+-41465B.svg)
![License](https://img.shields.io/badge/License-Apache-blue.svg)

**SwiftUINavigator** is a lightweight, flexible, and super easy library which makes `SwiftUI` navigation a trivial task.


<p align="center"><a href="https://github.com/Open-Bytes/SwiftUINavigator">
<img src="https://github.com/Open-Bytes/SwiftUINavigator/blob/master/blob/demo.gif?raw=true" alt="SwiftUINavigator Demo" width="450" height="450" border="#1111"/>
</a></p>

<p align="center"><a href="https://github.com/Open-Bytes/SwiftUINavigator">
<img src="https://github.com/Open-Bytes/SwiftUINavigator/blob/develop/blob/diagram3.png?raw=true" alt="SwiftUINavigator Diagram" width="550" height="550" border="#1111"/>
</a></p>

# Table of contents

- [Why?](#why)
    - [SwiftUI Limitations](#swiftui-limitations)
    - [ SwiftUINavigator is awesome](#swiftuinavigator-is-awesome)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Xcode Projects](#xcode-projects)
  - [Swift Package Manager Projects](#swift-package-manager-projects)
- [Usage](#zap-usage)
    - [Main Components](#main-components)
    - [NavigatorView](#navigatorview)
    - [Navigator](#navigator)
    - [NavigatorLink](#navigatorlink)
    - [Dismissing (Navigation Back)](#dismissing-navigation-back)
    - [DismissDestination](#dismissdestination)
    - [Navigation Bar](#navigation-bar)
    - [Transitions](#transitions)
    - [Navigation Types](#navigation-types)
    - [Navigation Transition Types](#navigation-transition)
- [Demo Project](#demo-project)
- [Contribution](#clap-contribution)
- [Changelog](#changelog)
- [License](#license)

## Why?

Let's first explore the limitations of SwiftUI then explore the awesome features **SwiftUINavigator** provides.

### SwiftUI Limitations

In SwiftUI, there are a lot of limitations:

- [ ] Can not navigate programmatically. You always have to declare the navigation links.

- [ ] Inconsistent navigation when use `NavigationLink`, `.sheet` and `.fullScreenCover`

- [ ] Can not ignore adding the view to the back stack.

- [ ] Transition navigations can not be disabled or customized.

- [ ] No navigation back to the root view.

- [ ] Can not navigate to a view using a specific ID.

- [ ] Customizing the navigation bar is not trivial.

### SwiftUINavigator is awesome

`SwiftUINavigator` has a lot of awesome features. Here's some of these features:

- [X] Custom navigation transitions

- [X] Navigate to a view without adding it to the back stack.

- [X] Direct navigation without links

- [X] Direct navigation with links

- [X] Present sheets without having to declare a sheet modifier.

- [X] Dismiss to the previous view.

- [X] Dismiss to the root view.

- [X] Dismiss to a specific view using its ID.

- [X] Navigation Bars are built-in the library

### Requirements

- Swift 5.3+

## Installation

### Xcode Projects

Select `File` -> `Swift Packages` -> `Add Package Dependency` and enter `https://github.com/Open-Bytes/SwiftUINavigator`.


### Swift Package Manager Projects

You can add `
SwiftUINavigator` as a package dependency in your `Package.swift` file:

```swift
let package = Package(
    //...
    dependencies: [
      .package(url: "https://github.com/Open-Bytes/SwiftUINavigator", .upToNextMajor(from: "0.2.0"))
    ]
    //...
)
```

From there, refer to `SwiftUINavigator` in target dependencies:

```swift
targets: [
    .target(
        name: "YourLibrary",
        dependencies: [
          "SwiftUINavigator"
        ]
        //...
    ),
   // ...
]
```

Then simply `import SwiftUINavigator` wherever you’d like to use the library.

## :zap: Usage

1. Import `SwiftUINavigator`.

```swift
import SwiftUINavigator
```

2. Declare `NavigatorView` in the root view of the app.

```swift
NavigatorView {
    HomeScreen()
}
```

> `NavigatorView` supports transition animations and other options.
> See [NavigatorView](#navigatorview)

3. Navigate to your destination view:

- Using `NavigatorLink`.

```swift
NavigatorLink(destination: SomeView()) {
    // When this view is clicked, it will trigger 
    // the navigation and show the destination view
    ProductItemView()
}
```

> For more details about`Navigator`, see [NavigatorLink](#navigatorlink)

- Or using `Navigator`

```swift
@EnvironmentObject private var navigator: Navigator

navigator.navigate {
    SomeView()
}
```

> For more details about`Navigator`, see [Navigator](#navigator)

4. Dismiss (navigate back) to the previous view
   **_programmatically_** (using `Navigator`) or using a **_link_** (using `DismissLink`).

- Using `Navigator`

```swift
navigator.dismiss()
```

- Or using `DismissLink`.

```swift
DismissLink {
    Label("Back", systemImage: "chevron.backward")
            .foregroundColor(.blue)
}
```

> For more details about dismissing,
> see [Dismissing (Navigation Back)](#dismissing-navigation-back)

### Main Components

|               **Component**               |                                                                        **Description**                                                                                                                             | 
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
|       [NavigatorView](#navigatorview)     |   `NavigatorView` is the alternative of SwiftUI NavigationView implementing <br> stack-based navigation with more control and flexibility <br> in handling the navigation                                          | 
|       [Navigator](#navigator)             |   The `Navigator` class is the heart of the library as it includes all the navigation APIs. It's injected to any view as `EnvironmentObject`.                                                                                                             | 
|       [NavigatorLink](#navigatorlink)     |   The alternative of `NavigationLink`. It's a wrapper of Navigator. <br> When clicked, it will navigate to the destination view with the specified navigation type.                                                  | 
|       [DismissLink](https://github.com/Open-Bytes/SwiftUINavigator/blob/master/SwiftUINavigator/Sources/SwiftUINavigator/DismissLink.swift)  |   DismissLink is a view which dismisses the current view when tapped. It's a wapper for `Navigator.dismiss()`   | 

### NavigatorView

`NavigatorView` is the alternative of SwiftUI NavigationView implementing stack-based navigation with more control and
flexibility in handling the navigation

#### The public initializers

```swift
public init(
        transition: NavigatorTransition = .default,
        easeAnimation: Animation = .easeOut(duration: 0.2),
        showDefaultNavBar: Bool = true,
        @ViewBuilder rootView: () -> Root)
```

As you can see, you can customize the `transition` animation, `easeAnimation` and automatic navigation bar.

```swift
NavigatorView(
        transition: .custom(push: .scale, pop: .slide),
        easeAnimation: .easeInOut) {
    HomeScreen()
}
```

> For more details about `NavigatorTransition`,
> see [Navigation Transition Types](#navigation-transition)

### Navigator

The `Navigator` class is the heart of the library as it includes all the navigation APIs. It's injected to any view as `EnvironmentObject`.

```swift
@EnvironmentObject private var navigator: Navigator
```

You can use `Navigator` directly to navigate programmatically to any view with 4 options

1. Push view (Regular Navigation)

```swift
navigator.navigate {
    ProductDetailScreen(item: item)
}
// OR
navigator.navigate(type: .push()) {
    ProductDetailScreen(item: item)
}
```

> You can specify an ID for the pushed view `navigate(SomeView(), type: .push(id: "Detail Screen"))`.
> Later, you can use this ID to navigate back to the view it's belonging to.
> See [Dismissing (Navigation Back)](#dismissing-navigation-back)

> You can ignore adding the view to tha back stack
> `navigate(SomeView(), type: .push(addToBackStack: false))`.
> When you navigate back this view won't be displayed.
> See [Dismissing (Navigation Back)](#dismissing-navigation-back)

2. Present sheet

```swift
navigator.navigate(type: .sheet()) {
    ProductDetailScreen(item: item)
}
```

3. Present full sheet

```swift
navigator.navigate(type: .fullSheet) {
    ProductDetailScreen(item: item)
}
```

4. Present a custom sheet

```swift
navigator.navigate(type: .customSheet(height: 500), showDefaultNavBar: true) {
    CartScreen()
}
```

> In **macOS**, you have to provide the width & height of the sheet in order to display correctly.
> Otherwise, you'll see a blank screen.


> The navigation types are declared in NavigationType enum.
> See [Navigation Types](#navigation-types)

### NavigatorLink

The alternative of `NavigationLink`. It's a wrapper of `Navigator`. When clicked, it will navigate to the destination view
with the specified navigation type.

```swift
NavigatorLink(destination: ProductDetailScreen(item: item)) {
    // When this view is clicked, it will trigger 
    // the navigation and show the destination view
    ProductItemView(item: item)
}
```

### Dismissing (Navigation Back)

You can dismiss the current view:

- Using `NavigatorLink`.

```swift
DismissLink {
    Label("Back", systemImage: "chevron.backward")
            .foregroundColor(.blue)
}
```

- Or using `Navigator`

```swift
navigator.dismiss()
```

> Important Note: You have 4 options in dismissing the current view.
> for more details, see [DismissDestination](#dismissdestination)

### DismissDestination

`DismissDestination` Defines the type of dismiss operation.

```swift
public enum DismissDestination {
    /// Navigate back to the previous view.
    case previous

    /// Navigate back to the root view (i.e. the first view added
    /// to the NavigatorView during the initialization process).
    case root

    /// Navigate back to a view identified by a specific ID.
    case view(withId: String)

    // Dismiss current presented sheet
    case dismissSheet
}
```

You can pass your option to `DismissLink` or `Navigator.dismiss()`

```swift
DismissLink(to: .root) {
    Label("Back", systemImage: "chevron.backward")
            .foregroundColor(.blue)
}

navigator.dismiss(to: .root)
```

### Navigation Bar

The navigation bar is built-in in the library. And you have the full control of hiding or showing it.

The NavBar is automatically displayed for some navigation types. In the following table, you can find the default state
for automatically showing the navigation bar

|   **Navigation Type**      |      **Automatic NavBar**      | 
| -------------------------- | -------------------------------| 
|   push                     |                 true           | 
|   fullSheet                |                 true           | 
|   sheet                    |                 false          | 
|   customSheet              |                 false          | 

> **Note**: You still can control displaying the NavBar of the navigation types.
>

#### Control Nav Bar For All Views

```swift
NavigatorView(showDefaultNavBar: false)
```

#### Control Nav Bar For a Single View

```swift
navigator.navigate(showDefaultNavBar: false) {
    SomeView()
}

navigator.push(showDefaultNavBar: false) {
    SomeView()
}

navigator.presentSheet(showDefaultNavBar: false) {
    SomeView()
}

navigator.presentFullSheet(showDefaultNavBar: false) {
    SomeView()
}

navigator.presentCustomSheet(showDefaultNavBar: false) {
    SomeView()
}
```

> Note: The option you select for a single view overrides the selected option in `NavigatorView`

In case you need a custom nav bar, you can disable the automatic one and implement your own one or use the built-in with
your customizations

```swift
SomeView()
        .navBar(
                style: .normal,
                leadingView: {
                    SomeView()
                }
        )
```

> Note: `style` parameter of type `NavBarStyle` supports `normal` and `large` navigation bars.

### Transitions

You can customize the transition animation by providing `NavigatorTransition` enum.

```swift
NavigatorView(transition: .custom(push: .scale)) {
    SomeView()
}
```

> For more details about `NavigatorTransition`,
> see [Navigation Transition Types](#navigation-transition)

### Navigation Types

This enum defines the supported navigation types

```swift
public enum NavigationType {
    /// Defines the regular navigation type.
    /// id: pass a custom ID to use when navigate back.
    /// addToBackStack: if false, the view won't be added to the back stack 
    /// and won't be displayed when dismissing the view.
    case push(id: String? = nil, addToBackStack: Bool = true)
    /// Present a sheet
    case sheet(width: CGFloat? = nil, height: CGFloat? = nil)
    /// Present a full sheet
    @available(iOS 14.0, *)
    case fullSheet
}
```

### Navigation Transition

`NavigatorTransition` enum defines the supported transitions.

```swift
public enum NavigatorTransition {
    /// Transitions won't be animated.
    case none

    /// The default transition if you didn't pass one.
    case `default`

    /// Use a custom transition.
    case custom(transition: AnyTransition)
}
```

## Demo Project

[DemoApp](https://github.com/Open-Bytes/SwiftUINavigator/blob/master/Demo/DemoApp.swift)
is an e-commerce app demonstrates the complete usage of the library.

## :clap: Contribution

All Pull Requests (PRs) are welcome. Help us make this library better.

## Changelog
Look at [Changelog](https://github.com/Open-Bytes/SwiftUINavigator/blob/master/CHANGELOG.md) for release notes.


## Contributors

[Shaban Kamel](https://github.com/ShabanKamell)

... Waiting for our name to be here 💪

## License

**Apache License**, Version 2.0

<details>
    <summary>
        click to reveal License
    </summary>

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

</details>
