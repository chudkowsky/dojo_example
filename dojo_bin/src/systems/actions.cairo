pub mod actions {
    use starknet::contract_address_const;
    use starknet::ContractAddress;
    use core::dict::Felt252Dict;
    use binary_dojo_example::models::Position;
    use binary_dojo_example::models::Moves;
    use binary_dojo_example::models::Direction;
    use binary_dojo_example::models::Vec2;
    use core::nullable::{match_nullable, FromNullableResult, Nullable, NullableTrait};
    #[derive(Destruct)]
    pub struct WorldState {
        pub positions: Felt252Dict<Nullable<Position>>,
        pub moves: Felt252Dict<Nullable<Moves>>,
    }

    pub trait IActions {
        fn spawn(ref world: WorldState, player: ContractAddress);
        fn move(ref world: WorldState, player: ContractAddress, direction: Direction);
    }
    pub impl ActionsImpl of IActions {
        fn spawn(ref world: WorldState, player: ContractAddress) {
            let box_position = NullableTrait::new(
                identity(Position { player: player, vec: Vec2 { x: 10, y: 10, }, })
            );

            world.positions.insert(player.into(), box_position);
            let box_moves = NullableTrait::new(
                identity(
                    Moves {
                        player: player,
                        remaining: 100,
                        last_direction: Direction::None,
                        can_move: true,
                    }
                )
            );
            world.moves.insert(player.into(), box_moves);
        }
        fn move(ref world: WorldState, player: ContractAddress, direction: Direction) {
            let position = world.positions.get(player.into());
            let position = match match_nullable(position) {
                FromNullableResult::Null => { return; },
                FromNullableResult::NotNull(value) => value.unbox(),
            };
            let moves = world.moves.get(player.into());
            let moves = match match_nullable(moves) {
                FromNullableResult::Null => { return; },
                FromNullableResult::NotNull(value) => value.unbox(),
            };
            if moves.remaining == 0 {
                let box_moves = NullableTrait::new(
                    identity(
                        Moves {
                            player: player,
                            remaining: 0,
                            last_direction: direction,
                            can_move: false,
                        }
                    )
                );
                world.moves.insert(player.into(), box_moves);
                return;
            } else {
                let box_position = NullableTrait::new(identity(position));
                world.positions.insert(player.into(), box_position);
                let moves = Moves {
                    player: player,
                    remaining: moves.remaining - 1,
                    last_direction: direction,
                    can_move: true,
                };
                let box_moves = NullableTrait::new(identity(moves));
                world.moves.insert(player.into(), box_moves);
            }
        }
    }
    fn next_position(mut position: Position, direction: Direction) -> Position {
        match direction {
            Direction::None => { return position; },
            Direction::Left => { position.vec.x -= 1; },
            Direction::Right => { position.vec.x += 1; },
            Direction::Up => { position.vec.y += 1; },
            Direction::Down => { position.vec.y -= 1; },
        };
        position
    }
    #[inline(never)]
    fn identity<T>(t: T) -> T {
        t
    }
}

