# Melos Experiment

This branch (`experiment/melos`) answers one question:

> What does Melos actually add to a Flutter monorepo that already works with plain path
> dependencies?

Melos is **not** an architectural layer. The application architecture is unchanged. Melos only
adds workspace management and a set of commands that operate across the workspace.

## Before / After

```text
BEFORE (main)

Flutter/Dart packages
        +
Path dependencies
        +
Hand-written scripts that loop over each package
```

```text
AFTER (experiment/melos)

Flutter/Dart packages
        +
Path dependencies
        +
Dart pub workspace (single resolution + single lockfile)
        +
Melos workspace management
        +
Monorepo scripts (analyze / test / format / build)
```

## What actually changed

| Change | Before | After |
| --- | --- | --- |
| Workspace definition | none, each package independent | root `pubspec.yaml` `workspace:` list |
| Package resolution | each package had its own `pubspec.lock` | one root `pubspec.lock`, `resolution: workspace` in every package |
| Running analyze/tests | per-package loops in `tooling/scripts` | `melos analyze`, `melos test` |
| Formatting | manual `dart format` per package | `melos format` / `melos format:check` |
| CI | per-package matrix | `melos bootstrap` + `melos analyze` + `melos test` + integration build |
| Targeted work | edit a shell script | `melos exec --scope=...` with dependency awareness |

Melos 8 stores its configuration in the root `pubspec.yaml` under the `melos:` key (the historical
`melos.yaml` file is no longer needed). The root package also pins `melos` as a dev dependency so
everyone and CI use the same version.

## What Melos did NOT change

Melos provides none of the following. They were already part of the design and are untouched:

- Modular architecture
- Clean Architecture inside each module
- Dependency Injection (constructor wiring in the composition roots)
- Feature boundaries (Food != Ride != Wallet)
- Contracts (`PaymentLauncher`, `ModuleLauncher`)
- App shell (`consumer_app`) and development hosts (`*_dev_app`)
- BLoC/Cubit presentation
- The dependency direction (Consumer App -> Modules -> Contracts/Core -> shared infrastructure)

```text
                 Consumer App
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
        Ride         Food       Wallet
          │           │           │
          └───────────┼───────────┘
                      ▼
             contracts + core + design_system
```

## Command cheat sheet

```bash
# Workspace-wide
melos list                    # show the packages Melos understands
melos bootstrap               # resolve + link every package (one lockfile)
melos analyze                 # flutter analyze in every package
melos test                    # flutter test in every package with a test/ directory
melos format                  # dart format across the workspace
melos run format:check        # verify formatting without changing files

# Builds
melos run build:consumer      # release web build of the production shell
melos run build:dev-hosts     # release web build of all three dev hosts

# Targeted (one of the main Melos benefits)
melos run food                # analyze + test the Food module, its dev host, and its dependencies
melos exec --scope=wallet -- flutter analyze
melos exec --scope=consumer_app -- flutter test
```

### Dependency awareness

`melos exec` understands the workspace graph:

```bash
melos exec --scope=food --include-dependencies -- flutter analyze
```

runs on `food`, and also pulls in its dependencies `contracts`, `design_system`, and `core` — while
leaving `ride` and `wallet` untouched. That is the filtering story in action: operate on a slice of
the monorepo without building everything.

## How CI got simpler

Before, CI had a path-filter job plus a per-package matrix. With Melos it collapses to:

```text
CI
 │
 ├── melos bootstrap
 ├── melos analyze
 ├── melos test
 └── integration build (consumer_app + development hosts)
```

The job definition in `.github/workflows/ci.yml` is now a handful of `melos` commands instead of a
matrix that had to know every package path. Adding a package means adding it to the root
`workspace:` list; CI picks it up automatically.

## Answers

1. **What did Melos change?**
   It turned the collection of path-dependent packages into a single Dart pub workspace and added
   cross-package commands (`bootstrap`, `analyze`, `test`, `format`, `exec`, custom scripts). It
   also normalized formatting across the repository as one operation.

2. **What did Melos NOT change?**
   The architecture: modules, contracts, DI, BLoC, app shell, development hosts, and dependency
   direction are exactly the same. The Food dev app still uses `MockPaymentLauncher`; the consumer
   app still injects `WalletPaymentLauncher` through the `PaymentLauncher` contract.

3. **Which commands are now easier?**
   `melos bootstrap` (one `pub get` for everything), `melos analyze`, `melos test`, `melos format`,
   and targeted runs via `melos exec --scope=... [--include-dependencies]`. Replacing the
   hand-written loop scripts is the clearest win.

4. **Why would a larger organization benefit?**
   More packages and more teams make "run this across everything" and "run this only for my
   feature" both necessary. Melos gives consistent tooling regardless of package count, versions
   the tool itself via the root pubspec, and keeps CI definitions small. It also enables optional
   versioning/publishing workflows later.

5. **When are plain path dependencies still sufficient?**
   For small repos (a handful of packages) where a single `flutter pub get` and CI matrix are
   already manageable. The architecture in this repository worked without Melos on `main`; Melos
   is a tooling convenience, not a requirement.

## Running the old scripts

`tooling/scripts/ci.ps1` and `tooling/scripts/ci.sh` still exist and still work. They are kept as a
reference for how the same checks were run before Melos. The Melos commands above are the
preferred path on this branch.
