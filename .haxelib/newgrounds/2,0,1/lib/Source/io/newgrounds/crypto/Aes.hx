package io.newgrounds.crypto;

import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;

class Aes {
	
	var key:Bytes;
	var roundKey:Vector<Int>;
	
	public function new(key:Bytes) {
		
		this.key = key;
		roundKey = CBC.keyExpansion(key);
	}
	
	public function encrypt(data:Bytes):Bytes {
		
		var iv = generateIV();
		
		var out = CBC.encrypt(PKCS7.pad(data), iv, this);
		
		var buffer = new BytesBuffer();
		buffer.add(iv);
		buffer.add(out);
		return buffer.getBytes();
	}
	
	public function decrypt(data:Bytes):Bytes {
		
		var iv = data.sub(0, 16);
		
		var out = data.sub(16, data.length - 16);
		out = CBC.decrypt(out, iv, this);
		return PKCS7.unpad(out);
	}
	
	static function generateIV(bytes = 16) {
		
		var iv = Bytes.alloc(bytes);
		for(i in 0...bytes)
			iv.set(i, Math.floor(Math.random() * 256));
		
		return iv;
	}
}

/**
 * Everything after this point was stolen from
 * [Github: HaxeFoundation/Crypto](https://github.com/HaxeFoundation/crypto/blob/master/src/haxe/crypto/Aes.hx).
 * It was stripped down to the bare essentials, and stylistically changed, heavily and lightly
 * optimised, but all credit goes to the Haxe Foundation. You guys rule!
 * 
 * MIT License
 * Copyright (C)2005-2019 Haxe Foundation
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 * BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**/

@:access(io.newgrounds.crypto.Aes)
private class CBC {
	
	public static var SBOX = Vector.fromArrayCopy(
		[ 0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76
		, 0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0
		, 0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15
		, 0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75
		, 0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84
		, 0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf
		, 0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8
		, 0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2
		, 0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73
		, 0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb
		, 0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79
		, 0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08
		, 0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a
		, 0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e
		, 0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf
		, 0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
		]
	);
	
	public static var RSBOX = Vector.fromArrayCopy(
		[ 0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb
		, 0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb
		, 0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e
		, 0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25
		, 0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92
		, 0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84
		, 0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06
		, 0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b
		, 0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73
		, 0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e
		, 0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b
		, 0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4
		, 0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f
		, 0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef
		, 0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61
		, 0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
		]
	);
	
