#[starknet::contract]
mod access_control_contract {
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    trait IContract<TContractState> {
        fn is_owner(self: @TContractState) -> bool;
        fn is_role_a(self: @TContractState) -> bool;
        fn only_owner(self: @TContractState);
        fn only_role_a(self: @TContractState);
        fn only_allowed(self: @TContractState);
        fn set_role_a(ref self: TContractState, _target: ContractAddress, _active: bool);
        fn role_a_action(ref self: ContractState);
        fn allowed_action(ref self: ContractState);
    }

    #[storage]
    struct Storage {
        // Role 'owner': only one address
        owner: ContractAddress,
        // Role 'role_a': a set of addresses
        role_a: LegacyMap::<ContractAddress, bool>
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
    }

    // Guard functions to check roles

    impl Contract of IContract<ContractState> {
        #[inline(always)]
        fn is_owner(self: @ContractState) -> bool {
            self.owner.read() == get_caller_address()
        }

        #[inline(always)]
        fn is_role_a(self: @ContractState) -> bool {
            self.role_a.read(get_caller_address())
        }

        #[inline(always)]
        fn only_owner(self: @ContractState) {
            assert(Contract::is_owner(self), 'Not owner');
        }

        #[inline(always)]
        fn only_role_a(self: @ContractState) {
            assert(Contract::is_role_a(self), 'Not role A');
        }

        // You can easily combine guards to perfom complex checks
        fn only_allowed(self: @ContractState) {
            assert(Contract::is_owner(self) || Contract::is_role_a(self), 'Not allowed');
        }

        // Functions to manage roles

        fn set_role_a(ref self: ContractState, _target: ContractAddress, _active: bool) {
            Contract::only_owner(@self);
            self.role_a.write(_target, _active);
        }

        // You can now focus on the business logic of your contract
        // and reduce the complexity of your code by using guard functions

        fn role_a_action(ref self: ContractState) {
            Contract::only_role_a(@self);
        // ...
        }

        fn allowed_action(ref self: ContractState) {
            Contract::only_allowed(@self);
        // ...
        }
    }
}

