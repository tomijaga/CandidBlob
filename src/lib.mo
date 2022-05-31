import Candy "mo:candy_library/types";

import Encode "Encode";
import Decode "Decode";

module{
    public type CandyValue = Candy.CandyValue;
    public type CandyValueUnstable = Candy.CandyValueUnstable;

    public let encode = Encode.encode;
    public let encode_unstable = Encode.encode_unstable;
    public let encode_into_buf = Encode.encode_into_buf;

    public let decode = Decode.decode;
    public let decode_unstable = Decode.decode_unstable;
};