Create a new Git branch from the current working implementation:

`experiment/melos`

The current implementation using plain Dart/Flutter path dependencies is working correctly. **Do not redesign or simplify the existing architecture.**

The purpose of this branch is to learn what Melos adds to the existing monorepo architecture.

## Goals

Convert the existing repository to use Melos while preserving:

- Consumer App
- Food module
- Ride module
- Wallet module
- Core packages
- Design System
- Food development app
- Ride development app
- Wallet development app
- Module contracts
- Dependency injection
- Clean Architecture inside modules
- Development-host concept
- Integration build concept

The application behavior should remain unchanged.

## Important Principle

Do not treat Melos as an architectural layer.

The architecture should remain:

```text
Consumer App
    ↓
Feature Modules
    ↓
Contracts
    ↓
Core / Shared Infrastructure
```

Melos should only provide monorepo/package management and developer tooling.

---

# 1. Add Melos

Add the appropriate Melos configuration to the repository.

Use the current stable Melos approach that is compatible with the project's Dart/Flutter version.

The repository should be able to bootstrap/manage all local packages through Melos.

---

# 2. Define Workspace Packages

Configure Melos to recognize the relevant packages.

For example:

```text
apps/
├── consumer_app/
├── food_dev_app/
├── ride_dev_app/
└── wallet_dev_app/

modules/
├── food/
├── ride/
└── wallet/

core/
├── networking/
├── authentication/
├── analytics/
├── logging/
└── configuration/

design_system/
```

Do not assume every directory must become a package.

Only package directories containing their own `pubspec.yaml` should be managed as Dart/Flutter packages.

---

# 3. Preserve Local Dependencies

The current implementation uses path dependencies.

Keep the dependency relationships correct.

For example:

```text
consumer_app
 ├── food
 ├── ride
 ├── wallet
 └── core
```

and:

```text
food
 └── core
```

Melos should manage the workspace, but it should not introduce unnecessary architectural coupling.

---

# 4. Add Useful Melos Commands

Configure a small set of useful scripts.

For example:

```text
melos bootstrap
melos analyze
melos test
melos format
```

If appropriate, also add:

```text
melos build
```

However, don't create dozens of scripts just for demonstration.

The goal is to show why Melos is useful.

---

# 5. Demonstrate Package-Wide Commands

The following should work:

```bash
melos bootstrap
```

This should resolve/link the local packages.

Then:

```bash
melos analyze
```

should analyze the relevant packages.

And:

```bash
melos test
```

should run tests across the workspace.

Also demonstrate formatting:

```bash
melos format
```

if appropriate for the current Melos version/configuration.

---

# 6. Demonstrate Targeted Commands

One of the important benefits of monorepo tooling is being able to operate on subsets of packages.

For example, demonstrate running commands only against the Food-related packages.

Conceptually:

```text
Food module
Food Dev App
Food dependencies
```

should be targetable without unnecessarily running every unrelated package.

If Melos supports the appropriate filtering mechanism, configure a simple example.

---

# 7. Demonstrate Dependency Awareness

Show that Melos understands the workspace packages and their relationships.

The architecture should still look like:

```text
                 Consumer App
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
        Ride         Food       Wallet
          │           │           │
          └───────────┼───────────┘
                      ▼
                     Core
```

Melos should manage this workspace but should not change the dependency direction.

---

# 8. Compare With the Previous Branch

Add a short `MELOS.md` explaining what changed.

The document should explain:

### Before

```text
Plain Flutter/Dart packages
        +
Path dependencies
```

### After

```text
Flutter/Dart packages
        +
Path dependencies
        +
Melos workspace management
        +
Monorepo scripts
```

Explain that Melos does NOT provide:

- Modular architecture
- Clean Architecture
- Dependency Injection
- Feature boundaries
- Contracts
- App Shell
- BLoC architecture

Those were already present.

Melos provides tooling around the workspace.

---

# 9. Keep the Same Development Model

The following should still work:

### Food development

```text
food_dev_app
    ↓
Food
    ↓
Mock Payment
```

### Production

```text
consumer_app
    ↓
Food
    ↓
Wallet implementation
```

Do not remove the development-host architecture just because Melos is present.

---

# 10. Add CI Example

If the repository already has CI configuration, adapt it carefully.

Demonstrate how Melos can simplify CI commands.

For example:

```text
CI
 │
 ├── melos bootstrap
 │
 ├── melos analyze
 │
 ├── melos test
 │
 └── consumer_app integration build
```

Do not attempt sophisticated affected-package detection unless it is straightforward.

The goal is to demonstrate the relationship between:

```text
Monorepo
   ↓
Melos
   ↓
Workspace commands
   ↓
CI
```

---

# 11. Do Not Over-Engineer

This branch is an experiment.

Do not introduce:

- unnecessary code generation
- complicated package publishing
- private package registries
- versioning automation
- advanced CI optimization
- unnecessary scripts
- unrelated architecture changes

The main question this branch should answer is:

> "What does Melos actually add to a Flutter monorepo that already works with plain path dependencies?"

---

# 12. Final Expected Structure

The final repository should conceptually look like:

```text
super_app/
│
├── apps/
│   ├── consumer_app/
│   ├── food_dev_app/
│   ├── ride_dev_app/
│   └── wallet_dev_app/
│
├── modules/
│   ├── food/
│   ├── ride/
│   └── wallet/
│
├── core/
│   ├── networking/
│   ├── authentication/
│   ├── analytics/
│   ├── logging/
│   └── configuration/
│
├── design_system/
│
├── melos.yaml
├── MELOS.md
└── ...
```

The application should behave exactly as it did before.

The primary difference should be:

```text
BEFORE

Dart/Flutter
+
Path dependencies


AFTER

Dart/Flutter
+
Path dependencies
+
Melos workspace
+
Monorepo scripts
+
Better package orchestration
```

After implementation, provide a short explanation of:

1. What Melos changed.
2. What Melos did NOT change.
3. Which commands are now easier.
4. Why a larger organization might benefit from Melos.
5. When plain path dependencies would still be sufficient.