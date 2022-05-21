import Result "mo:base/Result";

import Candy "mo:candy_library/types";

module{
    type CandyValue = Candy.CandyValue;
    type CandyValueUnstable = Candy.CandyValueUnstable;

    public decode_unstable(blob: Blob): CandyValueUnstable{
        let stable_data = decode(blob);
        Candy.destabalizeValue(stable_data)
    };

    public func decode(blob: Blob): Result.Result<CandyValue, ()>{
        let blobArray = Blob.toArray(blob);

        func read_item(i: Nat): Result.Result<CandyValue, ()>{
            let item = blobArray[i];

            switch(item << ){
                case (0){
                    read_nat(i)
                };
            }
        };

        func read_nat(i:Nat): Result.Result<CandyValue, ()>{
            let item = blobArray[i];

            if (item < 0x18){
                return #ok(#Nat8(i));
            };

            #err()
        };
    };
}