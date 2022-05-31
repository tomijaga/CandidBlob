import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Char "mo:base/Char";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int8 "mo:base/Int8";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Int16 "mo:base/Int16";
import Int32 "mo:base/Int32";
import Int64 "mo:base/Int64";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Float "mo:base/Float";
import Principal "mo:base/Principal";

import Result "mo:base/Result";

import Candy "mo:candy_library/types";

import Utils "Utils";
//https://docs.rs/crate/cbor/latest/source/src/decoder.rs

module {
    type CandyValue = Candy.CandyValue;
    type CandyValueUnstable = Candy.CandyValueUnstable;
    type CandyArraySubType<T> = {
        #frozen: [T];
        #thawed: [T];
    };

    public func encode_unstable(data: CandyValueUnstable): Result.Result<Blob, Text> {
        let stable_data = Candy.stabalizeValue(data);
        encode(stable_data)
    };

    public func encode(data: CandyValue): Result.Result<Blob, Text> {
        let buf = Buffer.Buffer<Nat8>(0);
        let result = encode_into_buf(buf: Buffer.Buffer<Nat8>, data);

        switch(result){
            case(#ok){
                #ok(Blob.fromArray(buf.toArray()))
            };
            case(#err(errMsg)){
                #err(errMsg)
            };
        }
    };

    public func encode_into_buf(buf: Buffer.Buffer<Nat8>, data: CandyValue): Result.Result<(), Text> {

        switch(data){
            case (#Empty){
                buf.add(0xF6);
            };
            case (#Bool(bool)){
                switch(bool){
                    case(true){
                        buf.add(0xF5);
                    };
                    case(false){
                        buf.add(0xF4)
                    };
                };
            };
            case(#Nat(n)){
                encode_nat(buf, n);
            };
            case(#Nat8(n)){
                encode_nat(buf, Nat8.toNat(n));
            };
            case(#Nat16(n)){
                encode_nat(buf, Nat16.toNat(n));
            };
            case(#Nat32(n)){
                encode_nat(buf, Nat32.toNat(n));
            };
            case(#Nat64(n)){
                encode_nat(buf, Nat64.toNat(n));
            };
            case(#Int(n)){
                encode_int(buf, n);
            };
            case(#Int8(n)){
                encode_int(buf, Int8.toInt(n));
            };
            case(#Int16(n)){
                encode_int(buf, Int16.toInt(n));
            };
            case(#Int32(n)){
                encode_int(buf, Int32.toInt(n));
            };
            case(#Int64(n)){
                encode_int(buf, Int64.toInt(n));
            };
            // encoding double precision floating point
            case(#Float(f)){
                // encode_float(buf, f);
            };

            // only encodes utf8
            case (#Text(t)){
                encode_num(buf, t.size(), 3);
                let b = Text.encodeUtf8(t);
                let arr = Blob.toArray(b);
                buf.append(Utils.arrayToBuffer(arr));

            };

            case (#Nats(candyArr)){
                let result = encode_array<Nat>(buf, candyArr, func(n){ #Nat(n)});
                if (Result.isErr(result)){
                    return result;
                };
            };

            case (#Array(candyArr)){
                let result = encode_array<CandyValue>(buf, candyArr, func(val){ val});
                if (Result.isErr(result)){
                    return result;
                };
            };

            case(#Floats(_)){
                // encode_float(buf, f);
            };

            case (#Bytes(candyByteArr)){
                let bytes = unwrap_array<Nat8>(candyByteArr);
                
                encode_num(buf, bytes.size(), 2);

                for (n8 in bytes.vals()){
                    buf.add(n8)
                };
            };
            case (#Blob(blob)){
                let bytes = Blob.toArray(blob);
                ignore encode_into_buf(buf, #Bytes(#frozen(bytes)));
            };

            case (#Class(properties)){
                encode_num(buf, properties.size(), 5);

                for (property in properties.vals()){
                    let {name; value} = property;
                    let name_result =  encode_into_buf(buf, #Text(name));
                    if (Result.isErr(name_result)){
                        return name_result;
                    };

                    let value_result = encode_into_buf(buf, value);
                    if (Result.isErr(value_result)){
                        return value_result;
                    };
                };
            };

            case (#Principal(p)){
                let p_as_blob = Principal.toBlob(p);
                ignore encode_into_buf(buf, #Blob(p_as_blob));
            };

            case (#Option(optValue)){
                switch(optValue){
                    case(?val){
                        let result = encode_into_buf(buf, val);
                        if (Result.isErr(result)){
                            return result;
                        };
                    };
                    case(_){
                        ignore encode_into_buf(buf, #Empty);
                    };
                };
            };
        };

        return #ok(); 
    };

    func encode_array<T>(buf: Buffer.Buffer<Nat8>, candyArr: CandyArraySubType<T>, mapFn: (T)-> CandyValue): Result.Result<(), Text>{
        let arr = unwrap_array<T>(candyArr);

        //encode array size
        encode_num(buf, arr.size(), 4);

        for (val in Iter.map<T, CandyValue>(arr.vals(), mapFn)){
            let result = encode_into_buf(buf, val);

            if (Result.isErr(result)){
                return result;
            };
        };

        #ok()
    };

    func unwrap_array<T>(candyArr: CandyArraySubType<T>): [T] {
        switch(candyArr){
            case(#frozen(arr)){
                arr
            };
            case(#thawed(arr)){
                arr
            };
        }
    };

    func num_as_bytes(n: Nat64):Buffer.Buffer<Nat8>{
        var n_bits:Nat64 = if (n < 0x80){
            8
        }else if (n < 0x8000){
            16
        }else if (n < 0x80000000){
            32
        }else{
            64
        };

        let buf = Buffer.Buffer<Nat8>(Nat64.toNat(n_bits/8));

        while(n_bits > 0){
            n_bits -= 8;
            let b = ( n >> n_bits ) & 0xff;
            let byte = Nat8.fromNat(Nat64.toNat(b));
            buf.add(byte);
        };

        return buf;
    };

    func encode_nat(buf: Buffer.Buffer<Nat8>, n: Nat){
        encode_num(buf, n, 0);
    };

    func encode_int(buf: Buffer.Buffer<Nat8>, n: Int){
        if (n >= 0){
            encode_num(buf, Int.abs(n), 0);
        }else{
            encode_num(buf, Int.abs(-1 - n), 1);
        };
    };

    // negative numbers are encoded using two's complement
    func encode_num(buf: Buffer.Buffer<Nat8>, n: Nat, pos: Nat8){
        let major:Nat8 = pos << 5;
        let bytes = num_as_bytes(Nat64.fromNat(n));

        switch(bytes.size()){
            case(1){
                let byte = bytes.get(0);

                if (byte >= 0x18 ){
                    buf.add( major | 0x18 );
                }else{
                    buf.add( major | byte );
                    return;
                };
            };
            case(2){
                buf.add( major | 0x19 );
            };
            case(4){
                buf.add( major | 0x1A );
            };
            case(_){
                buf.add( major | 0x1B )
            };
        };

        buf.append(bytes)
    };

    // func encode_float(buf: Buffer.Buffer<Nat8>, f: Float){
    //     var n_bits:Float = 64;
        
    //     buf.
    //     let v = f << 0xffffffff;
    //     Debug.print(debug_show v);

        // while(n_bits > 0){
        //     n_bits -= 8;
        //     let b = ( f >> n_bits ) & 0xff;
        //     let byte = Nat8.fromNat(Int.abs(Float.toInt(b)));
        //     buf.add(byte);
        // };
    // };
};
