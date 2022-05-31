import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

import Hex "mo:encoding/Hex";
import Candy "mo:candy_library/types";

import Cbor "../src";
import TestVectors "TestVectors";

import ActorSpec "./utils/ActorSpec";
type Group = ActorSpec.Group;

let {
    assertTrue; assertFalse; assertAllTrue; describe; it; skip; pending; run
} = ActorSpec;

func unwrap_candy(candy: Result.Result<Cbor.CandyValue, ()>):Cbor.CandyValue {
  switch(candy){
    case(#ok(candy)){
      candy
    };
    case(_){
      #Empty
    };
  }
};

func unwrap_blob(blob: Result.Result<Blob, Any>):Blob {
  switch(blob){
    case(#ok(blob)){
      blob
    };
    case(_){
      Blob.fromArray([])
    };
  }
};

func unwrap_bytes(bytes: Result.Result<[Nat8], Any>):[Nat8] {
  switch(bytes){
    case(#ok(bytes)){
      bytes
    };
    case(_){
      []
    };
  }
};

func assert_blob(blob: Blob, hex: Text): Bool {
  let bytes = unwrap_bytes(Hex.decode(hex));
  let testBlob = Blob.fromArray(bytes);

  Debug.print(debug_show(blob));
  Debug.print(debug_show(testBlob));

  Debug.print("");

  blob == testBlob
};

type Test<T> = {
  hex: Text;
  decoded: T
};

func run_testcase<T>(arr: [Test<T>], mapFn: (T)-> Cbor.CandyValue ): Bool {
  let results = Buffer.Buffer<Bool>(1);
      for (i in Iter.range(0, arr.size() - 1)){
        let {hex; decoded} = arr[i];
        let blob = unwrap_blob(Cbor.encode(mapFn(decoded)));
        results.add(assert_blob(blob, hex));
      };
      assertAllTrue(results.toArray());
};

let success = run([
  describe("Cbor Encode", [
    // Test Vectors adapted from https://github.com/cbor/test-vectors
    describe("Test Vectors", [
      it("Nat8", do {
        let tests = TestVectors.testVectors.nat8;
        run_testcase<Nat8>(tests, func(decoded){#Nat8(decoded)})
      }),
      it("Nat16", do {
        let tests = TestVectors.testVectors.nat16;
        run_testcase<Nat16>(tests, func(decoded){#Nat16(decoded)})
      }),
      it("Nat32", do {
       let tests = TestVectors.testVectors.nat32;
        run_testcase<Nat32>(tests, func(decoded){#Nat32(decoded)})
      }),
      it("Nat64", do {
        let tests = TestVectors.testVectors.nat64;
        run_testcase<Nat64>(tests, func(decoded){#Nat64(decoded)})
      }),
      it("Int8", do {
        let tests = TestVectors.testVectors.int8;
        run_testcase<Int8>(tests, func(decoded){#Int8(decoded)})
      }),
      it("Int16", do {
        let tests = TestVectors.testVectors.int16;
        run_testcase<Int16>(tests, func(decoded){#Int16(decoded)})
      }),
      it("Int32", do {
        let tests = TestVectors.testVectors.int32;
        run_testcase<Int32>(tests, func(decoded){#Int32(decoded)})
      }),
      it("Int64", do {
        let tests = TestVectors.testVectors.int64;
        run_testcase<Int64>(tests, func(decoded){#Int64(decoded)})
      }),
      it("Bool (false)", do{
        let blob = unwrap_blob(Cbor.encode(#Bool(false)));
        assert_blob(blob, "f4")
      }),
      it("Bool (true)", do{
        let blob = unwrap_blob(Cbor.encode(#Bool(true)));
        assert_blob(blob, "f5")
      }),
      it("Empty", do{
        let blob = unwrap_blob(Cbor.encode(#Empty));
        assert_blob(blob, "f6")
      }),
      it("Nats", do{
        let tests = TestVectors.testVectors.nats;
        run_testcase<[Nat]>(tests, func(decoded){#Nats(#frozen(decoded))})
      }),
      it("Text", do{
        let tests = TestVectors.testVectors.text;
        run_testcase<Text>(tests, func(decoded){#Text(decoded)})
      }),
      it("Class/Map", do{
        let tests = TestVectors.testVectors.map;
        run_testcase<[Candy.Property]>(tests, func(decoded){#Class(decoded)})
      })
    ]),
    describe("Float", [
      it("Float", do{
        let f = 3.23;
        let i = Float.toInt(f);
        let  nf = Float.fromInt(i) ;

        Debug.print(debug_show (f, i, nf, Float.toInt(f * 10_000_000_000_000_000)));
        
        assertTrue(nf == f)
      })
    ]),
  ]),

  describe("Decode", [
    it("Nat8", do {

      let blob = Blob.fromArray([0]);
      let candy_value = unwrap_candy(Cbor.decode(blob));

      assertTrue(candy_value == #Nat8(0));
    })
  ]),
]);

if(success == false){
  Debug.trap("Tests failed");
};
