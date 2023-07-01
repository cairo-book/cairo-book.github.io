use array::ArrayTrait;

fn main() {
    let mut arr = ArrayTrait::new();
    arr.append(1);
    arr.append(2);
    arr.append(3);
    arr.append(4);
    arr.append(5);
    
    let mut arr_macro = array![1, 2, 3, 4, 5];
}
