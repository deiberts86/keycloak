# Install PostgreSQL 12.x

#### Export variables

```sh
export PSG_USERNAME=postgres
export PSG_DB_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
export PSG_POSTGRE_PW=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
export PSG_REPLICATION_PW=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
```