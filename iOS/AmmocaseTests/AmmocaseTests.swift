import XCTest
@testable import Ammocase

@MainActor
final class AmmocaseTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
    }

    func testSeedDataStaysUnderFreeLimit() {
        XCTAssertLessThan(Store.seedData.count, Store.freeLimit)
    }

    func testAddItem() {
        store.add(name: "Test Lot", caliber: "9mm", quantity: "250")
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.name, "Test Lot")
    }

    func testCanAddBelowLimit() {
        XCTAssertTrue(store.canAdd())
    }

    func testFreeLimitBlocksAdd() {
        for i in 0..<Store.freeLimit {
            store.add(name: "Item \(i)", caliber: "9mm", quantity: "250")
        }
        XCTAssertFalse(store.canAdd())
        XCTAssertTrue(store.isAtFreeLimit)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(name: "Item \(i)", caliber: "9mm", quantity: "250")
        }
        XCTAssertTrue(store.canAdd())
    }

    func testDeleteItem() {
        store.add(name: "ToDelete", caliber: "9mm", quantity: "250")
        let item = store.items[0]
        store.delete(item)
        XCTAssertEqual(store.items.count, 0)
    }

    func testUpdateItem() {
        store.add(name: "Original", caliber: "9mm", quantity: "250")
        var item = store.items[0]
        item.name = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.name, "Updated")
    }

    func testDeleteAtOffsets() {
        store.add(name: "A", caliber: "9mm", quantity: "250")
        store.add(name: "B", caliber: "9mm", quantity: "250")
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.name, "B")
    }
}
