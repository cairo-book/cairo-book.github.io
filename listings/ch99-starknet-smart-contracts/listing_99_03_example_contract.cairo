use starknet::ContractAddress;

#[starknet::interface] //ANCHOR: all
trait IExample<TContractState> {
    fn store_name(ref self: TContractState, _name: felt252);
    fn get_name(self: @TContractState, _address: ContractAddress) -> felt252;
}


#[starknet::contract]
mod example {
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        names: LegacyMap::<ContractAddress, felt252>, 
    }

    //ANCHOR: event
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        StoredName: StoredName, 
    }

    #[derive(Drop, starknet::Event)]
    struct StoredName {
        caller: ContractAddress,
        name: felt252
    }
    //ANCHOR_END: event

    //ANCHOR: constructor
    #[constructor]
    fn constructor(ref self: ContractState, _name: felt252, _address: ContractAddress) {
        self.names.write(_address, _name);
    }
    //ANCHOR_END: constructor

    //ANCHOR: external
    #[external(v0)]
    impl Example of super::IExample<ContractState> {
        fn store_name(ref self: ContractState, _name: felt252) {
            let _caller = get_caller_address();
            //ANCHOR: write
            self.names.write(_caller, _name);
            //ANCHOR_END: write
            //ANCHOR: emit_event
            self.emit(Event::StoredName(StoredName { caller: _caller, name: _name }));
        //ANCHOR_END: emit_event
        }
        //ANCHOR_END: external

        //ANCHOR: view
        fn get_name(self: @ContractState, _address: ContractAddress) -> felt252 {
            //ANCHOR: read
            let name = self.names.read(_address);
            //ANCHOR_END: read
            name
        }
    //ANCHOR_END: view
    }
}
//ANCHOR_END: all