	public static var POWER3 = Vector.fromArrayCopy(
		[ 0x01, 0x03, 0x05, 0x0f, 0x11, 0x33, 0x55, 0xff, 0x1a, 0x2e, 0x72, 0x96, 0xa1, 0xf8, 0x13, 0x35
		, 0x5f, 0xe1, 0x38, 0x48, 0xd8, 0x73, 0x95, 0xa4, 0xf7, 0x02, 0x06, 0x0a, 0x1e, 0x22, 0x66, 0xaa
		, 0xe5, 0x34, 0x5c, 0xe4, 0x37, 0x59, 0xeb, 0x26, 0x6a, 0xbe, 0xd9, 0x70, 0x90, 0xab, 0xe6, 0x31
		, 0x53, 0xf5, 0x04, 0x0c, 0x14, 0x3c, 0x44, 0xcc, 0x4f, 0xd1, 0x68, 0xb8, 0xd3, 0x6e, 0xb2, 0xcd
		, 0x4c, 0xd4, 0x67, 0xa9, 0xe0, 0x3b, 0x4d, 0xd7, 0x62, 0xa6, 0xf1, 0x08, 0x18, 0x28, 0x78, 0x88
		, 0x83, 0x9e, 0xb9, 0xd0, 0x6b, 0xbd, 0xdc, 0x7f, 0x81, 0x98, 0xb3, 0xce, 0x49, 0xdb, 0x76, 0x9a
		, 0xb5, 0xc4, 0x57, 0xf9, 0x10, 0x30, 0x50, 0xf0, 0x0b, 0x1d, 0x27, 0x69, 0xbb, 0xd6, 0x61, 0xa3
		, 0xfe, 0x19, 0x2b, 0x7d, 0x87, 0x92, 0xad, 0xec, 0x2f, 0x71, 0x93, 0xae, 0xe9, 0x20, 0x60, 0xa0
		, 0xfb, 0x16, 0x3a, 0x4e, 0xd2, 0x6d, 0xb7, 0xc2, 0x5d, 0xe7, 0x32, 0x56, 0xfa, 0x15, 0x3f, 0x41
		, 0xc3, 0x5e, 0xe2, 0x3d, 0x47, 0xc9, 0x40, 0xc0, 0x5b, 0xed, 0x2c, 0x74, 0x9c, 0xbf, 0xda, 0x75
		, 0x9f, 0xba, 0xd5, 0x64, 0xac, 0xef, 0x2a, 0x7e, 0x82, 0x9d, 0xbc, 0xdf, 0x7a, 0x8e, 0x89, 0x80
		, 0x9b, 0xb6, 0xc1, 0x58, 0xe8, 0x23, 0x65, 0xaf, 0xea, 0x25, 0x6f, 0xb1, 0xc8, 0x43, 0xc5, 0x54
		, 0xfc, 0x1f, 0x21, 0x63, 0xa5, 0xf4, 0x07, 0x09, 0x1b, 0x2d, 0x77, 0x99, 0xb0, 0xcb, 0x46, 0xca
		, 0x45, 0xcf, 0x4a, 0xde, 0x79, 0x8b, 0x86, 0x91, 0xa8, 0xe3, 0x3e, 0x42, 0xc6, 0x51, 0xf3, 0x0e
		, 0x12, 0x36, 0x5a, 0xee, 0x29, 0x7b, 0x8d, 0x8c, 0x8f, 0x8a, 0x85, 0x94, 0xa7, 0xf2, 0x0d, 0x17
		, 0x39, 0x4b, 0xdd, 0x7c, 0x84, 0x97, 0xa2, 0xfd, 0x1c, 0x24, 0x6c, 0xb4, 0xc7, 0x52, 0xf6
		]
	);
	
	public static var LOG3 = Vector.fromArrayCopy(
		[   0,   0,  25,   1,  50,   2,  26, 198,  75, 199,  27, 104,  51, 238, 223,   3
		, 100,   4, 224,  14,  52, 141, 129, 239,  76, 113,   8, 200, 248, 105,  28, 193
		, 125, 194,  29, 181, 249, 185,  39, 106,  77, 228, 166, 114, 154, 201,   9, 120
		, 101,  47, 138,   5,  33,  15, 225,  36,  18, 240, 130,  69,  53, 147, 218, 142
		, 150, 143, 219, 189,  54, 208, 206, 148,  19,  92, 210, 241,  64,  70, 131,  56
		, 102, 221, 253,  48, 191,   6, 139,  98, 179,  37, 226, 152,  34, 136, 145,  16
		, 126, 110,  72, 195, 163, 182,  30,  66,  58, 107,  40,  84, 250, 133,  61, 186
		,  43, 121,  10,  21, 155, 159,  94, 202,  78, 212, 172, 229, 243, 115, 167,  87
		, 175,  88, 168,  80, 244, 234, 214, 116,  79, 174, 233, 213, 231, 230, 173, 232
		,  44, 215, 117, 122, 235,  22,  11, 245,  89, 203,  95, 176, 156, 169,  81, 160
		, 127,  12, 246, 111,  23, 196,  73, 236, 216,  67,  31,  45, 164, 118, 123, 183
		, 204, 187,  62,  90, 251,  96, 177, 134,  59,  82, 161, 108, 170,  85,  41, 157
		, 151, 178, 135, 144,  97, 190, 220, 252, 188, 149, 207, 205,  55,  63,  91, 209
		,  83,  57, 132,  60,  65, 162, 109,  71,  20,  42, 158,  93,  86, 242, 211, 171
		,  68,  17, 146, 217,  35,  32,  46, 137, 180, 124, 184,  38, 119, 153, 227, 165
		, 103,  74, 237, 222, 197,  49, 254,  24,  13,  99, 140, 128, 192, 247, 112,   7
		]
	);
	
	public static var RCON = Vector.fromArrayCopy([0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36]);
	
