//**** Specify interface here ****//
use starknet::ContractAddress;

#[starknet::interface]
trait IERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;

    fn symbol(self: @TContractState) -> felt252;

    fn decimals(self: @TContractState) -> u8;

    fn total_supply(self: @TContractState) -> u256;

    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;

    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;

    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;

    fn transfer_from(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
}

#[starknet::interface]
trait ITokenWrapper<TContractState> {
    fn token_name(self: @TContractState) -> felt252;

    fn transfer_token(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
}

//ANCHOR: here
#[starknet::contract]
mod token_wrapper {
    use super::IERC20DispatcherTrait;
    use super::IERC20LibraryDispatcher;
    use starknet::ContractAddress;
    use super::ITokenWrapper;

    #[storage]
    struct Storage {}

    impl TokenWrapper of ITokenWrapper<ContractState> {
        fn token_name(self: @ContractState) -> felt252 {
            IERC20LibraryDispatcher { class_hash: starknet::class_hash_const::<0x1234>() }.name()
        }

        fn transfer_token(
            ref self: ContractState, recipient: ContractAddress, amount: u256
        ) -> bool {
            IERC20LibraryDispatcher {
                class_hash: starknet::class_hash_const::<0x1234>()
            }.transfer(recipient, amount)
        }
    }
}
//ANCHOR_END: here


