import Candy "mo:candy_library/types";

module{
    type Test<T> = {
        hex: Text;
        decoded: T
    };

    public let testVectors = {
        nat8:[Test<Nat8>] = [
            {
                hex= "00";
                roundtrip= true;
                decoded= 0
            },
            {
                hex= "01";
                roundtrip= true;
                decoded= 1
            },
            {
                hex= "0a";
                roundtrip= true;
                decoded= 10
            },
            {
                hex= "17";
                roundtrip= true;
                decoded= 23
            },
            {
                hex= "1818";
                roundtrip= true;
                decoded= 24
            },
            {
                hex= "1819";
                roundtrip= true;
                decoded= 25
            },
            {
                hex= "1864";
                roundtrip= true;
                decoded= 100
            }
        ];

        nat16:[Test<Nat16>] = [
            {
                hex= "1903e8";
                roundtrip= true;
                decoded= 1000
            }
        ];

        nat32:[Test<Nat32>] = [
            {
                hex= "1a000f4240";
                roundtrip= true;
                decoded= 1000000
            }
        ];

        nat64:[Test<Nat64>] = [
            {
                hex= "1b000000e8d4a51000";
                roundtrip= true;
                decoded= 1000000000000
            },
            {
                hex= "1bffffffffffffffff";
                roundtrip= true;
                decoded= 18446744073709551615
            }
        ];

        // exceeds nat64
        bignum = [
            {
                hex= "c249010000000000000000";
                roundtrip= true;
                decoded= 18446744073709551616
            }
        ];

        int8:[Test<Int8>] = [
            {
                hex= "20";
                roundtrip= true;
                decoded= -1
            },
            {
                hex= "29";
                roundtrip= true;
                decoded= -10
            },
            {
                hex= "3863";
                roundtrip= true;
                decoded= -100
            }
        ];

        int16:[Test<Int16>] = [
            {
                hex= "3903e7";
                roundtrip= true;
                decoded= -1000
            }
        ];

        int32:[Test<Int32>] = [
            {
                hex= "3A2AAAAAA9";
                roundtrip= true;
                decoded= -715827882
            }
        ];

        int64:[Test<Int64>] = [
            {
                hex= "3B04BDA12F684BDA01";
                roundtrip= true;
                decoded= -341606371735362050
            }
        ];

        bigint = [
            {
                hex= "3bffffffffffffffff";
                roundtrip= true;
                decoded= -18446744073709551616
            },
            {
                hex = "c349010000000000000000";
                roundtrip= true;
                decoded= -18446744073709551617
            }
        ];
        
        // float = [
        //     {
        //         hex= "f90000";
        //         roundtrip= true;
        //         decoded= 0.0
        //     },
        //     {
        //         hex= "f98000";
        //         roundtrip= true;
        //         decoded= -0.0
        //     },
        //     {
        //         hex= "f93c00";
        //         roundtrip= true;
        //         decoded= 1.0
        //     },
        //     {
        //         hex= "fb3ff199999999999a";
        //         roundtrip= true;
        //         decoded= 1.1
        //     },
        //     {
        //         hex= "f93e00";
        //         roundtrip= true;
        //         decoded= 1.5
        //     },
        //     {
        //         hex= "f97bff";
        //         roundtrip= true;
        //         decoded= 65504.0
        //     },
        //     {
        //         hex= "fa47c35000";
        //         roundtrip= true;
        //         decoded= 100000.0
        //     },
            // {
            //     hex= "fa7f7fffff";
            //     roundtrip= true;
            //     decoded= 3.4028234663852886e+38
            // },
            // {
            //     hex= "fb7e37e43c8800759c";
            //     roundtrip= true;
            //     decoded= 1.0e+300
            // },
            // {
            //     hex= "f90001";
            //     roundtrip= true;
            //     decoded= 5.960464477539063e-08
            // },
            // {
            //     hex= "f90400";
            //     roundtrip= true;
            //     decoded= 6.103515625e-05
            // },
        //     {
        //         hex= "f9c400";
        //         roundtrip= true;
        //         decoded= -4.0
        //     },
        //     {
        //         hex= "fbc010666666666666";
        //         roundtrip= true;
        //         decoded= -4.1
        //     }
        // ]
    //     // {
    //     //     hex= "f97c00";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "Infinity"
    //     // },
    //     // {
    //     //     hex= "f97e00";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "NaN"
    //     // },
    //     // {
    //     //     hex= "f9fc00";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "-Infinity"
    //     // },
    //     // {
    //     //     hex= "fa7f800000";
    //     //     roundtrip= false;
    //     //     "diagnostic"= "Infinity"
    //     // },
    //     // {
    //     //     hex= "fa7fc00000";
    //     //     roundtrip= false;
    //     //     "diagnostic"= "NaN"
    //     // },
    //     // {
    //     //     hex= "faff800000";
    //     //     roundtrip= false;
    //     //     "diagnostic"= "-Infinity"
    //     // },
    //     // {
    //     //     hex= "fb7ff0000000000000";
    //     //     roundtrip= false;
    //     //     "diagnostic"= "Infinity"
    //     // },
    //     // {
    //     //     hex= "fb7ff8000000000000";
    //     //     roundtrip= false;
    //     //     "diagnostic"= "NaN"
    //     // },
    //     // {
    //     //     hex= "fbfff0000000000000";
    //     //     roundtrip= false;
    //     //     "diagnostic"= "-Infinity"
    //     // },
    //     // {
    //     //     hex= "f7";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "undefined"
    //     // },
    //     // {
    //     //     hex= "f0";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "simple(16)"
    //     // },
    //     // {
    //     //     hex= "f818";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "simple(24)"
    //     // },
    //     // {
    //     //     hex= "f8ff";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "simple(255)"
    //     // },
    //     // {
    //     //     hex= "c074323031332d30332d32315432303a30343a30305a";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "0(\"2013-03-21T20=04=00Z\")"
    //     // },
    //     // {
    //     //     hex= "c11a514b67b0";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "1(1363896240)"
    //     // },
    //     // {
    //     //     hex= "c1fb41d452d9ec200000";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "1(1363896240.5)"
    //     // },
    //     // {
    //     //     hex= "d74401020304";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "23(h'01020304')"
    //     // },
    //     // {
    //     //     hex= "d818456449455446";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "24(h'6449455446')"
    //     // },
    //     // {
    //     //     hex= "d82076687474703a2f2f7777772e6578616d706c652e636f6d";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "32(\"http=//www.example.com\")"
    //     // },
    //     // {
    //     //     hex= "40";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "h''"
    //     // },
    //     // {
    //     //     hex= "4401020304";
    //     //     roundtrip= true;
    //     //     "diagnostic"= "h'01020304'"
    //     // },

        text:[Test<Text>] = [
            {
                hex= "60";
                roundtrip= true;
                decoded = ""
            },
            {
                hex= "6161";
                roundtrip= true;
                decoded= "a"
            },
            {
                hex= "6449455446";
                roundtrip= true;
                decoded= "IETF"
            },
            {
                hex= "62225c";
                roundtrip= true;
                decoded= "\"\\"
            },
            

            // not utf8
            // {
            //     hex= "62c3bc";
            //     roundtrip= true;
            //     decoded= "ü"
            // },
            // {
            //     hex= "63e6b0b4";
            //     roundtrip= true;
            //     decoded= "水"
            // },
            // {
            //     hex= "64f0908591";
            //     roundtrip= true;
            //     decoded= "𐅑"
            // },
        ];
            
        nats = [
            {
                hex = "80";
                roundtrip = true;
                decoded = [ ]
            },
            {
                hex = "83010203";
                roundtrip = true;
                decoded = [ 1, 2, 3 ]
            },
            // {
            //     hex= "7f657374726561646d696e67ff";
            //     roundtrip= false;
            //     decoded= "streaming"
            // },
            {
                hex = "98190102030405060708090a0b0c0d0e0f101112131415161718181819";
                roundtrip = true;
                decoded = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 ]
            }
        ];

        // arr:[Test<Any>] = [
        //     {
        //         hex= "826161bf61626163ff";
        //         roundtrip= false;
        //         decoded= [ "a", [{name = "b"; value = "c"; immutable = true}] ]
        //     },
        //     {
        //         hex = "8301820203820405";
        //         roundtrip = true;
        //         decoded = [1, #Nats(#frozen([2, 3])), #Nats(#frozen([4,  5]))]
        //     },
         // {
            //     hex= "826161a161626163";
            //     roundtrip= true;
            //     decoded= [
            //         {
            //             name = "a" ; 
            //             value = #Class([
            //                 {name = "b"; value = #Text("c"); immutable = true},
            //             ]); 
            //             immutable = true
            //         },
            //     ]
            // },
        // ];

        candidArr:[Test<Any>] = [];

        map:[Test<[Candy.Property]>] = [
            {
                hex = "a0";
                roundtrip = true;
                decoded = []
            },
            {
                hex= "A2613102613304";
                roundtrip = true;
                decoded = [
                    {name = "1"; value = #Nat(2); immutable = true},
                    {name = "3"; value = #Nat(4); immutable = true}
                ];
            },
            {
                hex= "a26161016162820203";
                roundtrip= true;
                decoded= [
                    {name = "a" ; value = #Nat(1); immutable = true},
                    {name = "b" ; value = #Nats(#frozen([2, 3])); immutable = true}
                ]
            },
            {
                hex= "a56161614161626142616361436164614461656145";
                roundtrip= true;
                decoded= [
                    {name = "a"; value = #Text("A"); immutable = true},
                    {name = "b"; value = #Text("B"); immutable = true},
                    {name = "c"; value = #Text("C"); immutable = true},
                    {name = "d"; value = #Text("D"); immutable = true},
                    {name = "e"; value = #Text("E"); immutable = true},
                ]
            },
            // {
            //     hex= "bf61610161629f0203ffff";
            //     roundtrip= false;
            //     decoded= [
            //         {name = "a" ; value = 1; immutable = true},
            //         {name = "b" ; value = [2, 3]; immutable = true}
            //     ]
            // },
            
            // {
            //     hex= "bf6346756ef563416d7421ff";
            //     roundtrip= false;
            //     decoded= [
            //         {name = "Fun"; value = #Bool(true); immutable = true},
            //         {name = "Amt"; value = #Int(-2); immutable = true},
            //     ]

            // }
        ];
        
    }
}