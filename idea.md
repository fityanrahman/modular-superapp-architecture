# Flutter Modular Super App Architecture — Implementation Brief

## Goal

Build a small Flutter application that demonstrates a **large-scale modular super-app architecture** similar in concept to what a company like Gojek might use.

This is an educational project. Do **not** assume or claim that this represents Gojek's actual internal architecture.

The application should demonstrate these concepts:

- Modular architecture
- Feature ownership by separate teams
- App Shell / Host application
- Feature modules
- Clean Architecture inside modules
- Strict module boundaries
- Contracts/interfaces between modules
- Dependency Injection
- Feature-to-feature communication without direct coupling
- Development host applications
- Production/integration application
- Mock implementations for isolated development
- CI-friendly structure
- Ability to build/test an individual module without assembling the entire application

The implementation should prioritize **architecture clarity and learning** over production-level complexity.

---

# 1. Example Product

Create a fictional super app called:

`SuperApp`

It has three major business modules:

```text
SuperApp
├── Ride
├── Food
└── Wallet
```

Think of them as independent business domains owned by different teams.

Example responsibilities:

```text
Ride Team
    - Ride booking
    - Driver information
    - Ride status

Food Team
    - Restaurant list
    - Restaurant detail
    - Cart
    - Food ordering

Wallet Team
    - Wallet balance
    - Payment
    - Transaction history
```

There should also be shared platform functionality:

```text
Core
├── Networking
├── Authentication
├── Analytics
├── Logging
└── Configuration
```

---

# 2. Repository Structure

Use a monorepo.

Suggested structure:

```text
super_app/
│
├── apps/
│   │
│   ├── consumer_app/
│   │
│   ├── food_dev_app/
│   │
│   ├── ride_dev_app/
│   │
│   └── wallet_dev_app/
│
├── modules/
│   │
│   ├── ride/
│   │
│   ├── food/
│   │
│   └── wallet/
│
├── core/
│   │
│   ├── networking/
│   ├── authentication/
│   ├── analytics/
│   ├── logging/
│   └── configuration/
│
├── design_system/
│
└── tooling/
```

Use Dart/Flutter packages for modules where appropriate.

The important concept is that each business module should behave like an independently owned package.

---

# 3. Dependency Direction

Enforce this dependency direction:

```text
                    consumer_app
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
        Ride            Food           Wallet
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                        Core
```

Rules:

1. `Ride` may depend on `Core`.
2. `Food` may depend on `Core`.
3. `Wallet` may depend on `Core`.
4. The application shell may depend on all modules.
5. `Core` must never depend on business modules.
6. `Food` should not directly depend on `Wallet`.
7. `Wallet` should not directly depend on `Food`.
8. Business modules should communicate through contracts/interfaces rather than directly importing each other's implementation.

Avoid circular dependencies.

Bad:

```text
Food → Wallet → Food
```

Also avoid:

```text
Food → WalletPage
Food → WalletBloc
Food → WalletRepository
```

---

# 4. Internal Architecture of Each Module

Each business module should itself use Clean Architecture.

Example:

```text
modules/
└── food/
    │
    ├── lib/
    │   │
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   │
    │   ├── data/
    │   │   ├── models/
    │   │   ├── datasources/
    │   │   └── repositories/
    │   │
    │   ├── presentation/
    │   │   ├── pages/
    │   │   ├── widgets/
    │   │   └── bloc/
    │   │
    │   └── contracts/
    │
    └── pubspec.yaml
```

The same general structure should be used for:

```text
ride/
wallet/
```

Use BLoC/Cubit for presentation state management.

Do not over-engineer the example with unnecessary abstractions.

---

# 5. Food Module Example

The Food module should demonstrate a realistic feature.

For example:

```text
Food
├── Restaurant List
├── Restaurant Detail
├── Cart
└── Checkout
```

Possible internal structure:

```text
food/
├── domain/
│   ├── entities/
│   │   ├── restaurant.dart
│   │   ├── food_item.dart
│   │   └── cart.dart
│   │
│   ├── repositories/
│   │   └── food_repository.dart
│   │
│   └── usecases/
│       ├── get_restaurants.dart
│       ├── get_menu.dart
│       └── place_food_order.dart
│
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
│
└── presentation/
    ├── pages/
    ├── widgets/
    └── bloc/
```

---

# 6. Module Contracts

This is one of the most important concepts in the project.

A business module should expose only the functionality that other modules or the host application actually need.

For example, Food may need to request payment.

Food should NOT directly depend on Wallet.

Instead, define a contract:

```dart
abstract interface class PaymentLauncher {
  Future<PaymentResult> pay({
    required double amount,
  });
}
```

Food depends only on:

```text
PaymentLauncher
```

It does not know:

```text
WalletPage
WalletBloc
WalletRepository
WalletDataSource
```

Conceptually:

```text
Food
 │
 ▼
PaymentLauncher
 │
 ▼
Implementation provided by host
 │
 ▼
Wallet
```

This is a critical architectural boundary.

---

