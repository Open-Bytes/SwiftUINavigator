<p align="center"><a href="https://github.com/Open-Bytes/SwiftUINavigator"><img src="https://github.com/Open-Bytes/SwiftUINavigator/blob/master/blob/logo/logo_white.png?raw=true" alt="SwiftUINavigator Logo" width="450" height="250" border="#1111"/></a></p>

The logo is contributed with ❤️ by [Mahmoud Hussein](https://github.com/MhmoudAlim) 
</br>
</br>

![platform iOS](https://img.shields.io/badge/platform-iOS-blue.svg)
![swift v5.3](https://img.shields.io/badge/swift-v5.3-orange.svg)
![deployment target iOS 13](https://img.shields.io/badge/deployment%20target-iOS%2013-blueviolet)

**SwiftUINavigator** is a lightweight, flexible, and super easy library which makes `SwiftUI` navigation a trivial task.

<img src="https://github.com/Open-Bytes/SwiftUINavigator/blob/master/blob/demo.gif?raw=true" alt="SwiftUINavigator Logo" width="400" height="400" border="#1111"/>

# Table of contents

- [Why?](#why)
    - [SwiftUI Limitations](#swiftui-limitations)
    - [ SwiftUINavigator is awesome](#swiftuinavigator-is-awesome)
- [Requirements](#requirements)
- [Installation](#installation)
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
    - [Navigation Transition Types](#navigation-transition-types)
- [License](#license)
- [Demo Project](#demo-project)
- [Contribution](#clap-contribution)
- [License](#license)

## Why?

Let's first explore the limitation of SwiftUI then explore the awesome features **SwiftUINavigator** provides.

### SwiftUI Limitations

In SwiftUI, there are a lot of limitations:

- [ ] Transition navigations can not be disabled or customized.
- [ ] Can not ignore adding the view to the back stack.
- [ ] No navigation back to root view.
- [ ] Can not navigate to a view using a specific ID.
- [ ] Inconsistent navigation when use `NavigationLinka`, `.sheet` and `.fullScreenCover`
- [ ] Can not navigate programmatically.
- [ ] Customizing the navigation bar is not trivial.

### SwiftUINavigator is awesome

`SwiftUINavigator` has a lot of awesome features. Here's some of these features:

- [X] Custom navigation transitions
- [X] Navigate to a view without adding it to the back stack.
- [X] Direct navigation without links
- [X] Direct navigation with links
- [X] Present sheets without having to declare a sheet modifier.
- [X] Dismiss to previous view.
- [X] Dismiss to root view.
- [X] Dismiss to a specific view using its ID.
- [X] Navigation Bars are built-in the library

### Requirements

- iOS 13+
- Swift 5.3+

## Installation

### 📦 Swift Package Manager

```
https://github.com/Open-Bytes/SwiftUINavigator.git
```

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

navigator.navigate(SomeView())
```

> For more details about`Navigator`, see [Navigator](#navigator)

4. Dismiss (navigate back) to the previous view
   **_programmatically_** (using `Navigator`) or using a **_link_** (using `DismissLink`).

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

> For more details about dismissing,
> see [Dismissing (Navigation Back)](#dismissing-navigation-back)

### Main Components

|               **Component**               |                                                                        **Description**                                                                                                                             | 
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
|       [NavigatorView](#navigatorview)     |   `NavigatorView` is the alternative of SwiftUI NavigationView implementing <br> stack-based navigation with mote control and flexibility <br> in handling the navigation                                          | 
|       [Navigator](#navigator)             |   The `Navigator` class is the heart of the library. It's injected to any view as `EnvironmentObject`.                                                                                                             | 
|       [NavigatorLink](#navigatorlink)     |   The alternative of NavigationLink. It's a wrapper of Navigator. <br> When clicked, it will navigate to the destination view with the specified navigation type.                                                  | 
|       [DismissLink](https://github.com/Open-Bytes/SwiftUINavigator/blob/master/SwiftUINavigator/Sources/SwiftUINavigator/DismissLink.swift)  |   DismissLink is a view which dismisses the current view when tapped. It's a wapper for `Navigator.dismiss()`   | 

### NavigatorView

`NavigatorView` is the alternative of SwiftUI NavigationView implementing stack-based navigation with mote control and
flexibility in handling the navigation

#### The public initializers

```swift
public init(
        transition: NavigatorTransitionType = .default,
        easeAnimation: Animation = .easeOut(duration: 0.2),
        @ViewBuilder rootView: () -> Root)

public init(
        navigator: Navigator,
        transition: NavigatorTransitionType = .default,
        easeAnimation: Animation = .easeOut(duration: 0.2),
        @ViewBuilder rootView: () -> Root)
```

As you can see, you can customize the `transition` animation and `easeAnimation`.

```swift
NavigatorView(
        transition: .custom(push: .scale, pop: .slide),
        easeAnimation: .easeInOut) {
    HomeScreen()
}
```

> **Important Note**: the second initializers supports a `Navigator` instance. This is important
> if you need to nest a `NavigatorView` other than the root one. 
> Keep in mind that if you didn't pass the `Navigator` instance, 
> it will work, but it's recommended to pass it for consistent behavior is the whole app.
> In this case, you should pass the instance of `Navigator` using the `EnvironmentObject` as follows:

```swift
@EnvironmentObject private var navigator: Navigator

NavigatorView(navigator: navigator) {
    SomeView()
}
```

> For more details about `NavigatorTransitionType`,
> see [Navigation Transition Types](#navigation-transition-types)

### Navigator

The `Navigator` class is the heart of the library. It's injected to any view as `EnvironmentObject`.

```swift
@EnvironmentObject private var navigator: Navigator
```

You can use `Navigator` directly to navigate programmatically to any view with 3 options

1. Push view (Regular Navigation)

```swift
navigator.navigate(ProductDetailScreen(item: item))
// OR
navigator.navigate(ProductDetailScreen(item: item), type: .push())
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
navigator.navigate(ProductDetailScreen(item: item), type: .sheet)
```

3. Present full sheet

```swift
navigator.navigate(ProductDetailScreen(item: item), type: .fullSheet)
```

> The navigation types are declared in NavigationType enum.
> See [Navigation Types](#navigation-types)

### NavigatorLink

The alternative of NavigationLink. It's a wrapper of Navigator. When clicked, it will navigate to the destination view
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

Sine we don't use SwiftUI's `NavgationView`, the default navigation bar won't be displayed. To show the navigation bar
you can use the library built-in bars or customize one.

```swift
SomeView()
        .navBar(
                style: .normal,
                leadingView: {
                    SomeView()
                }
        )
```

> `NavBarStyle` supports `normal` and `large navigation bars.

### Transitions

```swift
NavigatorView(transition: .custom(push: .scale, pop: .slide)) {
    SomeView()
}
```

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
    case sheet
    /// Present a full sheet
    @available(iOS 14.0, *)
    case fullSheet
}
```

### Navigation Transition Types

`NavigatorTransitionType` enum defines the supported transition types.

```swift
public enum NavigatorTransitionType {
    /// Transitions won't be animated.
    case none

    /// The default transition if you didn't pass one.
    case `default`

    /// Use a custom transition.
    case custom(push: AnyTransition, pop: AnyTransition)
}
```

## Demo Project

[DemoApp](https://github.com/Open-Bytes/SwiftUINavigator/blob/master/Demo/DemoApp.swift)
is an e-commerce app demonstrates the complete usage of the library.

## :clap: Contribution

All Pull Requests (PRs) are welcome. Help us make this library better.

## License

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