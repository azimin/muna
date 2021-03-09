//
//  BetaKeyService.swift
//  Muna
//
//  Created by Alexander on 8/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class BetaKeyService {
    var isEntered: Bool {
        return true
    }

    var key: String? {
        get {
            return UserDefaults.standard.string(forKey: "beta_key")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "beta_key")

            if let value = newValue {
                ServiceLocator.shared.analytics.setPersonProperty(
                    name: "beta_key",
                    value: value
                )
            }
        }
    }

    func validate(key: String) -> Bool {
        return keys.contains(key)
    }
}

var keys: [String] = [
    "CbqyWHegEa",
    "xkQjfw69Pa",
    "KhBa5VMZ9x",
    "63stkpVfwY",
    "aNrkDPLcp7",
    "rATX4BPMpr",
    "YwGKC7DW9B",
    "Jzt3aPaFVR",
    "KygMk9YTHH",
    "j4v3dturxp",
    "g2MSZQmNXB",
    "pJrQsEYU4t",
    "L6VsASMkdG",
    "g6fAvtMmyz",
    "ZztnNrXwvy",
    "Qyty3zTCxS",
    "7xmPC2ERCa",
    "9jyMXDSF9Z",
    "KGBTdSEWNQ",
    "p4hw7gwvwk",
    "gZcm3bLfAa",
    "rzePYCUSSa",
    "SGuACTtPPX",
    "EkjFXeG7Xr",
    "F8hfNVwrE3",
    "77Mg8gpT7R",
    "CtwsVqe5pc",
    "jhBJWQs6M3",
    "ZbQTzzfjGh",
    "Lcp6MCwRWW",
    "CDB972LvWm",
    "sxH9Nb5qVD",
    "HwF7gBWUYe",
    "jDBA2zrDac",
    "kxJ7qas3HN",
    "YJJBBX3auz",
    "qyvpWbqGc7",
    "q3txKBxp9M",
    "KQ5fgNgLKz",
    "q43NKHMFBF",
    "Sf78WV4wE5",
    "ncTaYyBtEv",
    "7q8dXpYSNY",
    "aawU4TfZSf",
    "nqXCmhQHTs",
    "gT4JxUrDBf",
    "StPuBTFks3",
    "LvUKDrtWUK",
    "7KpyY5aGF4",
    "yW7b8Yj3dY",
    "sAUb9dR9sj",
    "D39yHBgRKu",
    "UcVbCGUZwQ",
    "N5yccAE7bM",
    "m3Wz5jwcZ4",
    "fJPMkAvfsm",
    "ccWuwU48BU",
    "ktQxKRwEh5",
    "LFhvUvVqdt",
    "SZW6b3qa4L",
    "s8HrZWM2CZ",
    "xdtfmMe6gN",
    "TSmQP4SZny",
    "JuVeB8QXhk",
    "DuPvYUdzM9",
    "fHNMrksUzn",
    "kpcJ7CFGrS",
    "fPbUrKDdE3",
    "DbAGXgQ6AZ",
    "vv2rVbK2LC",
    "2pywmHxUvp",
    "tf3r2QfBwY",
    "f2s9F9mAqr",
    "qNGpVEQBw2",
    "aurbx7ys4r",
    "4asWXF4SxC",
    "p4hQCC8XgY",
    "EeaE3Gr6dN",
    "5ywKtGH5wt",
    "LDH4gaVTHP",
    "SUTFEDaytk",
    "WUTvaNBNFJ",
    "UcBzuA4hw9",
    "4SxcVHgXeC",
    "K3zQ4NQ3Dk",
    "VhfYWaX6mX",
    "kYuGL4ZfZV",
    "tV3K9FhpfH",
    "cz5WB9WPjs",
    "LkgknyhjJy",
    "ZFCdj2N2f5",
    "H89a7uzJG8",
    "tTdNBD3F6M",
    "arSKjFSPWF",
    "UfkgDtJAQT",
    "T6kynVFZzD",
    "gpMJGeKyTc",
    "dP5WBx8vrt",
    "VCkpeSXPvq",
    "ZJTpn23537",
]
