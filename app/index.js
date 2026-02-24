// app/index.js
import { useRouter } from "expo-router";
import React from "react";
import {
  FlatList,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

export default function HomeScreen() {
  const router = useRouter();

  // Example dummy data for items
  const items = [
    { id: "1", name: "Milk" },
    { id: "2", name: "Eggs" },
    { id: "3", name: "Bread" },
  ];

  return (
    <View style={styles.container}>
      <Text style={styles.header}>Grocery List</Text>

      <FlatList
        data={items}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.listContainer}
        renderItem={({ item }) => (
          <View style={styles.itemCard}>
            <Text style={styles.itemText}>{item.name}</Text>
          </View>
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
    backgroundColor: "#001f3f", // navy blue
    padding: 20,
  },
  header: {
    color: "#d3d3d3", // light grey for contrast
    fontSize: 32,
    fontWeight: "bold",
    marginBottom: 20,
  },
  listContainer: {
    paddingBottom: 100,
  },
  itemCard: {
    backgroundColor: "#111111", // dark grey
    padding: 15,
    borderRadius: 10,
    marginBottom: 10,
  },
  itemText: {
    color: "#fff",
    fontSize: 18,
  },
  addButton: {
    position: "absolute",
    bottom: 30,
    right: 20,
    backgroundColor: "#0074D9", // bright blue accent
    paddingVertical: 15,
    paddingHorizontal: 25,
    borderRadius: 30,
  },
  addButtonText: {
    color: "#fff",
    fontWeight: "bold",
    fontSize: 16,
  },
});
