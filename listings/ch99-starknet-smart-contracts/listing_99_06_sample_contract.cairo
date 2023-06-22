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

//ANCHOR: here
//**** Specify interface here ****//
#[starknet::contract]
mod TokenWrapper {
    use super::IERC20DispatcherTrait;
    use super::IERC20Dispatcher;
    use starknet::ContractAddress;

    impl Dispatcher of super::IDispatcher<ContractState> {
        fn token_name(self: @ContractState, _contract_address: ContractAddress) -> felt252 {
            IERC20Dispatcher { contract_address: _contract_address }.name()
        }

        fn transfer_token(
            self: @ContractState,
            _contract_address: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            IERC20Dispatcher { contract_address: _contract_address }.transfer(recipient, amount)
        }
    }
}
// ANCHOR_END: here


