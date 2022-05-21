let aviate_labs = https://github.com/aviate-labs/package-set/releases/download/v0.1.4/package-set.dhall sha256:30b7e5372284933c7394bad62ad742fec4cb09f605ce3c178d892c25a1a9722e
let vessel_package_set =
      https://github.com/dfinity/vessel-package-set/releases/download/mo-0.6.20-20220131/package-set.dhall

let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

let  additions =
    [
      { name = "candy_library"
      , version = "v0.1.9"
      , repo = "https://github.com/aramakme/candy_library"
      , dependencies = [] : List Text
      }
    ] : List Package

in  aviate_labs # vessel_package_set # additions