	inline public static var BLOCK_SIZE = 16;
	inline public static var NB = 4;
	
	public static function keyExpansion(key:Bytes)
	{
		var nk = key.length >> 2;
		var nr = nk + 6; 
		
		var roundKey = new Vector<Int>(4 * NB * (nr + 1));
		var temp = new Vector<Int>(NB);
		
		for (i in 0...nk) {
			
			for (j in 0...4)
				roundKey[4 * i + j] = key.get(4 * i + j);
		}
		
		for (i in nk...(NB*(nr+1))) {
			
			for ( j in 0...NB)
				temp[j] = roundKey[4 * (i - 1) + j];
			
			if (i % nk == 0) {
				
				temp = subWord(rotWord(temp));
				var k = Std.int(i / nk);
				temp[0] ^= RCON[k];
				
			} else if (nk > 6 && (i % nk == 4) )
				temp = subWord(temp);
			
			var k = i * 4;
			var m = (i - nk) * 4;
			for (j in 0...NB) roundKey[k + j] = roundKey[m + j] ^ temp[j];
		}
		
		return roundKey;
	}
	
	static function rotWord(w:Vector<Int>):Vector<Int> {
		
		var tmp:Int = w[0];
		for(i in 0...3)  w[i] = w[i+1];
		w[3] = tmp;
		return w;
	}
	
	static function subWord(w:Vector<Int>):Vector<Int> {
		
		for(i in 0...4)
			w[i] = SBOX[w[i]];
		
		return w;
	}
	
	public static function encrypt(src:Bytes, iv:Bytes, aes:Aes) {
		
		var block = new Block();
		var out = src.sub(0, src.length);
		var vector = iv.sub(0, iv.length);
		var i = 0;
		var len = out.length;
		while (i < len) {
			
			for (j in 0...BLOCK_SIZE)
				out.set(i + j, out.get(i + j) ^ vector.get(j) );
			
			block.readBytes(out, i);
			block.encrypt(aes);
			block.writeBytes(out, i);
			
			vector = out.sub(i, BLOCK_SIZE);
			i += BLOCK_SIZE;
		}
		
		return out;
	}
	
	public static function decrypt(src:Bytes, iv:Bytes, aes:Aes) {
		
		var block = new Block();
		var out = src.sub(0, src.length);
		var vpos = out.length - BLOCK_SIZE;
		var i = out.length;
		while(i > 0) {
			
			i -= BLOCK_SIZE;
			vpos -= BLOCK_SIZE;
			
			block.readBytes(out, i);
			block.decrypt(aes);
			block.writeBytes(out, i);
			
			if (vpos < 0) {
				
				for (j in 0 ... BLOCK_SIZE) 
					out.set(j, out.get(j) ^ iv.get(j));
				
			} else {
				
				for (j in 0 ... BLOCK_SIZE) 
					out.set(i + j, out.get(i + j) ^ out.get(vpos + j));
			}
		}
		return out;
	}
}

