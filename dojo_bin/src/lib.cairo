mod models;
pub mod systems {
    pub mod actions;
}
use starknet::contract_address_const;
use starknet::ContractAddress;
use models::Direction;
use systems::actions::actions::ActionsImpl;
use systems::actions::actions::WorldState;
use core::dict::Felt252Dict;

#[derive(Drop,Serde,Clone,Copy,Debug)]
enum TransactionType {
    Spawn: ContractAddress,
    Move: (ContractAddress, models::Direction)
}

fn main(input: Array<felt252>) -> Array<felt252> {
    //todo: implement deserialize input for player, world and array of transactions
    let mut input = input.span();
    let mut txns:Array::<TransactionType> = Serde::deserialize(ref input).unwrap();
    let mut world = WorldState { positions: Default::default(), moves: Default::default(),};
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
   
    for player in players {
        let position = world.positions.get(player.into()).deref();
        let moves = world.moves.get(player.into()).deref();
        // println!("player: {:?}, position: {:?}, moves: {:?}", player,position,moves);
        player.serialize(ref output);
        position.serialize(ref output);
        moves.serialize(ref output);
    };
    println!("{:?}", output);
    output
}
//[0, 0, 10, 10, 0, 98, 3, 1]