# 7. Dependency Injection

The host application should wire implementations together.

For example:

```dart
final paymentLauncher = WalletPaymentLauncher();

final foodModule = FoodModule(
  paymentLauncher: paymentLauncher,
);
```

Food should receive its dependencies rather than constructing them internally.

Avoid:

```dart
class FoodCheckout {
  final wallet = WalletPaymentLauncher();
}
```

Prefer:

```dart
class FoodCheckout {
  final PaymentLauncher paymentLauncher;

  FoodCheckout({
    required this.paymentLauncher,
  });
}
```

This allows the Food module to work with both:

```text
Real implementation
```

and:

```text
Mock implementation
```

---

# 8. Feature-to-Feature Navigation

Do not allow a module to directly navigate to another module's implementation.

Avoid:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => WalletPaymentPage(),
  ),
);
```

inside the Food module.

Instead, define an appropriate contract.

For example:

```dart
abstract interface class AppNavigator {
  void openWallet();
}
```

Or expose a feature-level navigation contract such as:

```dart
abstract interface class WalletLauncher {
  Future<PaymentResult> openPayment({
    required double amount,
  });
}
```

The host application decides how the contract is implemented.

Conceptually:

```text
Food
 │
 ▼
WalletLauncher
 │
 ▼
Consumer App
 │
 ▼
Wallet
```

This keeps modules loosely coupled.

---

# 9. App Shell

The production application should act as the application shell.

```text
consumer_app/
│
├── App Shell
├── Routing
├── Dependency Injection
├── Authentication setup
├── Configuration
│
├── Ride Module
├── Food Module
└── Wallet Module
```

The shell is responsible for composing the modules.

It should not contain business logic belonging to Food, Ride, or Wallet.

Its main responsibility is composition.

Conceptually:

```text
                    Consumer App
                         │
             ┌───────────┼───────────┐
             │           │           │
           Ride         Food       Wallet
             │           │           │
             └───────────┼───────────┘
                         │
                        Core
```

---

# 10. Development Host Applications

This is another important requirement.

Each major module should have a lightweight development application.

For example:

```text
apps/
├── consumer_app/
├── food_dev_app/
├── ride_dev_app/
└── wallet_dev_app/
```

The Food development application should contain only the minimum things necessary to run Food.

Conceptually:

```text
Food Dev App
│
├── Minimal App Shell
├── Core
├── Food
└── Mock Dependencies
```

It should NOT need to include:

```text
Ride
Wallet
Other unrelated features
```

The purpose is fast development and feedback.

---

# 11. Food Development Example

When the Food team develops checkout:

```text
Food
 │
 ▼
PaymentLauncher
 │
 ▼
MockPaymentLauncher
```

The developer can run:

```text
food_dev_app
```

and test:

```text
Restaurant
   ↓
Menu
   ↓
Cart
   ↓
Checkout
   ↓
Mock Payment
   ↓
Success
```

without needing the complete Consumer App.

This demonstrates the idea:

> A feature team can develop and test its feature in an isolated host application.

---

# 12. Production Integration

The production application uses the real implementations.

Development:

```text
Food Dev App
│
├── Core
├── Food
└── Mock Wallet / Mock Payment
```

Production:

```text
Consumer App
│
├── Core
├── Ride
├── Food
├── Wallet
└── Real implementations
```

The Food module itself should remain the same.

Only its environment/dependencies change.

---

# 13. Build Model

Demonstrate two different build targets.

## Module Development Build

Optimized for developer speed:

```text
Food Developer
      │
      ▼
Food Dev App
      │
      ▼
Food Module
      │
      ▼
Fast feedback
```

The developer should not need to build the entire application for every Food change.

## Integration Build

Optimized for system confidence:

```text
Ride ──┐
Food ──┼──> Consumer App
Wallet ─┘
           │
           ▼
    Integration Tests
           │
           ▼
       Release Build
```

---

# 14. CI Concept

The project should include a conceptual CI workflow.

When a developer changes:

```text
modules/food/
```

CI should ideally be able to perform:

```text
Pull Request
     │
     ▼
Detect changed module
     │
     ▼
Food
     │
 ┌───┼────────┐
 ▼   ▼        ▼
Analyze
Tests
Food Dev Build
```

After module-level validation passes:

```text
        Food
         │
         ▼
Integration Build
         │
 ┌───────┼────────┐
 ▼       ▼        ▼
Ride    Food     Wallet
 └───────┼────────┘
         ▼
   Consumer App
         │
         ▼
 Integration Tests
         │
         ▼
   Release Build
```

For this educational project, CI does not need to be extremely sophisticated.

The important thing is to demonstrate the architectural concept.

---

# 15. Dependency Graph

The architecture should make dependencies explicit.

For example:

```text
consumer_app
│
├── ride
│   └── core
│
├── food
│   └── core
│
├── wallet
│   └── core
│
└── design_system
```

Food should NOT have:

```text
food
└── wallet
```

Instead:

```text
food
└── contracts
    └── PaymentLauncher
