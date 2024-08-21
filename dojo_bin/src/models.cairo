use starknet::ContractAddress;
#[derive(Copy, Drop, Serde,Debug)]
pub struct Moves {
    pub player: ContractAddress,
    pub remaining: u8,
    pub last_direction: Direction,
    pub can_move: bool,
}

#[derive(Drop, Serde)]
pub struct DirectionsAvailable {
    pub player: ContractAddress,
    pub directions: Array<Direction>,
}

#[derive(Copy, Drop, Serde,Debug)]
pub struct Position {
    pub player: ContractAddress,
    pub vec: Vec2,
}



#[derive(Serde, Copy, Drop,PartialEq,Debug)]
pub enum Direction {
    None,
    Left,
    Right,
    Up,
    Down,
}


#[derive(Copy, Drop, Serde,Debug)]
pub struct Vec2 {
    pub x: u32,
    pub y: u32
}


impl DirectionIntoFelt252 of Into<Direction, felt252> {
    fn into(self: Direction) -> felt252 {
        match self {
            Direction::None => 0,
            Direction::Left => 1,
            Direction::Right => 2,
            Direction::Up => 3,
            Direction::Down => 4,
        }
    }
}


#[generate_trait]
impl Vec2Impl of Vec2Trait {
    fn is_zero(self: Vec2) -> bool {
        if self.x - self.y == 0 {
            return true;
        }
        false
    }

    fn is_equal(self: Vec2, b: Vec2) -> bool {
        self.x == b.x && self.y == b.y
    }
}

