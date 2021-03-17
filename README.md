# wp_local_backup
Simple script to backup a Wordpress site in a local folder

# Usage

- Download params.conf and wp_local_bak.sh
- Change params.conf
- `chmod +x wp_local_bak.sh`
- run script

Additionally you can add it to a crontab.

Example: `crontab -e`

Run the script every night at 1am
```
0 1 * * * /home/user/bin/wp_local_bak.sh
```

# Beta: remote backup (untested)

- Read first: SCP_keys.md
- Check if `ssh user@remotehost` can login without asking for password
- Uncomment remote backup section of the script
- Test.
