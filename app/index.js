// app/index.js
import { useRouter } from "expo-router";
import {
  FlatList,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

export default function HomeScreen() {
  const router = useRouter();

  // Example dummy data
  const items = [
    { id: "1", name: "Milk", status: "fresh" },
    { id: "2", name: "Eggs", status: "expiring" },
    { id: "3", name: "Bread", status: "expired" },
    { id: "4", name: "Cheese", status: "fresh" },
  ];

  const getStatusColor = (status) => {
    if (status === "fresh") return "#2ECC40";
    if (status === "expiring") return "#FF851B";
    if (status === "expired") return "#FF4136";
    return "#aaa";
  };

  return (
    <View style={styles.container}>
      <Text style={styles.header}>My Inventory</Text>

      <FlatList
        data={items}
        numColumns={2}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.listContainer}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={styles.itemCard}
            onPress={() => console.log("Open item:", item.name)}
          >
            <Text style={styles.itemText}>{item.name}</Text>

            <View
              style={[
                styles.statusBadge,
                { backgroundColor: getStatusColor(item.status) },
              ]}
            >
              <Text style={styles.statusText}>
                {item.status.toUpperCase()}
              </Text>
            </View>
          </TouchableOpacity>
        )}
      />

      <TouchableOpacity
        style={styles.addButton}
        onPress={() => router.push("/add-item")}
      >
        <Text style={styles.addButtonText}>+ Add Item</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#001f3f",
    padding: 20,
  },
  header: {
    color: "#d3d3d3",
    fontSize: 28,
    fontWeight: "bold",
    marginBottom: 20,
  },
  listContainer: {
    paddingBottom: 120,
  },
  itemCard: {
    flex: 1,
    backgroundColor: "#111111",
    padding: 20,
    borderRadius: 18,
    margin: 8,
    justifyContent: "space-between",
    shadowColor: "#000",
    shadowOpacity: 0.3,
    shadowRadius: 6,
    elevation: 6,
    minHeight: 120,
  },
  itemText: {
    color: "#fff",
    fontSize: 18,
    fontWeight: "600",
  },
  statusBadge: {
    marginTop: 15,
    paddingVertical: 6,
    paddingHorizontal: 10,
    borderRadius: 20,
    alignSelf: "flex-start",
  },
  statusText: {
    color: "#fff",
    fontSize: 12,
    fontWeight: "bold",
  },
  addButton: {
    position: "absolute",
    bottom: 30,
    right: 20,
    backgroundColor: "#0074D9",
    paddingVertical: 15,
    paddingHorizontal: 25,
    borderRadius: 30,
    shadowColor: "#000",
    shadowOpacity: 0.3,
    shadowRadius: 4,
    elevation: 5,
  },
  addButtonText: {
    color: "#fff",
    fontWeight: "bold",
    fontSize: 16,
  },
});