@:access(io.newgrounds.crypto.Aes)
private abstract Block(Vector<Vector<Int>>) {
	
	inline static var NB = CBC.NB;
	inline static var BLOCK_SIZE = CBC.BLOCK_SIZE;
	
	public function new() {
		
		this = new Vector<Vector<Int>>(4);
	}
	
	public function readBytes(data:Bytes, index:Int) {
		
		for(i in 0...4) {
			
			this[i] = new Vector<Int>(4);
			
			for(j in 0...4)
				this[i][j] = data.get(4 * i + index + j);
		}
		
		return this;
	}
	
	public function writeBytes(data:Bytes, index:Int) {
		
		for(i in 0...4) {
			
			for(j in 0...4)
				data.set(4 * i + j + index, get(i, j));
		}
	}
	
	inline public function get(i:Int, j:Int) { return this[i][j]; }
	
	public function encrypt(aes:Aes):Void {
		
		addRoundKey(aes.roundKey, 0); 
		
		var nr = (aes.key.length >> 2) + 6;
		for (round in 1...nr)
		{
			subBytes();
			shiftRows();
			mixColumns();
			addRoundKey(aes.roundKey, round);
		}
		
		subBytes();
		shiftRows();
		addRoundKey(aes.roundKey, nr);
	}
	
	public function decrypt(aes:Aes):Void {
		
		var nr = (aes.key.length >> 2) + 6;
		addRoundKey(aes.roundKey, nr);
		
		var round = nr - 1;
		while (round > 0) {
			
			invShiftRows();
			invSubBytes();
			addRoundKey(aes.roundKey, round);
			invMixColumns();
			round--;
		}
		
		invShiftRows();
		invSubBytes();
		addRoundKey(aes.roundKey, 0);
	}
	
	public function subBytes() {
		
		for (i in 0...4) {
			
			for (j in 0...4)
				this[i][j] = CBC.SBOX[this[i][j]];
		}
	}
	
	public function shiftRows() {
		
		var temp = new Vector<Int>(4);
		for (i in 1...4) {
			
			for (j in 0...4)
				temp[j] = this[(j + i) % 4][i];
			
			for (j in 0...4)
				this[j][i] = temp[j];
		}
	}
	
	public function mixColumns():Void
	{
		var temp = new Vector<Int>(4);
		for (i in 0...4) {
			
			for (j in 0...4)
				temp[j] = this[i][j];
			
			for (j in 0...4) {
				
				this[i][j]
					= mul(0x02, temp[j])
					^ mul(0x03, temp[(j + 1) % 4])
					^ mul(0x01, temp[(j + 2) % 4])
					^ mul(0x01, temp[(j + 3) % 4]);
			}
		}
	}
	
	public function invMixColumns():Void
	{
		var temp = new Vector<Int>(4);
		for (i in 0...4) {
			
			for (j in 0...4)
				temp[j] = this[i][j];
			
			for (j in 0...4) {
				
				this[i][j]
					= mul(0x0e, temp[j])
					^ mul(0x0b, temp[(j + 1) % 4])
					^ mul(0x0d, temp[(j + 2) % 4])
					^ mul(0x09, temp[(j + 3) % 4]);
			}
		}
	}
	
	public function invSubBytes() {
		
		for(i in 0...4) {
			
			for(j in 0...4)
				this[j][i] = CBC.RSBOX[this[j][i]];
		}
	}
	
	public function invShiftRows() {
		
		var temp = new Vector<Int>(4);
		for (i in 1...4) {
			
			for (j in 0...4)
				temp[j] = this[(j - i + 4) % 4][i];
			
			for (j in 0...4)
				this[j][i] = temp[j];
		}
	}
	
	public function addRoundKey(roundKey:Vector<Int>, round:Int) {
		
		round <<= 2;
		for (i in 0...4) {
			
			for(j in 0...NB)
				this[i][j] ^= roundKey[round * 4 + i * NB + j];
		}
	}
	
	static function mul(a:Int, b:Int):Int
	{
		return a != 0 && b != 0
			? CBC.POWER3[(CBC.LOG3[a] + CBC.LOG3[b]) % 255]
			: 0;
	}
}

private class PKCS7 {
	
	public static function pad(ciphertext:Bytes):Bytes {
		
		if (CBC.BLOCK_SIZE > 255) throw "PKCS#7 padding cannot be longer than 255 bytes";
		if (CBC.BLOCK_SIZE < 0  ) throw "PKCS#7 padding size must be positive";
		
		var buffer = new BytesBuffer();
		buffer.addBytes(ciphertext, 0, ciphertext.length);
		
		var padding = CBC.BLOCK_SIZE - ciphertext.length % CBC.BLOCK_SIZE;
		for(i in 0...padding)
			buffer.addByte(padding & 0xFF); 
		
		return buffer.getBytes();
	}
	
	public static  function unpad(encrypt:Bytes):Bytes {
		
		var padding = encrypt.get(encrypt.length - 1);
		if (padding > encrypt.length)
			throw 'Cannot remove $padding bytes, because message is ${encrypt.length} bytes';
		
		var block = encrypt.length - padding;
		for(i in block...encrypt.length) {
			
			if (encrypt.get(i) != padding)
				throw 'Invalid padding value. Got ${encrypt.get(i)}, expected $padding at position $i';
		}
		
		return encrypt.sub(0, block);
	}
}