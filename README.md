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
├── tooling/               # local scripts (now mostly superseded by Melos)
├── pubspec.yaml           # Melos workspace definition and scripts
└── MELOS.md               # what Melos adds to this monorepo
```

Every package is a standalone Dart/Flutter package that uses relative path dependencies. The
repository is wired together as a single Dart pub workspace and orchestrated with Melos; see
[`MELOS.md`](MELOS.md) for the before/after comparison.

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

Bootstrap the whole workspace once from the repository root, then run any app from its own
directory:

```bash
# Resolve and link every local package (one command for the whole monorepo)
melos bootstrap

# Development host for the Food team (no Wallet needed)
cd apps/food_dev_app
flutter run            # or: flutter run -d chrome

# Development hosts for the other teams
cd apps/ride_dev_app   && flutter run
cd apps/wallet_dev_app && flutter run

# Production shell with every module assembled
cd apps/consumer_app
flutter run            # or: flutter build web --release
```

## Testing

Every package has its own tests. Melos runs them across the whole workspace:

```bash
melos analyze   # flutter analyze in every package
melos test      # flutter test in every package that has a test directory
melos format    # dart format across the workspace
```

Target a subset without touching unrelated packages, letting Melos follow the dependency graph:

```bash
melos run food                                       # Food + Food dev host + their dependencies
melos exec --scope=wallet -- flutter analyze          # just the Wallet module
melos exec --scope=consumer_app -- flutter test       # just the production shell
```

The `consumer_app` tests include an integration-style check that a payment made through the
`PaymentLauncher` contract is reflected in the Wallet UI, proving the host wiring works.

## CI

`.github/workflows/ci.yml` uses Melos to keep CI short:

```text
CI
 ├── melos bootstrap       # resolve the whole workspace
 ├── melos analyze         # analyze every package
 ├── melos test            # test every package
 └── integration build     # release web build of consumer_app + dev hosts
```

Passing module tests does not guarantee the integrated app is correct, so the integration build
runs as a separate job.

## Adding a new module

1. Create `modules/<name>` as a Flutter package depending on `core`, `contracts`, `design_system`,
   add `resolution: workspace`, and list it under `workspace:` in the root `pubspec.yaml`.
2. Add `domain/`, `data/`, `presentation/`, `contracts/` inside `lib/`.
3. Expose `<Name>Module implements ModuleLauncher` and a `<name>MockRoutes()` fixture.
4. Add any cross-module interface it needs to `contracts/` (never import another module).
5. Add a `<name>_dev_app` host for fast, isolated development.
6. Register the module in `consumer_app`'s composition root.
