# dualcore_healthsystemfix

Advanced health and armor synchronization system for the **QB-Core** framework. This resource optimizes metadata saving and ensures player state persistence against abrupt disconnections or conflicts with other loading scripts.

## Key Features

* **Data Persistence:** Robust `health` and `armor` synchronization using QB-Core's native `SetMetaData`.
* **Entity Validation:** Strict entity existence check during the `playerDropped` event to prevent accidental saving of null or 0 values.
* **Mathematical Sanitization:** Implementation of `math.max` and `math.min` to ensure health remains within the 0-200 range and armor within 0-100.
* **Anti-Revive Logic:** During the first 10 seconds after loading, the script detects and corrects instances where other resources incorrectly force health to maximum.
* **Thread Optimization:** Utilizes a single synchronization thread every 60 seconds to minimize impact on client performance and network traffic.
* **Modularity & Debug:** Includes a detailed logging system and centralized utility functions.

## Installation

1. Download the repository.
2. Place the folder in your `resources` directory. **Important:** The folder must be named exactly `dualcore_healthsystemfix`.
3. Mandatory file structure:
   ```text
   dualcore_healthsystemfix/
   ├── client/
   │   ├── client.lua
   │   └── custom_client.lua
   ├── server/
   │   └── server.lua
   ├── shared/
   │   ├── config.lua
   │   └── utils.lua
   └── fxmanifest.lua
4. Add `start dualcore_healthsystemfix` to your `server.cfg`.
5. Done, enjoy! <3

## Configuración

Modify `shared/config.lua` to adjust the script's behavior:
- `Config.debug`: Enables/disables console messages.
- `Config.hasToWait`: Defines if the script waits for external loading times.
- `Config.useDualcoreHud`: Enables native integration with the DualCore HUD.

## License
This project is licensed under: GNU GENERAL PUBLIC LICENSE Version 3
