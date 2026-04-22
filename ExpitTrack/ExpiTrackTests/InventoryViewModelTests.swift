import XCTest
@testable import ExpiTrack

@MainActor
final class InventoryViewModelTests: XCTestCase {

    func testAddItem() {
        let vm = InventoryViewModel()

        vm.addItem(
            name: "Apple",
            quantity: "2",
            expirationDate: Date(),
            storageLocation: .fridge,
            image: nil,
            savePhotoTemplate: false
        )

        XCTAssertEqual(vm.allItems.count, 1)
        XCTAssertEqual(vm.allItems.first?.name, "Apple")
    }

    func testDeleteItem() {
        let vm = InventoryViewModel()

        vm.addItem(
            name: "Banana",
            quantity: "1",
            expirationDate: Date(),
            storageLocation: .fridge,
            image: nil,
            savePhotoTemplate: false
        )

        let item = vm.allItems.first!
        vm.deleteItem(item)

        XCTAssertTrue(vm.allItems.isEmpty)
    }
}
