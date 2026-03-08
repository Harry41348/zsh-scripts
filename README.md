# bash-scripts

A collection of personal bash scripts, free to use.

---

## Using These Scripts Anywhere

To run these scripts from any directory in your terminal, add their folder to your `PATH` environment variable:

1. **Make scripts executable** (if not already):

   ```bash
   chmod +x /Users/harryw/Documents/web-development/bash-scripts/*.sh
   ```

2. **Add the scripts directory to your PATH**:
   Add this line to your `~/.zshrc` (or `~/.bash_profile` if you use bash):

   ```bash
   export PATH="/Users/harryw/Documents/web-development/bash-scripts:$PATH"
   ```

   Then reload your shell config:

   ```bash
   source ~/.zshrc
   # or
   source ~/.bash_profile
   ```

3. **Now you can run any script from anywhere**:
   ```bash
   pull-main.sh
   system-info.sh
   # etc.
   ```

_Tip: You can also move scripts to `~/bin` or another directory in your PATH if you prefer._

## Scripts

### `system-info.sh`

Displays a quick overview of the current machine: OS details, CPU model and
core count, total/available memory, disk usage per mount point, uptime, and
currently logged-in users.

```bash
chmod +x system-info.sh
./system-info.sh
```

---

### `backup.sh`

Creates a compressed, timestamped `.tar.gz` archive of a source directory.

```bash
chmod +x backup.sh
./backup.sh <source_dir> [destination_dir]
```

_Example:_ `./backup.sh ~/Documents ~/backups`

---

### `find-large-files.sh`

Finds the largest files under a given directory, sorted by size (largest
first).

```bash
chmod +x find-large-files.sh
./find-large-files.sh [directory] [top_n] [min_size]
```

| Argument    | Default | Description                           |
| ----------- | ------- | ------------------------------------- |
| `directory` | `.`     | Root path to search                   |
| `top_n`     | `20`    | Number of results to display          |
| `min_size`  | `1M`    | Minimum file size (e.g. `500k`, `1G`) |

_Example:_ `./find-large-files.sh /var/log 10 500k`

---

### `organize-files.sh`

Moves files in a directory into sub-directories named after their file
extension. Files without an extension go into `other/`. Existing directories
inside the target are left untouched.

```bash
chmod +x organize-files.sh
./organize-files.sh [target_dir] [--dry-run]
```

Pass `--dry-run` to preview what would be moved without changing anything.

_Example:_ `./organize-files.sh ~/Downloads --dry-run`

---

### `network-info.sh`

Prints a summary of network information: interfaces and IP addresses, default
gateway, DNS servers, public IP, and a basic connectivity check against
well-known hosts.

```bash
chmod +x network-info.sh
./network-info.sh
```

---

## Requirements

All scripts require **Bash ≥ 4** and standard GNU/Linux utilities (`find`,
`tar`, `curl`, etc.). Most scripts also run on macOS with minor limitations
noted in the output.
