#[starknet::contract]
mod contract {
    use starknet::ContractAddress;
    //ANCHOR: here
    #[storage]
    struct Storage {
        id: u8,
        names: LegacyMap::<ContractAddress, felt252>,
    }
//ANCHOR_END: here
}
