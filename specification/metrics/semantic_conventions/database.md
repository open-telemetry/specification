# Semantic Conventions for Database Metrics

This document contains semantic conventions for database client metrics in
OpenTelemetry. When instrumenting database clients, also consider the 
[general metric semantic conventions](README.md#general-metric-semantic-conventions).

## Common

The following labels SHOULD be applied to all database metric instruments.

| Attribute              | Description  | Example  | Required |
|------------------------|--------------|----------|----------|
| `db.system`            | An identifier for the database management system (DBMS) product being used. See below for a list of well-known identifiers. | `other_sql` | Yes |
| `db.connection_string` | The connection string used to connect to the database. It is recommended to remove embedded credentials. | `Server=(localdb)\v11.0;Integrated Security=true;` | No |
| `db.user`              | Username for accessing the database. | `readonly_user`<br>`reporting_user` | No |
| `net.transport`        | Transport protocol used. See note below. See [general network connection attributes](../../trace/semantic_conventions/span-general.md#general-network-connection-attributes). | `IP.TCP` | Conditional [1] |

**[1]:** Recommended in general, required for in-process databases (`"inproc"`).

## Call-level Metric Instruments

The following metric instruments SHOULD be iterated for every database operation.

| Name                 | Instrument    | Units        | Description |
|----------------------|---------------|--------------|-------------|
| `db.client.duration` | ValueRecorder | milliseconds | The duration of the database operation. |

Database operations SHOULD include execution of queries, including DDL, DML,
DCL, and TCL SQL statements (and the corresponding operations in non-SQL
databases), as well as connect operations.

### Labels

In addition to the [common](#common) labels, the following labels SHOULD be
applied to all database call-level metric instruments.

| Attribute        | Type   | Description  | Example  | Required |
|------------------|--------|--------------|----------|----------|
| `db.name`        | string | If no [tech-specific label](#call-level-labels-for-specific-technologies) is defined, this attribute is used to report the name of the database being accessed. For commands that switch the database, this should be set to the target database (even if the command fails). [1] | `customers`<br>`main` | Conditional [2] |
| `db.statement`   | string | The database statement being executed. [3][5] | `SELECT * FROM wuser_table`<br>`SET mykey "WuValue"` | Conditional.<br>Required if applicable. |
| `db.operation`   | string | The name of the operation being executed, e.g. the [MongoDB command name](https://docs.mongodb.com/manual/reference/command/#database-operations) such as `findAndModify`. [4][5] | `findAndModify`<br>`HMSET` | Conditional<br>Required, if `db.statement` is not applicable. |
| `exception.type` | string | The type of the exception (its fully-qualified class name, if applicable). The dynamic type of the exception should be preferred over the static type in languages that support it. | `java.sql.SQLException`<br/>`psycopg2.OperationalError` | Conditional.<br>Required if applicable. |

**[1]:** In some SQL databases, the database name to be used is called "schema name".

**[2]:** Required, if applicable and no more-specific attribute is defined.

**[3]:** The value may be sanitized to exclude sensitive information.

**[4]:** While it would semantically make sense to set this, e.g., to a SQL keyword like `SELECT` or `INSERT`, it is not recommended to attempt any client-side parsing of `db.statement` just to get this property (the back end can do that if required).

**[5]:** To reduce cardinality, the values for `db.statement` and `db.operation`
should have parameters removed or substituted. The resulting value should be a
low-cardinality value represeting the statement or operation being executed on
the database. It may be a stored procedure name (without arguments), SQL
statement without variable arguments, operation name, etc.

### Call-level labels for specific technologies

| Attribute                 | Description  | Example  | Required |
|---------------------------|--------------|----------|----------|
| `db.cassandra.keyspace`   | The name of the keyspace being accessed. To be used instead of the generic `db.name` attribute. | `mykeyspace` | Yes |
| `db.hbase.namespace`      | The [HBase namespace](https://hbase.apache.org/book.html#_namespace) being accessed. To be used instead of the generic `db.name` attribute. | `default` | Yes |
| `db.redis.database_index` | The index of the database being accessed as used in the [`SELECT` command](https://redis.io/commands/select), provided as an integer. To be used instead of the generic `db.name` label. | `0`<br>`1`<br>`15` | Conditional [1] |
| `db.mongodb.collection`   | The collection being accessed within the database stated in `db.name`. | `customers`<br>`products` | Yes |

**[1]:** Required, if other than the default database (`0`).

## Connection Pooling Metric Instruments

If possible, instrumentation SHOULD collect the following. They SHOULD have
all [common](#common) labels applied to them.

| Name                      | Instrument | Units         | Description |
|---------------------------|------------|---------------|-------------|
| `db.connections.new`      | Counter	 | {connections} | The number of new connections created. |
| `db.connections.taken`    | Counter	 | {connections} | The number of connections taken from the connection pool. |
| `db.connections.returned` | Counter	 | {connections} | The number of connections returned to the connection pool. |
| `db.connections.reused`   | Counter	 | {connections} | The number of connections reused. |
| `db.connections.closed`   | Counter    | {connections} | The number of connections closed. |

 
Otherwise, the following metric instruments SHOULD be collected. They SHOULD
have all [common](#common) labels applied to them.

| Name                      | Instrument    | Units        | Description |
|---------------------------|---------------|--------------|-------------|
| `db.connectionPool.limit` | ValueObserver | {connections} | The total number of database connections available in the connection pool. |
| `db.connectionPool.usage` | ValueObserver | {connections} | The number of database connections _in use_. |
