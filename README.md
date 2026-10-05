# SuperApp — Modular Flutter Super App Architecture

An educational monorepo that shows how a large Flutter application can be split across
independently owned feature modules that communicate through contracts instead of importing
each other's code.

> This is a learning project inspired by large super apps. It does **not** represent the real
> internal architecture of any company.

## Repository layout

```text
super_app/
├── apps/
│   ├── consumer_app/      # production shell: composes Ride + Food + Wallet
│   ├── food_dev_app/      # development host for the Food team (mock payment)
│   ├── ride_dev_app/      # development host for the Ride team
│   └── wallet_dev_app/    # development host for the Wallet team
├── modules/
│   ├── food/              # feature module (Clean Architecture + BLoC)
│   ├── ride/              # feature module (Clean Architecture + BLoC)
│   └── wallet/            # feature module (Clean Architecture + BLoC + PaymentLauncher impl)
├── core/                  # shared infrastructure: networking, auth, analytics, logging, config
├── contracts/             # cross-module contracts (PaymentLauncher, ModuleLauncher, DTOs)
├── design_system/         # shared UI kit (colors, typography, buttons, cards, loading, theme)
└── tooling/               # local CI scripts
```

Every package is a standalone Dart/Flutter package that uses relative path dependencies.

## Dependency direction

```text
                    consumer_app
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
        Ride            Food           Wallet
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                  core + contracts + design_system
```

Rules enforced by the layout:

1. A business module may depend on `core`, `contracts` and `design_system`.
2. A business module must **never** depend on another business module.
3. `core`, `contracts` and `design_system` never depend on business modules.
4. Only the application shell (`consumer_app`) wires implementations together.

`Food` needs to take a payment, but it does not import `Wallet`. It depends on the
`PaymentLauncher` interface from `contracts`. The host decides which implementation is injected:

```text
Food ──► PaymentLauncher ◄── WalletPaymentLauncher ── Wallet
              ▲
              │
     FoodDevApp uses MockPaymentLauncher instead
```

## Clean Architecture inside a module

Each module is organized the same way:

```text
modules/food/lib/
├── contracts/      # public entry point (FoodModule implements ModuleLauncher)
├── domain/         # entities, repository interfaces, use cases (pure Dart + Equatable)
├── data/           # models, data sources (ApiClient), repository implementations
├── presentation/   # pages, widgets, BLoC/Cubit, nested Navigator (*Flow)
└── food.dart       # barrel: the only public API of the module
```

The barrel exports only what other packages need: `FoodModule` and `foodMockRoutes()`.
Everything else is an implementation detail of the module.

## Contracts

`contracts/` is the neutral home for cross-module interfaces:

- `PaymentLauncher` / `PaymentResult` — a module can request a payment without knowing Wallet.
- `ModuleLauncher` — how the shell launches a feature's root UI (`buildRoot`).

## Dependency injection

There is no DI framework. Each host builds a small composition root and passes dependencies down
through constructors. For example, `consumer_app` does:

```dart
final wallet = WalletModule(apiClient: apiClient, ...);
final food = FoodModule(
  apiClient: apiClient,
  paymentLauncher: wallet.paymentLauncher, // Wallet implementation behind the contract
  ...
);
final ride = RideModule(apiClient: apiClient, ...);
```

`FoodModule` receives its `PaymentLauncher`; it never constructs a wallet.

## The key demonstration

The **same** Food module runs in two environments, with different dependencies:

| Target | Payment | Modules loaded |
| --- | --- | --- |
| `food_dev_app` | `MockPaymentLauncher` | Food only |
| `consumer_app` | `WalletPaymentLauncher` | Ride + Food + Wallet |

Food's code does not change — only the injected implementation changes.

## Running

Each app is an independent Flutter project, so run it from its own directory:

```bash
# Development host for the Food team (no Wallet needed)
cd apps/food_dev_app
flutter pub get
flutter run            # or: flutter run -d chrome

# Development hosts for the other teams
cd apps/ride_dev_app   && flutter run
cd apps/wallet_dev_app && flutter run

# Production shell with every module assembled
cd apps/consumer_app
flutter pub get
flutter run            # or: flutter build web --release
```

## Testing

Every package has its own tests. Run them per package:

```bash
cd modules/food && flutter test
cd modules/wallet && flutter test
cd apps/consumer_app && flutter test
```

The `consumer_app` tests include an integration-style check that a payment made through the
`PaymentLauncher` contract is reflected in the Wallet UI, proving the host wiring works.

To run analyze + tests across the whole monorepo:

```bash
# Windows
./tooling/scripts/ci.ps1

# macOS / Linux
./tooling/scripts/ci.sh
```

You can scope it: `./tooling/scripts/ci.sh modules`, `shared`, or `apps`.

## CI

`.github/workflows/ci.yml` mirrors the build model:

1. **Detect changed packages** with path filters.
2. **Shared** packages (contracts, core, design_system): analyze + test.
3. **Module** jobs (Food / Ride / Wallet): analyze + test + build the module's development host.
4. **Integration** job: analyze + test + release web build of `consumer_app`.

Passing module tests does not guarantee the integrated app is correct, so the integration build
runs separately.

## Adding a new module

1. Create `modules/<name>` as a Flutter package depending on `core`, `contracts`, `design_system`.
2. Add `domain/`, `data/`, `presentation/`, `contracts/` inside `lib/`.
3. Expose `<Name>Module implements ModuleLauncher` and a `<name>MockRoutes()` fixture.
4. Add any cross-module interface it needs to `contracts/` (never import another module).
5. Add a `<name>_dev_app` host for fast, isolated development.
6. Register the module in `consumer_app`'s composition root.
