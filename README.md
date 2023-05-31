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


**SwiftUINavigator** is an on-the-fly approach for handling navigation in SwiftUI. It provides a familiar way of handling navigation similar to UIKit, where you can push or present a view controller without the need to declare links or local state variables. This approach is more flexible and allows for dynamic navigation, making it easier to build more complex navigation flows in your SwiftUI app. Unlike traditional navigation patterns in SwiftUI, SwiftUINavigator offers a more intuitive and straightforward way of managing your app's navigation hierarchy.

```swift
@EnvironmentObject private var navigator: Navigator

// Navigate to HomeScreen
navigator.navigate { HomeScreen() }

// Show sheet
navigator.navigate(type: .sheet(type: .normal)) {
  SheetView()
}
navigator.navigate(type: .sheet(type: .full)) { 
  SheetView()
}
navigator.navigate(type: .sheet(type: .fixedHeight(200))) {
  SheetView()
}

// Show dialog
navigator.navigate(type: .dialog) {
  DialogView()
}

// Show action sheet
navigator.presentActionSheet {
  ActionSheetView()
}

// Show confirmation dialog (Like action sheet starting from iOS 15)
navigator.presentConfirmationDialog(titleKey: "Color", titleVisibility: .visible) {
  ConfirmationDialogView()
}

// Show Alert
navigator.presentAlert {
  AlertView()
}
```

<p align="center"><a href="https://github.com/Open-Bytes/SwiftUINavigator">
<img src="https://github.com/Open-Bytes/SwiftUINavigator/blob/master/blob/diagram5.png?raw=true" alt="SwiftUINavigator Diagram" width="601" height="613" border="#1111"/>
</a></p>

