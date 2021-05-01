const std = @import("std");
const assert = std.debug.assert;

pub const BitArray = struct {
    // TODO make size configurable
    array: u128 = 0,

    const size = @bitSizeOf(array);

    pub fn get(self: BitArray, idx: u7) bool {
        return ((@as(@TypeOf(self.array), 1) << idx) & self.array) != 0;
    }

    pub fn set(self: *BitArray, idx: u7) void {
        self.array |= @as(@TypeOf(self.array), 1) << idx;
    }

    pub fn unset(self: *BitArray, idx: u7) void {
        self.array &= std.math.maxInt(@TypeOf(self.array)) ^ @as(@TypeOf(self.array), 1) << idx;
    }

    // returns new value
    pub fn toggle(self: *BitArray, idx: u7) bool {
        if (self.get(idx)) {
            self.unset(idx);
            return false;
        }
        self.set(idx);
        return true;
    }

    pub fn clear(self: *BitArray) void {
        self.array = 0;
    }
};

const testing = std.testing;
const log = std.log;
const expect = std.testing.expect;

test "bit array" {
    var arr = BitArray{};

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
    var arr = BitArray{};

    var idx: u7 = 0;
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
