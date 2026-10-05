# File changes — `experiment/melos` commit `1c8fd37`

Summary of the commit `experiment: adopt Melos 8 workspace and monorepo tooling`.

70 files changed in total:

- **19 substantive (non-Dart) changes** — the actual Melos conversion.
- **51 formatting-only Dart files** — produced by `melos format` (`dart format`), no logic changes.

## 1. Actually changed (19 non-Dart files)

### Added

- `pubspec.yaml` — root Melos workspace definition and scripts
- `pubspec.lock` — single workspace lockfile
- `MELOS.md` — before/after write-up

### Modified

- `.github/workflows/ci.yml` — Melos-based CI (`bootstrap`, `analyze`, `test`, integration builds)
- `README.md` — Melos commands and updated CI description
- `apps/consumer_app/pubspec.yaml`
- `apps/food_dev_app/pubspec.yaml`
- `apps/ride_dev_app/pubspec.yaml`
- `apps/wallet_dev_app/pubspec.yaml`
- `modules/food/pubspec.yaml`
- `modules/ride/pubspec.yaml`
- `modules/wallet/pubspec.yaml`
- `core/pubspec.yaml`
- `contracts/pubspec.yaml`
- `design_system/pubspec.yaml`

The ten `pubspec.yaml` files above each only gained `resolution: workspace`.

### Deleted

- `apps/consumer_app/pubspec.lock`
- `apps/food_dev_app/pubspec.lock`
- `apps/ride_dev_app/pubspec.lock`
- `apps/wallet_dev_app/pubspec.lock`
- `modules/food/pubspec.lock`
- `modules/ride/pubspec.lock`
- `modules/wallet/pubspec.lock`
- `core/pubspec.lock`
- `contracts/pubspec.lock`
- `design_system/pubspec.lock`

These were replaced by the single root `pubspec.lock`.

## 2. Formatting-only (51 Dart files)

Normalized by `melos format` (`dart format`). No logic or behavior changes.

### apps

- `apps/consumer_app/lib/app/composition_root.dart`
- `apps/consumer_app/lib/app/home_page.dart`
- `apps/consumer_app/test/app_test.dart`
- `apps/food_dev_app/test/food_dev_app_test.dart`
- `apps/ride_dev_app/test/ride_dev_app_test.dart`
- `apps/wallet_dev_app/test/wallet_dev_app_test.dart`

### contracts

- `contracts/lib/src/payment/payment_launcher.dart`
- `contracts/lib/src/payment/payment_result.dart`

### core

- `core/lib/src/analytics/analytics_service.dart`
- `core/lib/src/authentication/auth_service.dart`
- `core/lib/src/configuration/app_config.dart`

### design_system

- `design_system/lib/src/feedback/app_error_view.dart`
- `design_system/lib/src/loading/app_loading.dart`
- `design_system/test/design_system_test.dart`

### modules/food

- `modules/food/lib/contracts/food_module.dart`
- `modules/food/lib/data/datasources/food_fixtures.dart`
- `modules/food/lib/data/models/food_item_model.dart`
- `modules/food/lib/data/models/restaurant_model.dart`
- `modules/food/lib/data/repositories/food_repository_impl.dart`
- `modules/food/lib/domain/entities/cart.dart`
- `modules/food/lib/domain/entities/order.dart`
- `modules/food/lib/domain/entities/restaurant.dart`
- `modules/food/lib/domain/usecases/place_food_order.dart`
- `modules/food/lib/presentation/bloc/cart_cubit.dart`
- `modules/food/lib/presentation/bloc/restaurant_detail_cubit.dart`
- `modules/food/lib/presentation/bloc/restaurant_list_cubit.dart`
- `modules/food/lib/presentation/pages/cart_page.dart`
- `modules/food/lib/presentation/pages/checkout_page.dart`
- `modules/food/lib/presentation/pages/food_home_page.dart`
- `modules/food/lib/presentation/pages/restaurant_detail_page.dart`
- `modules/food/test/food_test.dart`

### modules/ride

- `modules/ride/lib/contracts/ride_module.dart`
- `modules/ride/lib/data/datasources/ride_fixtures.dart`
- `modules/ride/lib/data/models/ride_location_model.dart`
- `modules/ride/lib/data/repositories/ride_repository_impl.dart`
- `modules/ride/lib/domain/entities/ride.dart`
- `modules/ride/lib/presentation/bloc/destination_list_cubit.dart`
- `modules/ride/lib/presentation/bloc/ride_status_cubit.dart`
- `modules/ride/lib/presentation/pages/ride_home_page.dart`
- `modules/ride/lib/presentation/pages/ride_status_page.dart`
- `modules/ride/lib/presentation/widgets/destination_tile.dart`
- `modules/ride/test/ride_test.dart`

### modules/wallet

- `modules/wallet/lib/contracts/wallet_module.dart`
- `modules/wallet/lib/data/datasources/wallet_fixtures.dart`
- `modules/wallet/lib/data/models/wallet_account_model.dart`
- `modules/wallet/lib/data/models/wallet_transaction_model.dart`
- `modules/wallet/lib/data/repositories/wallet_repository_impl.dart`
- `modules/wallet/lib/domain/entities/wallet_account.dart`
- `modules/wallet/lib/presentation/bloc/wallet_cubit.dart`
- `modules/wallet/lib/presentation/pages/wallet_home_page.dart`
- `modules/wallet/lib/presentation/pages/wallet_payment_page.dart`

## How to verify

```bash
# Full file list for the commit
git show --stat 1c8fd37

# Non-Dart files only (the real changes)
git diff --name-status 346ec34 1c8fd37 | Select-String -NotMatch '\.dart$'

# Dart files only (formatting only)
git diff --name-only 346ec34 1c8fd37 -- '*.dart'
```
