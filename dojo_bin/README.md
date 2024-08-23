# Binary Dojo Example 
## Overview 
This project is a pure Cairo 1.0 equivalent of the Dojo Starter example. The project processes all transactions off-chain, ensures their correctness using cairo1-run with proof mode, which can be proved and verified using Saya, and then settled on-chain.

## Input and output
**Input (Array of felt252)**: Serialized array of tuples: caller (player) **address** and his **position** (which we treat as world state), and array of transactions (Spawn or Move).      
**Output (Array of felt252)**: Serialized **array** of **tuples**: caller (player) **address** and his **position**   

## Example Input

```plaintext
3 0 0 10 10 123 123 10 11 234 234 10 11 5 0 0  0 123 0 234 1 123 3 1 234 3
```

### Explanation

This input represents the initialization of 3 players and 5 subsequent transactions. Below is a breakdown of the input:

## Example Input

```plaintext
[3 0 0 10 10 123 123 10 11 234 234 10 11 5 0 0 0 123 0 234 1 123 3 1 234 3]
```

### Explanation

This input represents the initialization of 3 players and 5 subsequent transactions. Below is a breakdown of the input:

### Players

1. **First Player**
   - **Address**: `0`
   - **Position**: `(10, 10)`

2. **Second Player**
   - **Address**: `123`
   - **Position**: `(10, 11)`

3. **Third Player**
   - **Address**: `234`
   - **Position**: `(10, 11)`

### Transactions

1. **Spawn** the player with address `0`
2. **Spawn** the player with address `123`
3. **Spawn** the player with address `234`
4. **Move** the player with address `123` up
5. **Move** the player with address `234` up

### Transactions

1. **Spawn** the player with address `0`
2. **Spawn** the player with address `123`
3. **Spawn** the player with address `234`
4. **Move** the player with address `123` up
5. **Move** the player with address `234` up

## Output for example input:
```plaintext 
[3 0 0 20 20 123 123 20 21 234 234 20 21]
```
### Players

1. **First Player**
   - **Address**: `0`
   - **Position**: `(20, 20)`

2. **Second Player**
   - **Address**: `123`
   - **Position**: `(20, 21)`

3. **Third Player**
   - **Address**: `234`
   - **Position**: `(20, 21)`
#### Each coordinate was increased by 10 because, when spawning, the player's old position is taken, and 10 is added to it. This behavior mirrors the functionality in the Dojo Starter example.
