# Friday Night Funkin' - A.H.P Engine (Advanced Hyper Psych Engine)

An upgraded and more powerful version of the Psych Engine, designed for creating advanced mods.

## New Features in the Psych Engine:

### LUA Extensions:
- `ScreenInfo`
- `WindowManager` (Note: It's a bit buggy but functional.)
- `LuaJsonHelper`
- `HttpClient`
- `GetArgs`
- `BrainF*ck`
- `UrlGen`

### BOTPLAY:
- **Reduced Lag** (Note: Not 100% effective for test mods.)
- `Botplay New Display`: Displays Botplay Score, Botplay Misses, and Botplay Rating.

### Gameplay:
- `forceDadMiss`: Forces Dad to miss every time. Use with:
  ```lua
  setProperty('forceDadMiss', <BOOL>)
  ```
### Future:
- Basic anti-cheat Beta

### Plan Future:
- Advanced anti-cheat
- Custom State With Lua