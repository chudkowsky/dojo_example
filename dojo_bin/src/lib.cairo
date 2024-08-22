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

fn main(input:Array<felt252>) -> Array<felt252> {
    //todo: implement deserialize input for player, world and array of transactions
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
    let mut output: Array<felt252> = ArrayTrait::new();
    player.serialize(ref output);
    let position = world.positions.get(player.into()).deref();
    position.serialize(ref output);
    let moves = world.moves.get(player.into()).deref();
    moves.serialize(ref output);
    output}
    //[0, 0, 10, 10, 0, 98, 3, 1]