<p align="center"><a href="https://github.com/Open-Bytes/SwiftUINavigator">
<img src="https://github.com/Open-Bytes/SwiftUINavigator/blob/master/blob/demo2.gif?raw=true" alt="SwiftUINavigator Demo" width="300" height="700" border="#1111"/>
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
    - [NavView](#NavView)
    - [Navigator](#navigator)
    - [NavLink](#navlink)
    - [Dismissing (Navigation Back)](#dismissing-navigation-back)
    - [DismissType](#dismisstype)
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

- [ ] Passing parameters to the view is not easy because you have to declare parameters locally and pass them to the view inside `NavigationLink`. 

- [ ] Can not navigate programmatically. You always have to declare the navigation links.

- [ ] Inconsistent navigation when use `NavigationLink`, `.sheet` and `.fullScreenCover`

- [ ] Can not ignore adding the view to the back stack.

- [ ] Transition navigations can not be disabled or customized.

- [ ] No navigation back to the root view.

- [ ] Can not navigate to a view using a specific ID.

- [ ] Customizing the navigation bar is not trivial.

### SwiftUINavigator is awesome

`SwiftUINavigator` has a lot of awesome features. Here's some of these features:

- [X] Consistent navigation with screens, sheets, action sheets, dialogs, confirmation dialogs, and alerts.

- [X] You are free to pass parameters on the fly and no need to declare the parameters outside the navigation site.
- 
- [X] Custom navigation transitions

- [X] Navigate to a view without adding it to the back stack.

- [X] Direct navigation with or without links

- [X] Present sheets without having to declare a sheet modifier.

- [X] Present dialogs easily.

- [X] Present alerts easily.

- [X] Present action sheets easily.

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
      .package(url: "https://github.com/Open-Bytes/SwiftUINavigator", .upToNextMajor(from: "1.0.0"))
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

2. Declare `NavView` in the root view of the app.

```swift
NavView {
    HomeScreen()
}
```

> `NavView` supports transition animations and other options.
> See [NavView](#NavView)

3. Navigate to your destination view:

```swift
// Declare navigator
@EnvironmentObject private var navigator: Navigator

// Navigate
navigator.navigate {
    SomeView()
}
```

> For more details about`Navigator`, see [Navigator](#navigator)


- Using `NavLink`.

```swift
NavLink(destination: SomeView()) {
    // When this view is clicked, it will trigger 
    // the navigation and show ProductItemView
    ProductItemView()
}
```

> For more details about`Navigator`, see [NavLink](#navlink)

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

## Action Sheet

```swift
navigator.presentActionSheet {
  ActionSheet(
          title: Text("Color"),
          buttons: [
            .default(Text("Red")),
            .default(Text("Green")),
            .default(Text("Blue")),
            .cancel()
          ]
  )
}
```

## Confirmation Dialog

```swift
navigator.presentConfirmationDialog(titleKey: "Color", titleVisibility: .visible) {
  Group {
    Button(action: {}) {
      Text("Red")
    }
    Button(action: {}) {
      Text("Green")
    }
    Button(action: {}) {
      Text("Blue")
    }
  }
}
```

## Alert

```swift
navigator.presentAlert {
    Alert(
        title: Text("Alert"),
        message: Text("Presented on the fly with SwiftUINavigator"),
        dismissButton: .cancel())
}
```

## Dialog

```swift
        navigator.presentDialog(dismissOnTouchOutside: true) {
            VStack(spacing: 10) {
                Text("Dialog").bold()
                Text("Presented on the fly with SwiftUINavigator")
                Spacer().frame(height: 20)
                Button(action: {
                    navigator.dismissDialog()
                }) {
                    Text("Cancel")
                }
            }
                    .padding(15)
                    .background(Color.white)
                    .cornerRadius(10)
        }
```

### Main Components

| **Component**                                                                                                                         | **Description**                                                                                                                                                                                  | 
|---------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
| [NavView](#NavView)                                                                                                                   | `NavView` is the alternative of SwiftUI NavigationView implementing <br> stack-based navigation with more control and flexibility <br> in handling the navigation                                | 
| [Navigator](#navigator)                                                                                                               | The `Navigator` class is the heart of the library as it includes all the navigation APIs. It's injected to any view as `EnvironmentObject`.                                                      | 
| [NavLink](#navlink)                                                                                                                   | The alternative of `NavigationLink`. It's a wrapper of Navigator. <br> When clicked, it will navigate to the destination view with the specified navigation type.                                | 
| [DismissLink](https://github.com/Open-Bytes/SwiftUINavigator/blob/master/SwiftUINavigator/Sources/SwiftUINavigator/DismissLink.swift) | DismissLink is a view which dismisses the current view when tapped. It's a wapper for `Navigator.dismiss()`                                                                                      | 

### NavView

`NavView` is the alternative of SwiftUI NavigationView implementing stack-based navigation with more control and
flexibility in handling the navigation

#### The public initializers

```swift
public init(
        transition: NavTransition = .default,
        easeAnimation: Animation = .easeOut(duration: 0.2),
        showDefaultNavBar: Bool = true,
        @ViewBuilder rootView: () -> Root)
```

As you can see, you can customize the `transition` animation, `easeAnimation` and automatic navigation bar.

```swift
NavView(
        transition: .custom(push: .scale, pop: .slide),
        easeAnimation: .easeInOut) {
    HomeScreen()
}
```

> For more details about `NavTransition`,
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
navigator.navigate(type: .sheet(type: .normal)) {
  SheetView()
}
// OR
navigator.navigate(type: .sheet(type: .full)) {
  SheetView()
}
// OR
navigator.navigate(type: .sheet(type: .fixedHeight(200))) {
  SheetView()
}
```

3. Present Dialog

```swift
navigator.navigate(type: .dialog) {
    ProductDetailScreen(item: item)
}
```

> The navigation types are declared in NavType enum.
> See [Navigation Types](#navigation-types)

### NavLink

The alternative of `NavigationLink`. It's a wrapper of `Navigator`. When clicked, it will navigate to the destination view
with the specified navigation type.

```swift
NavLink(destination: ProductDetailScreen(item: item)) {
    // When this view is clicked, it will trigger 
    // the navigation and show the destination view
    ProductItemView(item: item)
}
```

### Dismissing (Navigation Back)

You can dismiss the current view:

- Using `NavLink`.

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
> for more details, see [DismissType](#dismisstype)

### DismissType

`DismissType` Defines the type of dismiss operation.

```swift
public enum DismissType {
    /// Navigate back to the previous view.
    case toPreviousView
  
    /// Navigate back to the root view (i.e. the first view added
    /// to the NavView during the initialization process).
    case toRootView
  
    /// Navigate back to a view identified by a specific ID.
    case toView(withId: String)
  
    // Dismiss current presented sheet
    case sheet(type: DismissSheetType? = nil)
  
    // Dismiss current presented dialog
    case dialog
}
```

You can pass your option to `DismissLink` or `Navigator.dismiss()`

```swift
DismissLink(type: .toRootView) {
    Label("Back", systemImage: "chevron.backward")
            .foregroundColor(.blue)
}

navigator.dismiss(type: .toRootView)
```

### Navigation Bar

The navigation bar is built-in in the library. And you have the full control of hiding or showing it.

#### Control Nav Bar For All Views

```swift
NavView(showDefaultNavBar: false)
```

#### Control Nav Bar For a Single View

```swift
navigator.navigate(type: .push(showDefaultNavBar: false)) {
    SomeView()
}

navigator.push(showDefaultNavBar: false) {
    SomeView()
}
```

> Note: The option you select for a single view overrides the selected option in `NavView`

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

You can customize the transition animation by providing `NavTransition` enum.

```swift
NavView(transition: .custom(push: .scale, pop: .scale)) {
    SomeView()
}
```

> For more details about `NavTransition`,
> see [Navigation Transition Types](#navigation-transition)

### Navigation Types

This enum defines the supported navigation types

```swift
public enum NavType {
    /// Regular navigation type.
    /// id: pass a custom ID to use when navigate back.
    /// addToBackStack: if false, the view won't be added to the back stack
    /// and won't be displayed when dismissing the view.
    case push(id: String? = nil, addToBackStack: Bool = true, showDefaultNavBar: Bool? = nil)
    /// Present a sheet
    case sheet(type: SheetType)
    case dialog(dismissOnTouchOutside: Bool = true)
}
```

### Navigation Transition

`NavTransition` enum defines the supported transitions.

```swift
public enum NavTransition {
    /// Transitions won't be animated.
    case none

    /// The default transition if you didn't pass one.
    case `default`

    /// Use a custom transition for push & pop.
  case custom(push: AnyTransition, pop: AnyTransition)
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

... Waiting for your name to be here 💪

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