```

and:

```text
consumer_app
├── food
├── wallet
└── dependency wiring
```

The application shell connects the implementations.

---

# 16. Design System

Create a small shared design system:

```text
design_system/
├── colors/
├── typography/
├── buttons/
├── cards/
├── loading/
└── app_theme/
```

All business modules may depend on the design system.

For example:

```text
Food ─────┐
Ride ─────┼──> Design System
Wallet ───┘
```

The design system must not depend on business modules.

---

# 17. Core Package

Create a small Core package containing infrastructure shared across modules.

Example:

```text
core/
├── networking/
├── authentication/
├── analytics/
├── logging/
└── configuration/
```

For example:

```text
Food
 │
 ├── FoodRepository
 │
 └── ApiClient
        │
        ▼
     Networking
```

Do not put business-specific code into Core.

Bad:

```text
core/
└── food_service.dart
```

Good:

```text
core/
└── networking/
    └── api_client.dart
```

Core should contain generic infrastructure.

---

# 18. What the Demo Should Actually Implement

Do not build a huge application.

Build enough functionality to prove the architecture.

## Consumer App

Provide a simple home screen:

```text
SuperApp
─────────────────────

[ Ride ]

[ Food ]

[ Wallet ]
```

Selecting each feature opens the corresponding module.

---

## Food

Implement:

```text
Restaurant List
      ↓
Restaurant Detail
      ↓
Add to Cart
      ↓
Cart
      ↓
Checkout
      ↓
Payment
```

---

## Ride

Implement something simple:

```text
Ride Home
      ↓
Select Destination
      ↓
Request Ride
      ↓
Ride Status
```

---

## Wallet

Implement:

```text
Wallet Home
      ↓
Balance
      ↓
Payment
      ↓
Transaction Result
```

---

# 19. Important Demonstration

The most important demonstration should be:

### Food development

Run:

```text
food_dev_app
```

Food should work with:

```text
MockPaymentLauncher
```

without loading Wallet.

### Production

Run:

```text
consumer_app
```

Food should use:

```text
WalletPaymentLauncher
```

through the contract.

This proves:

```text
Same Food Module
       │
       ├── Development → Mock implementation
       │
       └── Production  → Real implementation
```

---

# 20. Architecture Principles

Follow these principles:

### Principle 1 — Business modules are isolated

```text
Food ≠ Wallet
Food ≠ Ride
Ride ≠ Wallet
```

### Principle 2 — Shared infrastructure belongs below modules

```text
Modules
   ↓
Core
```

### Principle 3 — The application shell composes modules

```text
Consumer App
   ↓
Modules
```

### Principle 4 — Dependencies should be injected

Avoid hidden global dependencies where possible.

### Principle 5 — Communication happens through contracts

Avoid direct dependency on another module's implementation.

### Principle 6 — Modules should be independently testable

A module should be usable in a lightweight development host.

### Principle 7 — Integration is tested separately

Passing module tests does not mean the complete application is correct.

Therefore:

```text
Module Tests
      +
Integration Tests
      +
Full Application Build
```

---

# 21. Architecture Summary

The final conceptual architecture should look like:

```text
                         MONOREPO
                            │
            ┌───────────────┼────────────────┐
            │               │                │
            ▼               ▼                ▼
      Consumer App      Food Dev App     Ride Dev App
            │
            ▼
       APP SHELL
            │
     ┌──────┼──────┐
     ▼      ▼      ▼
   Ride    Food   Wallet
     │      │      │
     └──────┼──────┘
            │
       CONTRACTS
            │
            ▼
           CORE
            │
     ┌──────┼────────┐
     ▼      ▼        ▼
 Networking Auth  Analytics

        +
        
   DESIGN SYSTEM
```

And internally:

```text
Feature Module
│
├── Presentation
│   ├── Pages
│   ├── Widgets
│   └── BLoC/Cubit
│
├── Domain
│   ├── Entities
│   ├── Repository Interfaces
│   └── Use Cases
│
├── Data
│   ├── Models
│   ├── Data Sources
│   └── Repository Implementations
│
└── Contracts
```

---

# 22. Do Not Over-Engineer

This is an educational architecture.

Do NOT introduce complexity merely to make the project look "enterprise."

Avoid unnecessary:

- Microservices
- Event buses
- Dynamic feature downloading
- Runtime code generation
- Distributed systems
- Complex dependency injection frameworks
- Excessive abstractions
- Multiple backend services

The goal is to clearly demonstrate:

```text
Module boundaries
        ↓
Contracts
        ↓
Dependency Injection
        ↓
Development Host
        ↓
Application Shell
        ↓
Integration Build
```

The resulting project should be small enough that a developer can understand the entire architecture by reading the repository.

---

# Final Objective

After implementation, a developer should be able to understand:

> "How could a very large Flutter application be divided among multiple teams so that each team can develop its feature independently, run a lightweight development application, communicate with other modules through contracts, and finally assemble everything into one production application?"

The project should answer that question through working code rather than documentation alone.