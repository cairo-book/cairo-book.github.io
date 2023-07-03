#[starknet::interface]
trait IContract<TContractState> {
    fn withdraw(ref self: TContractState, amount: u256);
}

#[starknet::contract]
mod contract {
    use super::IContract;
    #[storage]
    struct Storage {
        balance: u256
    }

    //ANCHOR: withdraw
    impl Contract of IContract<ContractState> {
        fn withdraw(ref self: ContractState, amount: u256) {
            let current_balance = self.balance.read();

            assert(self.balance.read() >= amount, 'Insufficient funds');

            self.balance.write(current_balance - amount);
        }
    //ANCHOR_END: withdraw

    }
}
