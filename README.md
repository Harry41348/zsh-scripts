# bash-scripts
A collection of personal bash scripts, free to use.

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

*Example:* `./backup.sh ~/Documents ~/backups`

---

### `find-large-files.sh`
Finds the largest files under a given directory, sorted by size (largest
first).

```bash
chmod +x find-large-files.sh
./find-large-files.sh [directory] [top_n] [min_size]
```

| Argument    | Default | Description                         |
|-------------|---------|-------------------------------------|
| `directory` | `.`     | Root path to search                 |
| `top_n`     | `20`    | Number of results to display        |
| `min_size`  | `1M`    | Minimum file size (e.g. `500k`, `1G`) |

*Example:* `./find-large-files.sh /var/log 10 500k`

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

*Example:* `./organize-files.sh ~/Downloads --dry-run`

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
