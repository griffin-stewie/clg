//
//  NSFileHandle+Z.swift
//  ZKit
//
//  Created by Kaz Yoshikawa on 2/18/16.
//
//

import Foundation

extension FileHandle {

	// read write as is

	private func read<T>() -> T? {
        let size = MemoryLayout<T>.size
        let data = self.readData(ofLength: size)
        if data.count == size {
            return data.withUnsafeBytes { $0.load(as: T.self) }
		}
		return nil
	}

	private func write<T>(value: T) {
		var value = value
        let size = MemoryLayout<T>.size
        let data = NSData(bytes: &value, length: size)
        self.write(data as Data)
	}

	// unsigned integers
	
	func readUInt16() -> UInt16? {
		if let value = self.read() as UInt16? {
			return CFSwapInt16BigToHost(value)
		}
		return nil
	}

	func writeUInt16(value: UInt16) {
		let value16 = CFSwapInt16HostToBig(value)
        self.write(value: value16)
	}
	
	func readUInt32() -> UInt32? {
		if let value = self.read() as UInt32? {
			return CFSwapInt32BigToHost(value)
		}
		return nil
	}

	func writeUInt32(value: UInt32) {
		let value = CFSwapInt32HostToBig(value)
		self.write(value: value)
	}

	func readUInt64() -> UInt64? {
		if let value = self.read() as UInt64? {
			return CFSwapInt64BigToHost(value)
		}
		return nil
	}

	func writeUInt64(value: UInt64) {
		let value = CFSwapInt64HostToBig(value)
		self.write(value: value)
	}

	// signed integers

	func readInt16() -> Int16? {
		if let value = self.readUInt16() {
			return Int16(value)
		}
		return nil
	}

	func writeInt16(value: Int16) {
		self.write(value: CFSwapInt16HostToBig(UInt16(value)))
	}

	func readInt32() -> Int32? {
		if let value = self.readUInt32() {
			return Int32(value)
		}
		return nil
	}

	func writeInt32(value: Int32) {
		self.write(value: CFSwapInt32HostToBig(UInt32(value)))
	}

	func readInt64() -> Int64? {
		if let value = self.readUInt64() {
			return Int64(value)
		}
		return nil
	}

	func writeInt64(value: Int64) {
		self.write(value: CFSwapInt64HostToBig(UInt64(value)))
	}

	// float and double

	func readFloat() -> Float? {
		switch UInt32(CFByteOrderGetCurrent()) {
		case CFByteOrderLittleEndian.rawValue:
			if let value = self.read() as CFSwappedFloat32? {
				return CFConvertFloat32SwappedToHost(value)
			}
		case CFByteOrderBigEndian.rawValue:
			return self.read() as Float?
		default: fatalError("Unknown Endian")
		}
		return nil
	}
	
	func writeFloat(value: Float) {
		switch UInt32(CFByteOrderGetCurrent()) {
		case CFByteOrderLittleEndian.rawValue:
			self.write(value: CFConvertFloat32HostToSwapped(value))
		case CFByteOrderBigEndian.rawValue:
			self.write(value: value)
		default: fatalError("Unknown Endian")
		}
	}

	func readDouble() -> Double? {
		switch UInt32(CFByteOrderGetCurrent()) {
		case CFByteOrderLittleEndian.rawValue:
			if let value = self.read() as CFSwappedFloat64? {
				return CFConvertFloat64SwappedToHost(value)
			}
		case CFByteOrderBigEndian.rawValue:
			return self.read() as Float64?
		default: fatalError("Unknown Endian")
		}
		return nil
	}
	
	func writeDouble(value: Double) {
		switch UInt32(CFByteOrderGetCurrent()) {
		case CFByteOrderLittleEndian.rawValue:
			self.write(value: CFConvertFloat64HostToSwapped(value))
		case CFByteOrderBigEndian.rawValue:
			self.write(value: value)
		default: fatalError("Unknown Endian")
		}
	}
	
}
