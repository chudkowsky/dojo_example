mod models;
pub mod systems {
    pub mod actions;
}
use starknet::contract_address_const;
use starknet::ContractAddress;
use models::Direction;
use systems::actions::actions::ActionsImpl;
use systems::actions::actions::WorldState;

#[derive(Drop)]
enum TransactionType {
    Spawn: ContractAddress,
    Move: (ContractAddress, models::Direction)
}

fn main() -> WorldState {
    let player = contract_address_const::<0>();
    let mut world = WorldState { positions: Default::default(), moves: Default::default(), };

    let txns = array![
        TransactionType::Spawn(player),
        TransactionType::Move((player, models::Direction::Up)),
        TransactionType::Move((player, models::Direction::Up)),
    ];
    for txn in txns {
        match txn {
            TransactionType::Spawn(player) => { ActionsImpl::spawn(ref world, player) },
            TransactionType::Move((
                player, direction
            )) => { ActionsImpl::move(ref world, player, direction) },
        }
    };
    world
}
