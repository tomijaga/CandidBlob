import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

import Hex "mo:encoding/Hex";


import Cbor "../src";
import TestVectors "TestVectors";

import ActorSpec "./utils/ActorSpec";
type Group = ActorSpec.Group;

let {
    assertTrue; assertFalse; assertAllTrue; describe; it; skip; pending; run
} = ActorSpec;

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

func validate_blob(blob: Blob, hex: Text): Bool {
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
        results.add(validate_blob(blob, hex));
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
        validate_blob(blob, "f4")
      }),
      it("Bool (true)", do{
        let blob = unwrap_blob(Cbor.encode(#Bool(true)));
        validate_blob(blob, "f5")
      }),
      it("Empty", do{
        let blob = unwrap_blob(Cbor.encode(#Empty));
        validate_blob(blob, "f6")
      })
    ]),
    describe("Encode", [
      it("Bytes", do {
        let arr: [Nat8] = [0x63, 0x62, 0x6F, 0x72 ];
        let blob = unwrap_blob(Cbor.encode(#Bytes(#frozen(arr))));
        let testBlob = Blob.fromArray([0x42, 0x18, 0x63, 0x18,0x62, 0x18,0x6F, 0x18, 0x72 ]);

        assertTrue(validate_blob(blob, ""));
      }),
      it("Blob", do{
        let blob = unwrap_blob(Cbor.encode(#Float 23.4556));

        assertTrue(validate_blob(blob, "FB403774A2339C0EBF"));
      })
    ]),
  ]),
]);

if(success == false){
  Debug.trap("Tests failed");
};
