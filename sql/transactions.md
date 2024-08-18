# Transactions

## Contents

- Need for concurrency
- Problems that arise with concurrency
- Introduction to transactions
- Commit / Rollback
- ACID
- Is ACID boolean?
- Durability levels
- Isolation levels

## Need for concurrency

In database operations, running all queries sequentially can lead to slow performance and increased wait times, similar to having only one queue at an immigration counter. To improve performance, databases can execute multiple queries concurrently, leveraging multi-core CPUs to increase throughput and reduce wait times.

## Problems that arise with concurrency

Concurrency can lead to issues such as data integrity problems and unexpected behavior. Consider a banking scenario where two money transfer transactions occur simultaneously. Without proper concurrency management, both transactions may read the same initial balance and proceed with updates that result in inconsistent data. For example, if Person A has 1000 INR, and two transactions (one transferring 700 INR to Person B and another transferring 800 INR to Person C) occur concurrently, the final balance for Person A might be incorrect, causing data integrity issues.

## Introduction to transactions

Transactions group a set of database operations into a single execution unit, ensuring that all operations succeed or fail together. If any operation within the transaction fails, the entire transaction is rolled back. Transactions help in maintaining consistency and integrity in the database.

```sql
BEGIN TRANSACTION

UPDATE film SET title = "TempTitle1" WHERE id = 10;
UPDATE film SET title = "TempTitle2" WHERE id = 100;

COMMIT
```

In the example above, two SQL statements are part of a single transaction. The changes are not finalized until the COMMIT command is executed. If any statement fails, the ROLLBACK command can undo all operations since the last commit.

## ACID

ACID properties define the expectations when transactions are used in a database:

- **Atomicity:** Ensures that all operations within a transaction are completed; if not, the transaction is rolled back.
- **Consistency:** Ensures that a transaction takes the database from one consistent state to another, maintaining data integrity.
- **Isolation:** Ensures that the execution of a transaction is isolated from other transactions, preventing them from interfering with each other.
- **Durability:** Ensures that once a transaction is committed, the changes are permanent and will survive system failures.

### Is ACID Boolean?

While atomicity is boolean, meaning it is either fully achieved or not, the other ACID properties are not strictly boolean. There are levels to isolation and durability, which involve trade-offs between consistency and performance.

### Durability levels

The basic form of durability is writing updates to disk. To enhance durability, databases can use techniques like replication, where commits are forwarded to replicas. This approach introduces additional latency and costs but provides higher durability.

## Isolation Levels

Isolation levels in databases define the degree to which the operations in one transaction are isolated from those in other concurrent transactions. The isolation level affects the visibility of changes made by one transaction to other transactions that are running concurrently. Lower isolation levels increase concurrency but risk data anomalies, while higher isolation levels improve data integrity at the cost of performance.

When you take a lock on a table row for example, any other transaction which also might be trying to access the same row would wait for you to complete. Which means with a lot of locks, overall transactions become slower, as they may be spending a lot of time waiting for locks to be released.

Locks are of 2 kinds:

- Shared Locks: Which means multiple transactions could be reading the same entity at the same time. However, a transaction that intends to write, will have to wait for ongoing reads to finish, and then would have to block all other reads and writes when it is writing/updating the entity.
- Exclusive Locks: Exclusive lock when taken blocks all reads and writes from other transaction. They have to wait till this transaction is complete.
There are other kind of locks as well, but not relevant to this discussion for now.

A database can use a combination of the above to achieve isolation during multiple transactions happening at the same time.
Note that the locks are acquired on rows of the table instead of the entire table. More granular the lock, better it is for performance.

As we can see that locks interfere with performance, database lets you choose isolation levels. Lower the level, more the performance, but lower the isolation/consistency levels.

The isolation levels are the following:

### Read uncommitted

This is most relaxed isolation level. In READ UNCOMMITTED isolation level, there isn’t much isolation present between the transactions at all, ie ., No locks.
This is the lowest level of isolation, and does almost nothing. It means that transactions can read data being worked with by other transactions, even if the changes aren’t committed yet. This means the performance is going to be really fast.

- **Description:** The Read Uncommitted isolation level allows transactions to read data that has been modified by other transactions but not yet committed. This means that a transaction can see changes made by other transactions even if those changes have not been finalized.

