const std = @import("std");
const mem = std.mem;
const assert = std.debug.assert;

pub fn BitArray(size: usize) type {
    assert(size % 64 == 0);

    return struct {
        array: [size / 64]u64 = [_]u64{0} ** (size / 64),

        const Self = @This();
        const MAX_U64 = std.math.maxInt(u64);

        pub fn get(self: Self, idx: usize) bool {
            assert(idx < size);

            return ((@as(u64, 1) << @truncate(u6, idx)) & self.array[idx / 64]) != 0;
        }

        pub fn set(self: *Self, idx: usize) void {
            assert(idx < size);

            self.array[idx / 64] |= @as(u64, 1) << @truncate(u6, idx);
        }

        pub fn unset(self: *Self, idx: usize) void {
            assert(idx < size);

            self.array[idx / 64] &= MAX_U64 ^ @as(u64, 1) << @truncate(u6, idx);
        }

        // returns new value
        pub fn toggle(self: *Self, idx: usize) bool {
            if (self.get(idx)) {
                self.unset(idx);
                return false;
            }
            self.set(idx);
            return true;
        }

        pub fn clear(self: *Self) void {
            self.array = [_]u64{0} ** (size / 64);
        }
    };
}

const testing = std.testing;
const log = std.log;
const expect = std.testing.expect;

test "bit array" {
    var arr = BitArray(64){};

    expect(!arr.get(5));

    arr.set(5);
    expect(arr.get(5));

    arr.unset(5);
    expect(!arr.get(5));

    expect(!arr.get(4));

    expect(arr.toggle(4));
    expect(arr.get(4));

    arr.clear();
    expect(!arr.get(4));
    expect(!arr.get(5));
}

test "fill bit array" {
    var arr = BitArray(128){};

    var idx: usize = 0;
    while (idx < 127) : (idx += 1) {
        arr.set(idx);
        expect(arr.get(idx));
    }

    arr.clear();

    idx = 0;
    while (idx < 127) : (idx += 1) {
        expect(!arr.get(idx));
    }
}
