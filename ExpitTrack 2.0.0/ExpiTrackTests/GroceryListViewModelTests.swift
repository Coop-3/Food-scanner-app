import XCTest
@testable import ExpiTrack

@MainActor
final class GroceryListViewModelTests: XCTestCase {

    func testOnlyExpiringSoonItemsAreSuggested() {
        let vm = GroceryListViewModel()

        let items = [
            FoodItem(
                name: "Milk",
                quantity: "1",
                expirationDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!
            ),
            FoodItem(
                name: "Rice",
                quantity: "1",
                expirationDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())!
            )
        ]

        vm.refreshSuggestions(from: items)

        XCTAssertEqual(vm.suggestedItems.count, 1)
        XCTAssertEqual(vm.suggestedItems.first?.name, "Milk")
    }

    func testAddingSuggestionsMovesItemsToList() {
        let vm = GroceryListViewModel()

        let item = FoodItem(
            name: "Eggs",
            quantity: "1",
            expirationDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        )

        vm.refreshSuggestions(from: [item])
        vm.addPendingSuggestions()

        XCTAssertEqual(vm.items.count, 1)
        XCTAssertTrue(vm.suggestedItems.isEmpty)
    }
}