- **Characteristics:**
- **Dirty Reads:** A transaction may read data that is later rolled back by another transaction. This can lead to inconsistencies if the uncommitted data is incorrect or inconsistent.
- **No Locking:** Since there’s no locking mechanism in place, transactions can access rows simultaneously without waiting for each other.
- **Use Case:** This level is suitable for scenarios where the consistency of data is not critical and performance is the top priority, such as logging or statistical computations where slight inaccuracies are acceptable.

Let's consider a case.

| Time | Transaction 1 | Transaction 2 |
| ---  | ------------- | ------------- |
| 1 | Update row #1, balance updated from 500 to 1000 | |
| 2 | | Select row #1, gets value as 1000 |
| 3 | Rollback (balance reverted to 500) | |

T1 reverts the balance to 500. However, T2 is still using the balance as 1000 because it read a value which was not committed yet. This is also called as `dirty read`.
`Read uncommitted` has the problem of dirty reads when concurrent transactions are happening.

**Example Scenario:**

- Transaction 1 updates a row but hasn't committed the changes.
- Transaction 2 reads the updated row and sees the uncommitted data.
- If Transaction 1 rolls back, Transaction 2 would have read data that never actually existed in the committed state, leading to a dirty read.

**Example real world usecase:** Imagine you wanted to maintain count of live users on hotstar live match. You want very high performance, and you don't really care about the exact count. If count is off by a little, you don't mind. So, you won't mind compromising consistency for performance. Hence, read uncommitted is the right isolation level for such a use case.

### Read committed

The next level of isolation is READ_COMMITTED, which adds a little locking into the equation to avoid dirty reads. In READ_COMMITTED, transactions can only read data once writes have been committed. Let’s use our two transactions, but change up the order a bit: T2 is going to read data after T1 has written to it, but then T1 gets rolled back (for some reason).

- **Description:** In the Read Committed isolation level, a transaction can only read data that has been committed by other transactions. Uncommitted data remains invisible to all other transactions until it is committed.
- **Characteristics:**
- **No Dirty Reads:** This isolation level ensures that transactions only read committed data, eliminating the risk of dirty reads.
- **Non-Repeatable Reads:** Although dirty reads are avoided, it's possible for data to change between two reads within the same transaction due to commits by other transactions. This can lead to non-repeatable reads.
- **Locking:** Write operations typically lock the rows they modify, preventing other transactions from reading or writing to those rows until the lock is released (i.e., the transaction commits or rolls back).
- **Use Case:** This level is common in systems where it is crucial to avoid reading uncommitted data but where the ability to read the most recent committed data is more important than consistency across multiple reads within a transaction.

| Time | Transaction 1 | Transaction 2 |
| ---  | ------------- | ------------- |
| 1 | Selects row #1 | |
| 2 | Updates row #1, acquires lock | |
| 3 | | Tries to select row #1, but blocked by T1’s lock |
| 4 | Rolls back transaction | |
| 5 | | Selects row #1 |

READ_COMMITTED helps avoid a dirty read here: if T2 was allowed to read row #1 at Time 3, that read would be invalid; T1 ended up getting rolled back, so the data that T2 read was actually wrong. Because of the lock acquired at Time 2 (thanks READ_COMMITTED!), everything works smoothly and T2 waits to execute its SELECT query.

**This is the default isolation levels in some DBMS like Postgres.**

However, this isolation level has a problem of **Non-repeatable reads.** Let's understand what that is.

Consider the following.

| Time | Transaction 1 | Transaction 2 |
| ---  | ------------- | ------------- |
| 1 | Selects emails with low psp | |
| 2 | | update some low psp users with a better psp, acquires lock |
| 3 | | commit, lock released |
| 4 | Select emails with low psp again | |

**Example Scenario:**

- Transaction 1 reads a row.
- Transaction 2 modifies and commits that row.
- Transaction 1 reads the same row again and sees the updated value.
- This leads to a non-repeatable read, where the same query within a transaction returns different results.

At timestamp 4, I might want to read the emails again because I might want to update the status of having scheduled reminder emails to them. However, I will get a different set of emails in the same transaction (timestamp 1 vs timestamp 4). This issues is called non-repeatable reads and can happen in the current isolation level.

### Repeatable reads

The third isolation level is repeatable reads. This is the default isolation levels in many DBMS including MySQL.

The primary difference in repeable reads is the following:

