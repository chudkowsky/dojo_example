mod models;
pub mod systems {
    pub mod actions;
}
use starknet::contract_address_const;
use starknet::ContractAddress;
use models::Direction;
use models::Position;
use models::Moves;
use systems::actions::actions::ActionsImpl;
use systems::actions::actions::WorldState;
use core::dict::Felt252Dict;

#[derive(Drop, Serde, Clone, Copy, Debug)]
enum TransactionType {
    Spawn: ContractAddress,
    Move: (ContractAddress, models::Direction)
}

fn main(input: Array<felt252>) -> Array<felt252> {
    let mut input = input.span();
    let (states, txns): (Array::<(ContractAddress, Position)>, Array::<TransactionType>) =
        Serde::deserialize(
        ref input
    )
        .unwrap();
    let mut world = WorldState { positions: Default::default(), moves: Default::default(), };
    for state in states {
        let (player, position) = state;
        let box_position = NullableTrait::new(position);
        world.positions.insert(player.into(), box_position);
        let box_moves = NullableTrait::new(
            Moves {
                player: player, remaining: 100, last_direction: Direction::None, can_move: true,
            }
        );
        world.moves.insert(player.into(), box_moves);
    };
    let mut players: Array<ContractAddress> = ArrayTrait::new();
    let mut output: Array<felt252> = ArrayTrait::new();
    for txn in txns {
        match txn {
            TransactionType::Spawn(player) => {
                ActionsImpl::spawn(ref world, player);
                let mut player_exists = false;
                for p in players.clone() {
                    if p == player {
                        player_exists = true;
                    }
                };

                if !player_exists {
                    players.append(player);
                }
            },
            TransactionType::Move((
                player, direction
            )) => {
                ActionsImpl::move(ref world, player, direction);
                let mut player_exists = false;
                for p in players.clone() {
                    if p == player {
                        player_exists = true;
                    }
                };
                if !player_exists {
                    players.append(player);
                }
            },
        }
    };
    let mut states: Array::<(ContractAddress, Position)> = ArrayTrait::new();
    for player in players {
        let position = world.positions.get(player.into()).deref();
        let mut state: (ContractAddress, Position) = (player, position.clone());
        states.append(state);
    };
    states.serialize(ref output);
    output
}
