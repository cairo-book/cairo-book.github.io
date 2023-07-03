#[starknet::contract]
mod contract {
    use starknet::ContractAddress;
    //ANCHOR: here
    #[storage]
    struct Storage {
        allowances: LegacyMap::<(ContractAddress, ContractAddress), u256>
    }
//ANCHOR_END: here
}
