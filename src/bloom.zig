const std = @import("std");
const BitArray = @import("./bitarray.zig").BitArray;

pub fn BloomFilter(comptime KeyType: type) type {
    return struct {
        const Self = @This();

        pub fn add(self: *Self, key: KeyType) void {}

        pub fn has(self: Self, key: KeyType) bool {
            return false;
        }

        pub fn clear(self: *Self) void {}
    };
}

const testing = std.testing;
const expect = testing.expect;

test "bloom filter, integer keys" {
    var bloom = BloomFilter(i32){};
    bloom.add(5);
    expect(bloom.has(5));

    expect(!bloom.has(-4));
    bloom.add(-4);
    expect(bloom.has(-4));
}
