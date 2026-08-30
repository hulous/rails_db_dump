# rails_db_dump

A small Rails gem that provides `db:dump` and `db:restore` rake tasks for PostgreSQL database backups.

## Usage

In a Rails application that includes this gem, run:

```bash
bundle exec rake db:dump > db/backups/my_dump.dump
```

To restore from a file:

```bash
bundle exec rake db:restore < db/backups/my_dump.dump
```

To pass a specific file path through the task, set the `RAILS_DB_DUMP_FILE` environment variable:

```bash
RAILS_DB_DUMP_FILE=db/backups/my_dump.dump bundle exec rake db:dump
```

```bash
RAILS_DB_DUMP_FILE=db/backups/my_dump.dump bundle exec rake db:restore
```
