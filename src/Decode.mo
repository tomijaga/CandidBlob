import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int8 "mo:base/Int8";
import Int "mo:base/Int";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Int16 "mo:base/Int16";
import Int32 "mo:base/Int32";
import Int64 "mo:base/Int64";

import Array "mo:array/Array";
import Candy "mo:candy_library/types";

module{
    type CandyValue = Candy.CandyValue;
    type CandyValueUnstable = Candy.CandyValueUnstable;

    public func decode_unstable(blob: Blob): Result.Result<CandyValueUnstable, ()> {
        let stable_data = decode(blob);
        switch(decode(blob)){
            case (#ok(stable_data)){
                #ok(Candy.destabalizeValue(stable_data))
            };
            case(_){
                #err
            };
        }
    };

    public func decode(blob: Blob): Result.Result<CandyValue, ()>{
        let blobArray = Blob.toArray(blob);
        var i = 0;

        func read_item(): Result.Result<CandyValue, ()>{
            let item = blobArray[i];
        
            switch( item >> 5 ){
                case (0){
                    read_nat()
                };
                case(1){
                    read_int()
                };
                case (2){
                    read_bytes()
                };
                // case (3){
                //     read_text()
                // };
                case (_){
                    #err
                };
            }
        };

        // func read_text(): Result.Result<CandyValue, ()> {
        //     switch(read_num()){
        //         case((len, _)){
        //             let buffer = Buffer.Buffer<Nat8>(len);

        //             if (i + len >= blobArray.size() ){
        //                 return #err;
        //             };

        //             for (_i in Iter.range(i, len)){
        //                 buffer.add(blobArray[_i]);
        //             };

        //             i+=len;

        //             #ok(#Bytes(buffer.toArray()))
        //         };
        //         case(_){
        //             #err
        //         };
        //     };
        // };

        func read_bytes(): Result.Result<CandyValue, ()> {
            switch(read_num()){
                case(#ok(len, _)){
                    let buffer = Buffer.Buffer<Nat8>(len);

                    if (i + len >= blobArray.size() ){
                        return #err;
                    };

                    for (_i in Iter.range(i, len)){
                        buffer.add(blobArray[_i]);
                    };

                    i+=len;

                    #ok(#Bytes(#frozen(buffer.toArray())))
                };
                case(_){
                    #err
                };
            };
        };

        func read_nat(): Result.Result<CandyValue, ()>{
            switch(read_num()){
                case(#ok(n, bytes)){
                    switch(bytes){
                        case(1){
                            return #ok(#Nat8(Nat8.fromNat(n)));
                        };
                        case(2){
                            return #ok(#Nat16(Nat16.fromNat(n)))
                        };
                        case(3){
                            return #ok(#Nat32(Nat32.fromNat(n)));
                        };
                        case(_){
                            return #ok(#Nat64(Nat64.fromNat(n)));
                        };
                    }
                };
                case(#err(_)){
                    #err()
                };
            }
        };

        func read_int(): Result.Result<CandyValue, ()>{
            switch(read_num()){
                case(#ok(n, bytes)){
                    var int: Int = n;
                    int := - 1 - int;

                    switch(bytes){
                        case(1){
                            return #ok(#Int8(Int8.fromInt(int)));
                        };
                        case(2){
                            return #ok(#Int16(Int16.fromInt(int)))
                        };
                        case(3){
                            return #ok(#Int32(Int32.fromInt(int)));
                        };
                        case(_){
                            return #ok(#Int64(Int64.fromInt(int)));
                        };
                    }
                };
                case(#err(_)){
                    #err()
                };
            }
        };

        func read_num(): Result.Result<(Nat, Nat), ()>{
            let item = blobArray[i];

            if (item < 0x18){
                return #ok(Nat8.toNat(item), 0);
            };

            let n_bytes = Nat8.toNat(item & 0x1f - 0x17);
            i+=1;

            let bytes = Array.slice<Nat8>(blobArray, i, i + n_bytes);
            if (bytes.size() != n_bytes){
                return #err();
            };

            let n = bytes_to_num(bytes);
            i+=n_bytes;

            #ok(n, n_bytes)
        };

        func bytes_to_num(bytes: [Nat8]): Nat {
            var n64: Nat64 = 0;

            for (i in Iter.range(0, bytes.size() -1)){
                let n8 = Nat8.toNat(bytes[i]);
                n64 &= Nat64.fromNat(n8) << ((3 - Nat64.fromNat(i)) * 8);
            };

            Nat64.toNat(n64)
        };


        read_item()
    };
}