mod systems {
    pub mod actions;
}

mod models;
use systems::actions::actions::WorldState;
use systems::actions::actions::ActionsImpl;
use starknet::contract_address_const;
use starknet::ContractAddress;
#[derive(Drop)]
enum TransactionType {
    Spawn: ContractAddress,
    Move: (ContractAddress, models::Direction)
}

fn main() -> WorldState {
    let mut world = WorldState { positions: Default::default(), moves: Default::default(), };
    let player = contract_address_const::<0>();

    let txns = array![
        TransactionType::Spawn(player),
        TransactionType::Move((player, models::Direction::Up)),
        TransactionType::Move((player, models::Direction::Up)),
    ];
    for txn in txns {
        match txn {
            TransactionType::Spawn(player) => { ActionsImpl::spawn(ref world, player); },
            TransactionType::Move((
                player, direction
            )) => { ActionsImpl::move(ref world, player, direction); },
        }
    };
    let position = world.positions.get(player.into());
    let moves = world.moves.get(player.into());
    if position.is_null() {
        panic!("Position is null");
    }
    println!("{:?}", position);
    if moves.is_null() {
        panic!("Moves is null");
    }
    println!("{:?}", moves);
    world
}