- Every transaction reads all the committed rows required for executing reads and writes before the start of the transaction and stores it locally in memory as a snapshot. That way, if you read the same information multiple times in the same transaction, you will get the same entries.
- Locking mechanism:
  - Writes acquire exclusive locks (same as read committed)
  - Reads with write intent (SELECT FOR UPDATE) acquire exclusive locks.

- **Description:** The Repeatable Read isolation level ensures that if a transaction reads a row, any subsequent reads of the same row within the same transaction will return the same data. This level locks rows for the duration of the transaction, preventing other transactions from modifying them until the current transaction completes.
- **Characteristics:**
- **Prevention of Non-Repeatable Reads:** The data read during the transaction remains consistent throughout, ensuring that repeated reads yield the same results.
- **Phantom Reads:** While this level prevents non-repeatable reads, it does not address the issue of phantom reads. Phantom reads occur when a transaction reads a set of rows that meet a condition, but another transaction inserts or deletes rows that would alter the result set if the original query were run again.
- **Snapshot Mechanism:** Some databases implement repeatable read using a snapshot of the data, which is consistent for the entire duration of the transaction.
- **Use Case:** Suitable for scenarios where it is critical to maintain a consistent view of data throughout a transaction, such as in banking transactions or financial systems.

Further reading: <https://ssudan16.medium.com/database-isolation-levels-explained-61429c4b1e31>

| Time | Transaction 1 | Transaction 2 |
| ---- | ------------- | ------------- |
| 1 | Selects row #1 **for update**, acquires lock on row #1 | |
| 2 |  | Tries to update row #1, but is blocked by T1’s lock |
| 3 | updates row #1, commits transaction | |
| 4 | | Updates row #1 |

**Example Scenario:**

- Transaction 1 reads a set of rows that meet a condition.
- Transaction 2 inserts a new row that would meet the same condition.
- If Transaction 1 runs the same query again, it does not see the new row, maintaining a repeatable read but still susceptible to phantom reads.

The first example we took of money transfer could work if select for update is properly used in transactions with this isolation level.
However, this still has the following issue:

- Normal reads do not take any lock. So, it is possible while I have a local copy in my snapshot, the real values in DB have changed. Reads are not strongly consistent.
- Phantom reads: A very corner case, but the table might change if there are new rows inserted while the transaction is ongoing. Since new rows were not part of the snapshot, it might cause inconsistency in new writes, reads or updates.

### Serializable Isolation level

This is the strictest isolation level in a DB. It's the same as repeatable reads with the following differences:

- All reads acquire a shared lock. So, they don't let updates happen till they are completed.
- No snapshots required anymore.
- Range locking - To avoid phantom reads, this isolation level also locks a few entries in the range close to what is being read.

- **Description:** The Serializable isolation level is the strictest form of isolation. It ensures complete isolation by treating transactions as if they were executed serially, one after the other, rather than concurrently.
- **Characteristics:**
- **Prevention of All Anomalies:** Serializable transactions prevent dirty reads, non-repeatable reads, and phantom reads. The database behaves as if transactions are executed in a serial order.
- **High Locking:** This level uses extensive locking (often on entire tables or ranges of data) or a combination of locking and ordering to ensure that no other transactions can access the data being modified until the transaction completes.
- **Performance Trade-offs:** The high level of locking or serialization can lead to significant performance overhead, as many transactions may be forced to wait for others to complete.
- **Use Case:** This level is ideal for systems where data integrity and consistency are paramount and the cost of performance is secondary, such as in critical financial applications, banking systems, or where the correct execution of complex transactions is essential.

**Example usecase:** This is the isolation levels that banks use because they want strong consistency with every single piece of their information.
However, systems that do not require as strict isolation levels (like Scaler or Facebook) would then use Read Committed OR Repeatable Reads.

**Example Scenario:**

- Transaction 1 reads a range of rows and plans to update them.
- Transaction 2 tries to insert a row that would fall within the same range.
- Transaction 2 must wait until Transaction 1 completes, ensuring no phantom reads or other anomalies occur.

### Summary

- **Read Uncommitted:** Fastest, with potential inconsistencies due to dirty reads.
- **Read Committed:** Eliminates dirty reads, but can lead to non-repeatable reads.
- **Repeatable Read:** Prevents non-repeatable reads, but still allows phantom reads.
- **Serializable:** Most consistent, preventing all anomalies but with significant performance costs.

Choosing the appropriate isolation level depends on the specific needs of the application, the acceptable level of data consistency, and the performance requirements.
