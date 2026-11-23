# ut2004 — AutoBot mutator

An Unreal Tournament 2004 mutator that tunes every bot in the match: skill,
aggression, strafing, accuracy, projectile leading, dodging and weapon choice.
For offline / local botmatches.

## Layout

```
AutoBot/Classes/AutoBotMutator.uc   UnrealScript source (package "AutoBot")
System/AutoBot.ini                  default settings, copied to <UT2004>/System
scripts/build.sh                    copy + register + compile from WSL / Linux
```

## Requirements

- An installed copy of UT2004 (patch 3369). The game is no longer sold; use your
  CD/DVD or an existing Steam/GOG install. See <https://www.oldunreal.com> for
  community patches and installers.
- `ucc` from the game's `System` folder (included with the game).

## Build and install

### From WSL or Linux (scripted)

```bash
scripts/build.sh /mnt/c/UT2004        # path to your UT2004 install
```

The script:
1. copies `AutoBot/` to `<UT2004>/AutoBot`,
2. installs `System/AutoBot.ini` if you don't have one yet,
3. adds `EditPackages=AutoBot` to `[Editor.EditorEngine]` in `UT2004.ini`
   (once; a backup is saved as `UT2004.ini.bak`),
4. deletes the old `AutoBot.u` and runs `ucc make`.

It picks the compiler automatically: Windows `ucc.exe` through WSL interop,
native `ucc-bin`, or `wine ucc.exe`.

### On Windows (manual)

1. Copy the `AutoBot` folder to `<UT2004>\AutoBot` (so you have
   `<UT2004>\AutoBot\Classes\AutoBotMutator.uc`).
2. In `<UT2004>\System\UT2004.ini`, under `[Editor.EditorEngine]`, add after
   the last `EditPackages=` line:
   ```
   EditPackages=AutoBot
   ```
3. Delete `<UT2004>\System\AutoBot.u` if it exists, then run
   `<UT2004>\System\ucc.exe make`.
4. Copy `System\AutoBot.ini` to `<UT2004>\System\`.

## Usage

Instant Action → Mutators → **AutoBot**, then start the match.

## Settings (`<UT2004>/System/AutoBot.ini`)

Section `[AutoBot.AutoBotMutator]`:

| Key             | Default | Range / meaning                                  |
|-----------------|---------|--------------------------------------------------|
| `BotSkill`      | 6.0     | 0..7                                             |
| `Aggression`    | 0.6     | CombatStyle: >0 charges, <0 keeps distance       |
| `StrafeAbility` | 0.8     | -1..1                                            |
| `AccuracyBonus` | 0.5     | -1..1                                            |
| `bHuntItems`    | True    | when hurt in a fight, retreat to health/armor    |
| `RetreatHealth` | 40      | health below which `bHuntItems` kicks in         |
| `TuneInterval`  | 1.0     | seconds between bot re-tunes                     |

UT2004 ini files don't support comments at the end of a line, so put only the
value after `=`. These values override the defaults compiled into the package. If the file is
missing, the defaults from `defaultproperties` are used.

## Installing UT2004 under WSL (optional)

The simplest setup is to play on Windows and only run `scripts/build.sh` from
WSL. If you want the game inside WSL, WSLg can show Wine windows:

```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install wine wine32:i386 winetricks
wine /path/to/UT2004/setup.exe
```
